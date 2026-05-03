import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../data/countries_data.dart';
import '../models/country_model.dart';

/// When pasting an international number resolves to more than one country
/// (e.g. several countries share `+1`), controls which [CountryModel] is chosen.
enum PasteAmbiguityPolicy {
  /// If the selected country matches the dial prefix, keep it; otherwise same as [preferPriorityList].
  preferCurrentCountry,

  /// First country in the picker priority list order, then alphabetical ISO.
  preferPriorityList,

  /// Lexicographic ISO code (stable, deterministic).
  firstAlphabeticalByIso,
}

CountryModel? _resolvePasteCountry({
  required List<CountryModel> matches,
  required CountryModel current,
  required List<String> priorityIsoCodes,
  required PasteAmbiguityPolicy policy,
}) {
  if (matches.isEmpty) return null;
  if (matches.length == 1) return matches.first;

  bool currentMatches() => matches.any((c) => c.isoCode == current.isoCode);

  CountryModel firstFromPriority() {
    for (final code in priorityIsoCodes) {
      final hit = matches.where((c) => c.isoCode == code).toList();
      if (hit.isNotEmpty) return hit.first;
    }
    final sorted = [...matches]..sort((a, b) => a.isoCode.compareTo(b.isoCode));
    return sorted.first;
  }

  switch (policy) {
    case PasteAmbiguityPolicy.preferCurrentCountry:
      if (currentMatches()) return current;
      return firstFromPriority();
    case PasteAmbiguityPolicy.preferPriorityList:
      return firstFromPriority();
    case PasteAmbiguityPolicy.firstAlphabeticalByIso:
      final sorted = [...matches]..sort((a, b) => a.isoCode.compareTo(b.isoCode));
      return sorted.first;
  }
}

/// Strips international prefix on paste (`+…` or `00…`), updates the selected country, and keeps national digits only.
class InternationalPasteFormatter extends TextInputFormatter {
  /// Creates an international paste formatter.
  InternationalPasteFormatter({
    required this.countries,
    required this.priorityIsoCodes,
    required this.currentCountry,
    required this.policy,
    required this.onCountryResolved,
    this.enabled = true,
  });

  /// Candidate countries (same list as the picker).
  final List<CountryModel> countries;

  /// ISO codes in priority order (same as the phone field's priority list).
  final List<String> priorityIsoCodes;

  /// Currently selected country (read when formatting runs).
  final CountryModel Function() currentCountry;

  /// How to break ties when several countries share the same dial prefix.
  final PasteAmbiguityPolicy policy;

  /// Called after frame when paste implies a new country (may match the current one).
  final ValueChanged<CountryModel> onCountryResolved;

  /// When `false`, behaves like digits-only input (no paste detection).
  final bool enabled;

  static bool _isBulkChange(TextEditingValue oldValue, TextEditingValue newValue) {
    return (newValue.text.length - oldValue.text.length).abs() >= 5;
  }

  static String _digitizeInternational(String raw) {
    var d = raw.replaceAll(RegExp(r'\D'), '');
    if (d.startsWith('00')) d = d.substring(2);
    return d;
  }

  static bool _shouldAttemptInternational({
    required TextEditingValue oldValue,
    required TextEditingValue newValue,
    required String digitized,
  }) {
    if (digitized.length < 9) return false;
    final raw = newValue.text;
    final hasPlus = raw.contains('+');
    final hasExitCode = raw.trimLeft().startsWith('00');
    final bulk = _isBulkChange(oldValue, newValue);
    if (!hasPlus && !hasExitCode && !bulk) return false;
    return true;
  }

  static ({CountryModel country, String national})? _tryParse({
    required String rawNew,
    required List<CountryModel> countries,
    required CountryModel current,
    required List<String> priorityIsoCodes,
    required PasteAmbiguityPolicy policy,
  }) {
    final digitized = _digitizeInternational(rawNew);
    final hasPlus = rawNew.contains('+');
    final hasExitCode = rawNew.trimLeft().startsWith('00');
    final allowSingleDigitCountryCode = hasPlus || hasExitCode;

    final matches = CountriesData.countriesMatchingLeadingDigits(digitized, countries);
    final viable = matches
        .where((c) {
          final plen = c.dialCode.replaceFirst('+', '').length;
          return plen >= 2 || allowSingleDigitCountryCode;
        })
        .toList();

    if (viable.isEmpty) return null;

    final country = _resolvePasteCountry(
      matches: viable,
      current: current,
      priorityIsoCodes: priorityIsoCodes,
      policy: policy,
    );
    if (country == null) return null;

    final prefixLen = country.dialCode.replaceFirst('+', '').length;
    if (prefixLen >= digitized.length) return null;

    final national = digitized.substring(prefixLen);
    if (national.isEmpty) return null;

    return (country: country, national: national);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!enabled) {
      return FilteringTextInputFormatter.digitsOnly.formatEditUpdate(oldValue, newValue);
    }

    final digitizedProbe = _digitizeInternational(newValue.text);
    if (_shouldAttemptInternational(oldValue: oldValue, newValue: newValue, digitized: digitizedProbe)) {
      final parsed = _tryParse(
        rawNew: newValue.text,
        countries: countries,
        current: currentCountry(),
        priorityIsoCodes: priorityIsoCodes,
        policy: policy,
      );
      if (parsed != null) {
        final c = parsed.country;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          onCountryResolved(c);
        });
        return TextEditingValue(
          text: parsed.national,
          selection: TextSelection.collapsed(offset: parsed.national.length),
        );
      }
    }

    return FilteringTextInputFormatter.digitsOnly.formatEditUpdate(oldValue, newValue);
  }
}

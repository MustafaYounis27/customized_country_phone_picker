import 'package:flutter/foundation.dart';

import '../data/countries_data.dart';
import '../models/country_model.dart';

/// Immutable snapshot of the country picker's current filter state.
class CountryPickerState {
  /// Countries matching the current query that are in the priority list.
  final List<CountryModel> priorityCountries;

  /// Countries matching the current query that are not in the priority list.
  final List<CountryModel> filteredCountries;

  /// The current search query, or empty if no filter is active.
  final String searchQuery;

  /// Creates a [CountryPickerState].
  const CountryPickerState({
    required this.priorityCountries,
    required this.filteredCountries,
    this.searchQuery = '',
  });
}

/// A [ValueNotifier] that manages country filtering and search logic.
class CountryPickerNotifier extends ValueNotifier<CountryPickerState> {
  final List<CountryModel> _allCountries;
  final Set<String> _priorityCodes;

  CountryPickerNotifier({
    List<CountryModel>? countries,
    List<String>? priorityCodes,
  })  : _allCountries = countries ?? CountriesData.all,
        _priorityCodes = (priorityCodes ?? CountriesData.priorityCountryCodes).toSet(),
        super(const CountryPickerState(priorityCountries: [], filteredCountries: [])) {
    _emit(_buildInitial());
  }

  CountryPickerState _buildInitial() {
    final priority = _allCountries.where((c) => _priorityCodes.contains(c.isoCode)).toList();
    final rest = _allCountries.where((c) => !_priorityCodes.contains(c.isoCode)).toList();
    return CountryPickerState(priorityCountries: priority, filteredCountries: rest);
  }

  void search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      _emit(_buildInitial());
      return;
    }

    final qDialCode = q.startsWith('+') ? q : '+$q';

    bool matches(CountryModel c) {
      return c.nameEn.toLowerCase().contains(q) ||
          c.nameAr.contains(q) ||
          c.isoCode.toLowerCase().contains(q) ||
          c.dialCode.contains(qDialCode) ||
          c.dialCode.replaceFirst('+', '').contains(q);
    }

    final allMatches = _allCountries.where(matches).toList();
    final priorityMatches = allMatches.where((c) => _priorityCodes.contains(c.isoCode)).toList();
    final restMatches = allMatches.where((c) => !_priorityCodes.contains(c.isoCode)).toList();

    _emit(CountryPickerState(
      priorityCountries: priorityMatches,
      filteredCountries: restMatches,
      searchQuery: q,
    ));
  }

  void clearSearch() {
    _emit(_buildInitial());
  }

  void _emit(CountryPickerState state) {
    value = state;
  }
}

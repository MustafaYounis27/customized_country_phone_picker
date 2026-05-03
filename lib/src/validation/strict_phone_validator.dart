import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../models/country_model.dart';

/// [phone_numbers_parser] integration for pattern-aware validation.
abstract final class StrictPhoneValidator {
  /// Returns `true` when [nationalDigits] matches numbering rules for [country].
  static bool isValidNational(CountryModel country, String nationalDigits) {
    if (nationalDigits.isEmpty) return false;
    late final IsoCode iso;
    try {
      iso = IsoCode.values.byName(country.isoCode);
    } catch (_) {
      return false;
    }
    try {
      return PhoneNumber(isoCode: iso, nsn: nationalDigits).isValid();
    } catch (_) {
      return false;
    }
  }
}

import '../validation/phone_validation.dart';

/// Represents a country with its phone-related metadata.
///
/// Each country has bilingual names (English and Arabic), an ISO 3166-1 alpha-2
/// code, a dial code, an emoji flag, and phone number length constraints.
class CountryModel {
  /// The country name in English (e.g. "Egypt").
  final String nameEn;

  /// The country name in Arabic (e.g. "مصر").
  final String nameAr;

  /// ISO 3166-1 alpha-2 code (e.g. "EG").
  final String isoCode;

  /// International dialling code including the "+" prefix (e.g. "+20").
  final String dialCode;

  /// Emoji flag for the country (e.g. "🇪🇬").
  final String flag;

  /// Minimum number of digits in a valid phone number for this country.
  final int minLength;

  /// Maximum number of digits in a valid phone number for this country.
  final int maxLength;

  /// An optional example phone number shown as a hint in the input field.
  final String? exampleNumber;

  /// Creates a [CountryModel].
  const CountryModel({
    required this.nameEn,
    required this.nameAr,
    required this.isoCode,
    required this.dialCode,
    required this.flag,
    required this.minLength,
    required this.maxLength,
    this.exampleNumber,
  });

  /// Returns the country name for the given [locale].
  ///
  /// Returns [nameAr] when [locale] starts with "ar", otherwise [nameEn].
  String getName(String locale) => locale.startsWith('ar') ? nameAr : nameEn;

  /// Length-only validation result for national [digits] (no dial prefix).
  ///
  /// See [PhoneValidation.validateNationalNumber] for strict (pattern) checks.
  PhoneValidationIssue? validateNationalDigitsIssue(String digits) =>
      PhoneValidation.validateLengthOnly(this, digits);

  /// Validates a phone [number] against this country's length constraints.
  ///
  /// Returns an error message string if validation fails, or `null` if valid.
  /// Messages are English; use [validateNationalDigitsIssue] with
  /// [defaultPhoneValidationMessage] or [PhoneValidation.messageFor] to localize.
  String? validatePhoneNumber(String number) {
    final issue = validateNationalDigitsIssue(number);
    if (issue == null) return null;
    return defaultPhoneValidationMessage(
      issue,
      PhoneValidationContext(country: this, nationalDigits: number),
    );
  }

  /// Returns the full international phone number by prepending [dialCode]
  /// to the given [number].
  String getFullNumber(String number) => '$dialCode$number';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CountryModel && isoCode == other.isoCode;

  @override
  int get hashCode => isoCode.hashCode;
}

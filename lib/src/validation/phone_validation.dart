import 'package:flutter/widgets.dart';

import '../models/country_model.dart';
import 'strict_phone_validator.dart';

/// Reason a national phone number failed validation.
enum PhoneValidationIssue {
  /// No digits were entered.
  empty,

  /// Digit count is outside this country's [CountryModel.minLength] / [CountryModel.maxLength].
  lengthOutOfRange,

  /// National number failed [phone_numbers_parser] pattern checks (strict mode).
  invalidNationalNumber,
}

/// Carries country and input for localized [PhoneValidationIssue] messages.
class PhoneValidationContext {
  /// Creates validation context.
  const PhoneValidationContext({
    required this.country,
    required this.nationalDigits,
  });

  /// Selected country (dial code / ISO metadata).
  final CountryModel country;

  /// National significant number (digits only, no country prefix).
  final String nationalDigits;
}

/// Default English messages for [PhoneValidationIssue]. Pass a custom message builder on the phone field to localize.
String defaultPhoneValidationMessage(
  PhoneValidationIssue issue,
  PhoneValidationContext ctx,
) {
  switch (issue) {
    case PhoneValidationIssue.empty:
      return 'Phone number is required';
    case PhoneValidationIssue.lengthOutOfRange:
      return 'Phone number must be between ${ctx.country.minLength} and ${ctx.country.maxLength} digits';
    case PhoneValidationIssue.invalidNationalNumber:
      return 'Phone number is not valid for this country';
  }
}

/// Shared validation helpers for national (in-country) digit strings.
abstract final class PhoneValidation {
  /// Length-only check (same rules as pre-strict [CountryModel.validatePhoneNumber]).
  static PhoneValidationIssue? validateLengthOnly(
    CountryModel country,
    String nationalDigits,
  ) {
    if (nationalDigits.isEmpty) return PhoneValidationIssue.empty;
    if (nationalDigits.length < country.minLength || nationalDigits.length > country.maxLength) {
      return PhoneValidationIssue.lengthOutOfRange;
    }
    return null;
  }

  /// Length check, then optional strict pattern validation.
  static PhoneValidationIssue? validateNationalNumber({
    required CountryModel country,
    required String nationalDigits,
    bool strict = false,
  }) {
    final lengthIssue = validateLengthOnly(country, nationalDigits);
    if (lengthIssue != null) return lengthIssue;
    if (strict && !StrictPhoneValidator.isValidNational(country, nationalDigits)) {
      return PhoneValidationIssue.invalidNationalNumber;
    }
    return null;
  }

  /// Maps an issue to [defaultPhoneValidationMessage] or a custom [builder].
  static String messageFor(
    PhoneValidationIssue issue,
    PhoneValidationContext ctx, {
    String Function(BuildContext context, PhoneValidationIssue issue, PhoneValidationContext ctx)? builder,
    required BuildContext context,
  }) {
    if (builder != null) {
      return builder(context, issue, ctx);
    }
    return defaultPhoneValidationMessage(issue, ctx);
  }
}

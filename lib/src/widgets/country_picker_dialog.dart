import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/country_model.dart';
import '../theme/country_phone_picker_theme.dart';
import 'country_picker_body.dart';

/// A dialog that displays a searchable list of countries.
///
/// Use [CountryPickerDialog.show] to present the picker modally.
/// Returns the selected [CountryModel], or `null` if dismissed.
class CountryPickerDialog {
  CountryPickerDialog._();

  /// Shows the country picker as a centered dialog.
  ///
  /// Returns the selected [CountryModel], or `null` if the user dismisses
  /// the dialog without selecting a country.
  static Future<CountryModel?> show(
    BuildContext context, {
    String? selectedIsoCode,
    String locale = 'en',
    List<CountryModel>? countries,
    List<String>? priorityCountryCodes,
    CountryPhonePickerThemeData? theme,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = theme;
    final bgColor = t?.sheetBackgroundColor ?? colorScheme.surface;
    final radius = t?.sheetTopRadius ?? 24;
    final media = MediaQuery.sizeOf(context);

    return showDialog<CountryModel>(
      context: context,
      builder:
          (dialogContext) => Dialog(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
            clipBehavior: Clip.antiAlias,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: SizedBox(
              width: math.min(400, media.width - 48),
              height: media.height * 0.72,
              child: CountryPickerBody(
                locale: locale,
                selectedIsoCode: selectedIsoCode,
                theme: theme,
                countries: countries,
                priorityCountryCodes: priorityCountryCodes,
                showDragHandle: false,
              ),
            ),
          ),
    );
  }
}

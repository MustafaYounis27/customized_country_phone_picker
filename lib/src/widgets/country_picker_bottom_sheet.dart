import 'package:flutter/material.dart';

import '../models/country_model.dart';
import '../theme/country_phone_picker_theme.dart';
import 'country_picker_body.dart';

/// A draggable bottom sheet that displays a searchable list of countries.
///
/// Use [CountryPickerBottomSheet.show] to present the picker modally.
/// Returns the selected [CountryModel], or `null` if dismissed.
class CountryPickerBottomSheet {
  CountryPickerBottomSheet._();

  /// Shows the country picker as a modal bottom sheet.
  ///
  /// Returns the selected [CountryModel], or `null` if the user dismisses
  /// the sheet without selecting a country.
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
    final topRadius = t?.sheetTopRadius ?? 24;

    return showModalBottomSheet<CountryModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder:
                (context, scrollController) => Container(
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius))),
                  child: CountryPickerBody(
                    scrollController: scrollController,
                    locale: locale,
                    selectedIsoCode: selectedIsoCode,
                    theme: theme,
                    countries: countries,
                    priorityCountryCodes: priorityCountryCodes,
                    showDragHandle: true,
                  ),
                ),
          ),
    );
  }
}

import 'package:flutter/material.dart';

import 'country_box_decoration.dart';
import 'dial_code_display.dart';
import 'phone_field_decoration.dart';

/// Top-level theme configuration for all country phone picker widgets.
///
/// All fields are nullable. When null, values are resolved from [ThemeData].
class CountryPhonePickerThemeData {
  final CountryBoxDecoration? countryBoxDecoration;
  final DialCodeDisplay dialCodeDisplay;
  final PhoneFieldDecoration? phoneFieldDecoration;
  final Color? sheetBackgroundColor;
  final double sheetTopRadius;
  final Color? sheetHandleColor;
  final TextStyle? sheetSearchStyle;
  final String sheetSearchHint;
  final Color? sheetDividerColor;
  final InputDecoration? sheetSearchDecoration;
  final TextStyle? tileNameStyle;
  final TextStyle? tileDialCodeStyle;
  final Color? tileSelectedColor;
  final Color? tileCheckColor;
  final double tileFlagSize;

  const CountryPhonePickerThemeData({
    this.countryBoxDecoration,
    this.dialCodeDisplay = DialCodeDisplay.inField,
    this.phoneFieldDecoration,
    this.sheetBackgroundColor,
    this.sheetTopRadius = 24,
    this.sheetHandleColor,
    this.sheetSearchStyle,
    this.sheetSearchHint = 'Search',
    this.sheetDividerColor,
    this.sheetSearchDecoration,
    this.tileNameStyle,
    this.tileDialCodeStyle,
    this.tileSelectedColor,
    this.tileCheckColor,
    this.tileFlagSize = 24,
  });
}

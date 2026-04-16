import 'package:flutter/material.dart';

import 'country_box_decoration.dart';
import 'country_picker_search_decoration.dart';
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
  final CountryPickerSearchDecoration? searchFieldDecoration;
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
    this.searchFieldDecoration,
    this.tileNameStyle,
    this.tileDialCodeStyle,
    this.tileSelectedColor,
    this.tileCheckColor,
    this.tileFlagSize = 24,
  });

  CountryPhonePickerThemeData copyWith({
    CountryBoxDecoration? countryBoxDecoration,
    DialCodeDisplay? dialCodeDisplay,
    PhoneFieldDecoration? phoneFieldDecoration,
    Color? sheetBackgroundColor,
    double? sheetTopRadius,
    Color? sheetHandleColor,
    TextStyle? sheetSearchStyle,
    String? sheetSearchHint,
    Color? sheetDividerColor,
    InputDecoration? sheetSearchDecoration,
    CountryPickerSearchDecoration? searchFieldDecoration,
    TextStyle? tileNameStyle,
    TextStyle? tileDialCodeStyle,
    Color? tileSelectedColor,
    Color? tileCheckColor,
    double? tileFlagSize,
  }) {
    return CountryPhonePickerThemeData(
      countryBoxDecoration: countryBoxDecoration ?? this.countryBoxDecoration,
      dialCodeDisplay: dialCodeDisplay ?? this.dialCodeDisplay,
      phoneFieldDecoration: phoneFieldDecoration ?? this.phoneFieldDecoration,
      sheetBackgroundColor: sheetBackgroundColor ?? this.sheetBackgroundColor,
      sheetTopRadius: sheetTopRadius ?? this.sheetTopRadius,
      sheetHandleColor: sheetHandleColor ?? this.sheetHandleColor,
      sheetSearchStyle: sheetSearchStyle ?? this.sheetSearchStyle,
      sheetSearchHint: sheetSearchHint ?? this.sheetSearchHint,
      sheetDividerColor: sheetDividerColor ?? this.sheetDividerColor,
      sheetSearchDecoration: sheetSearchDecoration ?? this.sheetSearchDecoration,
      searchFieldDecoration: searchFieldDecoration ?? this.searchFieldDecoration,
      tileNameStyle: tileNameStyle ?? this.tileNameStyle,
      tileDialCodeStyle: tileDialCodeStyle ?? this.tileDialCodeStyle,
      tileSelectedColor: tileSelectedColor ?? this.tileSelectedColor,
      tileCheckColor: tileCheckColor ?? this.tileCheckColor,
      tileFlagSize: tileFlagSize ?? this.tileFlagSize,
    );
  }
}

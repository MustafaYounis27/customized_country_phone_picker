import 'package:flutter/material.dart';

/// Styling configuration for the phone number text field.
class PhoneFieldDecoration {
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? errorBorderColor;
  final double borderWidth;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? focusBackgroundColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? prefixStyle;
  final EdgeInsetsGeometry contentPadding;
  final double prefixSpacing;
  final double gapWithCountryBox;
  final Color? cursorColor;
  final double cursorWidth;
  final InputDecoration? inputDecorationOverride;

  const PhoneFieldDecoration({
    this.borderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.borderWidth = 1,
    this.borderRadius = 12,
    this.backgroundColor,
    this.focusBackgroundColor,
    this.textStyle,
    this.hintStyle,
    this.prefixStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.prefixSpacing = 8,
    this.gapWithCountryBox = 8,
    this.cursorColor,
    this.cursorWidth = 1,
    this.inputDecorationOverride,
  });

  /// Bordered field — visible border, white background. Default style.
  const PhoneFieldDecoration.bordered({
    this.borderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.borderWidth = 1,
    this.borderRadius = 12,
    this.backgroundColor,
    this.textStyle,
    this.hintStyle,
    this.prefixStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.prefixSpacing = 8,
    this.gapWithCountryBox = 8,
    this.cursorColor,
    this.cursorWidth = 1,
  }) : focusBackgroundColor = null,
       inputDecorationOverride = null;

  /// Filled field — colored background, no visible border.
  const PhoneFieldDecoration.filled({
    this.backgroundColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.borderRadius = 12,
    this.textStyle,
    this.hintStyle,
    this.prefixStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.prefixSpacing = 8,
    this.gapWithCountryBox = 8,
    this.cursorColor,
    this.cursorWidth = 1,
  }) : borderColor = Colors.transparent,
       borderWidth = 0,
       focusBackgroundColor = null,
       inputDecorationOverride = null;

  /// Underline field — bottom border only, transparent background.
  const PhoneFieldDecoration.underline({
    this.borderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.borderWidth = 1,
    this.textStyle,
    this.hintStyle,
    this.prefixStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.prefixSpacing = 8,
    this.gapWithCountryBox = 8,
    this.cursorColor,
    this.cursorWidth = 1,
  }) : borderRadius = 0,
       backgroundColor = Colors.transparent,
       focusBackgroundColor = null,
       inputDecorationOverride = null;
}

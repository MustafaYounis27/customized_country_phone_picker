import 'package:flutter/material.dart';

/// Styling for the country picker search [TextField] (bottom sheet and dialog).
///
/// Ignored when [CountryPhonePickerThemeData.sheetSearchDecoration] is set
/// (full [InputDecoration] override).
class CountryPickerSearchDecoration {
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final EdgeInsetsGeometry contentPadding;

  /// Optional widget shown at the start of the field (replaces [prefixIcon] when set).
  final Widget? prefix;

  final IconData prefixIcon;
  final bool showPrefixIcon;
  final Color? prefixIconColor;

  /// Optional widget shown on the trailing side before the clear control (if any).
  final Widget? suffix;

  /// When the field has text, shows a clear control unless set to `false`.
  final bool showClearButton;

  final IconData clearIcon;
  final Color? clearIconColor;

  /// Replaces the default [Icon] built from [clearIcon]. Still wrapped in [IconButton].
  final Widget? clearButton;

  /// Tooltip for the clear [IconButton]. Ignored when [clearButton] implements its own semantics.
  final String? clearButtonTooltip;

  final TextStyle? hintStyle;
  final Color? cursorColor;
  final double cursorWidth;

  const CountryPickerSearchDecoration({
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.contentPadding = const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
    this.prefix,
    this.prefixIcon = Icons.search,
    this.showPrefixIcon = true,
    this.prefixIconColor,
    this.suffix,
    this.showClearButton = true,
    this.clearIcon = Icons.clear,
    this.clearIconColor,
    this.clearButton,
    this.clearButtonTooltip,
    this.hintStyle,
    this.cursorColor,
    this.cursorWidth = 1,
  });

  /// Outlined search field with transparent fill (default picker look).
  const CountryPickerSearchDecoration.outlined({
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.borderColor,
    this.focusedBorderColor,
    this.contentPadding = const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
    this.prefix,
    this.prefixIcon = Icons.search,
    this.showPrefixIcon = true,
    this.prefixIconColor,
    this.suffix,
    this.showClearButton = true,
    this.clearIcon = Icons.clear,
    this.clearIconColor,
    this.clearButton,
    this.clearButtonTooltip,
    this.hintStyle,
    this.cursorColor,
    this.cursorWidth = 1,
  }) : fillColor = null;

  /// Filled search field ([InputDecoration.filled]).
  const CountryPickerSearchDecoration.filled({
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.borderColor,
    this.focusedBorderColor,
    required this.fillColor,
    this.contentPadding = const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
    this.prefix,
    this.prefixIcon = Icons.search,
    this.showPrefixIcon = true,
    this.prefixIconColor,
    this.suffix,
    this.showClearButton = true,
    this.clearIcon = Icons.clear,
    this.clearIconColor,
    this.clearButton,
    this.clearButtonTooltip,
    this.hintStyle,
    this.cursorColor,
    this.cursorWidth = 1,
  });

  /// Default icon or custom [prefix] for [InputDecoration.prefixIcon].
  Widget? buildPrefix(BuildContext context) {
    if (prefix != null) return prefix;
    if (!showPrefixIcon) return null;
    final colorScheme = Theme.of(context).colorScheme;
    return Icon(prefixIcon, color: prefixIconColor ?? colorScheme.onSurfaceVariant);
  }

  InputDecoration buildDecoration({
    required BuildContext context,
    required String hintText,
    required bool hasFocus,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final effectiveBorder = borderColor ?? colorScheme.outline;
    final effectiveFocusBorder = focusedBorderColor ?? colorScheme.primary;
    final borderSide = BorderSide(
      color: hasFocus ? effectiveFocusBorder : effectiveBorder,
      width: borderWidth,
    );
    final shape = OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: borderSide);

    return InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle ?? textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: fillColor != null,
      fillColor: fillColor,
      border: shape,
      enabledBorder: shape,
      focusedBorder: shape,
      disabledBorder: shape,
      contentPadding: contentPadding,
    );
  }
}

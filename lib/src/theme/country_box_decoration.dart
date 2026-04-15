import 'package:flutter/material.dart';

/// Styling configuration for the country selector box.
class CountryBoxDecoration {
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double flagSize;
  final double arrowSize;
  final Color? arrowColor;
  final IconData arrowIcon;
  final bool showArrow;
  final bool showFlag;
  final TextStyle? dialCodeStyle;
  final double spacing;

  const CountryBoxDecoration({
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.flagSize = 20,
    this.arrowSize = 16,
    this.arrowColor,
    this.arrowIcon = Icons.keyboard_arrow_down,
    this.showArrow = true,
    this.showFlag = true,
    this.dialCodeStyle,
    this.spacing = 4,
  });

  /// Rounded pill with subtle background.
  const CountryBoxDecoration.pill({
    this.backgroundColor,
    this.flagSize = 20,
    this.arrowSize = 16,
    this.arrowColor,
    this.arrowIcon = Icons.keyboard_arrow_down,
    this.showArrow = true,
    this.showFlag = true,
    this.dialCodeStyle,
    this.spacing = 4,
  }) : borderColor = null,
       borderWidth = null,
       borderRadius = 12,
       padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  /// Bordered box matching the text field border.
  const CountryBoxDecoration.outlined({
    this.borderColor,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.flagSize = 20,
    this.arrowSize = 16,
    this.arrowColor,
    this.arrowIcon = Icons.keyboard_arrow_down,
    this.showArrow = true,
    this.showFlag = true,
    this.dialCodeStyle,
    this.spacing = 4,
  }) : backgroundColor = Colors.transparent,
       padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  /// No border or background — just flag + arrow.
  const CountryBoxDecoration.flat({
    this.flagSize = 20,
    this.arrowSize = 16,
    this.arrowColor,
    this.arrowIcon = Icons.keyboard_arrow_down,
    this.showArrow = false,
    this.showFlag = true,
    this.dialCodeStyle,
    this.spacing = 4,
  }) : backgroundColor = Colors.transparent,
       borderColor = null,
       borderWidth = null,
       borderRadius = null,
       padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
}

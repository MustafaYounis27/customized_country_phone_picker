import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/countries_data.dart';
import '../models/country_model.dart';
import '../theme/country_box_decoration.dart';
import '../theme/country_phone_picker_theme.dart';
import '../theme/dial_code_display.dart';
import '../theme/phone_field_decoration.dart';
import 'country_picker_bottom_sheet.dart';

/// A phone number input field with an integrated country picker.
///
/// Displays a tappable country box (flag + optional dial code) alongside a
/// phone number text field. Tapping the country box opens a
/// [CountryPickerBottomSheet] for country selection.
///
/// {@tool snippet}
/// ```dart
/// CountryPhoneInput(
///   controller: _phoneController,
///   onCountryChanged: (country) => setState(() => _country = country),
/// )
/// ```
/// {@end-tool}
class CountryPhoneInput extends StatefulWidget {
  /// Creates a [CountryPhoneInput].
  const CountryPhoneInput({
    super.key,
    required this.controller,
    required this.onCountryChanged,
    this.initialCountry = 'EG',
    this.errorText,
    this.locale = 'en',
    this.onChanged,
    this.enabled = true,
    this.focusNode,
    this.dialCodeDisplay,
    this.countryBoxDecoration,
    this.phoneFieldDecoration,
    this.theme,
    this.countries,
    this.priorityCountryCodes,
  });

  /// Controller for the phone number text field.
  final TextEditingController controller;

  /// Called when the user selects a different country.
  final ValueChanged<CountryModel> onCountryChanged;

  /// ISO 3166-1 alpha-2 code for the initially selected country.
  /// Defaults to "EG" (Egypt).
  final String initialCountry;

  /// Error text displayed below the input. Pass `null` to hide.
  final String? errorText;

  /// Locale used for country names — "en" for English, "ar" for Arabic.
  final String locale;

  /// Called when the phone number text changes.
  final ValueChanged<String>? onChanged;

  /// Whether the input field is enabled. Defaults to `true`.
  final bool enabled;

  /// Optional focus node for the phone text field.
  final FocusNode? focusNode;

  /// Controls where the dial code is displayed.
  /// Overrides [theme]'s value when provided.
  final DialCodeDisplay? dialCodeDisplay;

  /// Styling for the country selector box.
  /// Overrides [theme]'s value when provided.
  final CountryBoxDecoration? countryBoxDecoration;

  /// Styling for the phone number text field.
  /// Overrides [theme]'s value when provided.
  final PhoneFieldDecoration? phoneFieldDecoration;

  /// Combined theme configuration for all sub-widgets.
  final CountryPhonePickerThemeData? theme;

  /// Custom list of countries. When `null`, the built-in list is used.
  final List<CountryModel>? countries;

  /// ISO codes for countries shown at the top of the picker list.
  final List<String>? priorityCountryCodes;

  @override
  State<CountryPhoneInput> createState() => _CountryPhoneInputState();
}

class _CountryPhoneInputState extends State<CountryPhoneInput> {
  late CountryModel _selectedCountry;
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountriesData.findByIsoCode(widget.initialCountry) ?? CountriesData.defaultCountry;
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }
  }

  @override
  void dispose() {
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  DialCodeDisplay get _dialCodeDisplay => widget.dialCodeDisplay ?? widget.theme?.dialCodeDisplay ?? DialCodeDisplay.inField;

  CountryBoxDecoration get _boxDeco =>
      widget.countryBoxDecoration ?? widget.theme?.countryBoxDecoration ?? const CountryBoxDecoration.pill();

  PhoneFieldDecoration get _fieldDeco =>
      widget.phoneFieldDecoration ?? widget.theme?.phoneFieldDecoration ?? const PhoneFieldDecoration.bordered();

  Future<void> _openPicker() async {
    final country = await CountryPickerBottomSheet.show(
      context,
      selectedIsoCode: _selectedCountry.isoCode,
      locale: widget.locale,
      countries: widget.countries,
      priorityCountryCodes: widget.priorityCountryCodes,
      theme: widget.theme,
    );
    if (country != null && mounted) {
      setState(() => _selectedCountry = country);
      widget.onCountryChanged(country);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCountryBox(colorScheme, textTheme),
              SizedBox(width: _fieldDeco.gapWithCountryBox),
              Expanded(child: _buildPhoneField(colorScheme, textTheme)),
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.error) ?? TextStyle(fontSize: 12, color: colorScheme.error),
          ),
        ],
      ],
    );
  }

  Widget _buildCountryBox(ColorScheme colorScheme, TextTheme textTheme) {
    final deco = _boxDeco;
    final bgColor = deco.backgroundColor ?? colorScheme.surfaceContainerHighest;
    final borderColor = deco.borderColor;
    final borderWidth = deco.borderWidth;
    final radius = deco.borderRadius ?? 12;
    final arrowColor = deco.arrowColor ?? colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: widget.enabled ? _openPicker : null,
      child: Container(
        padding: deco.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
          border: borderColor != null && borderWidth != null ? Border.all(color: borderColor, width: borderWidth) : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (deco.showFlag) ...[Text(_selectedCountry.flag, style: TextStyle(fontSize: deco.flagSize)), SizedBox(width: deco.spacing)],
              if (_dialCodeDisplay == DialCodeDisplay.inBox) ...[
                Text(
                  _selectedCountry.dialCode,
                  style: deco.dialCodeStyle ?? textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface) ?? const TextStyle(fontSize: 14),
                ),
                SizedBox(width: deco.spacing),
              ],
              if (deco.showArrow) Icon(deco.arrowIcon, size: deco.arrowSize, color: arrowColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(ColorScheme colorScheme, TextTheme textTheme) {
    final deco = _fieldDeco;

    if (deco.inputDecorationOverride != null) {
      return TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.phone,
        enabled: widget.enabled,
        maxLength: _selectedCountry.maxLength,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: widget.onChanged,
        cursorColor: deco.cursorColor ?? colorScheme.primary,
        cursorWidth: deco.cursorWidth,
        style: deco.textStyle ?? textTheme.bodyLarge,
        decoration: deco.inputDecorationOverride!,
      );
    }

    final borderColor = deco.borderColor ?? colorScheme.outline;
    final focusBorderColor = deco.focusBorderColor ?? colorScheme.primary;
    final errorBorderColor = deco.errorBorderColor ?? colorScheme.error;
    final bgColor = deco.backgroundColor ?? colorScheme.surface;
    final textStyle = deco.textStyle ?? textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
    final hintStyle = deco.hintStyle ?? textStyle.copyWith(color: colorScheme.onSurfaceVariant);
    final prefixStyle = deco.prefixStyle ?? textStyle.copyWith(color: colorScheme.onSurfaceVariant);
    final hasError = widget.errorText != null;

    return ListenableBuilder(
      listenable: _focusNode,
      builder: (context, _) {
        final effectiveBorderColor = hasError ? errorBorderColor : (_focusNode.hasFocus ? focusBorderColor : borderColor);
        final effectiveBgColor = _focusNode.hasFocus ? (deco.focusBackgroundColor ?? bgColor) : bgColor;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: effectiveBgColor,
            borderRadius: BorderRadius.circular(deco.borderRadius),
            border: deco.borderWidth > 0 ? Border.all(color: effectiveBorderColor, width: deco.borderWidth) : null,
          ),
          padding: deco.contentPadding,
          child: Row(
            children: [
              if (_dialCodeDisplay == DialCodeDisplay.inField) ...[
                Text(_selectedCountry.dialCode, style: prefixStyle),
                SizedBox(width: deco.prefixSpacing),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  enabled: widget.enabled,
                  maxLength: _selectedCountry.maxLength,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: widget.onChanged,
                  cursorColor: deco.cursorColor ?? colorScheme.primary,
                  cursorWidth: deco.cursorWidth,
                  style: textStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    counterText: '',
                    hintText: _selectedCountry.exampleNumber ?? '',
                    hintStyle: hintStyle,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

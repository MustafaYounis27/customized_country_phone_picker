import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/countries_data.dart';
import '../models/country_model.dart';
import '../theme/country_box_decoration.dart';
import '../theme/country_phone_picker_theme.dart';
import '../theme/country_picker_search_decoration.dart';
import '../theme/country_picker_presentation.dart';
import '../theme/dial_code_display.dart';
import '../theme/phone_field_decoration.dart';
import '../validation/phone_validation.dart';
import 'country_picker_bottom_sheet.dart';
import 'country_picker_dialog.dart';
import 'international_paste_formatter.dart';

/// A phone number input field with an integrated country picker.
///
/// Displays a tappable country box (flag + optional dial code) alongside a
/// phone number text field. Tapping the country box opens a country picker
/// as a bottom sheet or dialog ([CountryPickerPresentation]).
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
    this.countryPickerPresentation = CountryPickerPresentation.bottomSheet,
    this.searchFieldDecoration,
    this.clearTextOnCountryChange = true,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.useStrictPhoneValidation = false,
    this.validationMessageBuilder,
    this.detectCountryOnPaste = true,
    this.pasteAmbiguityPolicy = PasteAmbiguityPolicy.preferCurrentCountry,
  });

  /// Controller for the phone number text field.
  final TextEditingController controller;

  /// Called when the user selects a different country.
  final ValueChanged<CountryModel> onCountryChanged;

  /// ISO 3166-1 alpha-2 code for the initially selected country.
  /// Defaults to "EG" (Egypt).
  final String initialCountry;

  /// Error text displayed below the input. Overrides internal validation text.
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

  /// Whether the country list opens in a bottom sheet or a dialog.
  final CountryPickerPresentation countryPickerPresentation;

  /// Styling for the picker search field. Overrides [theme]'s [CountryPhonePickerThemeData.searchFieldDecoration].
  ///
  /// Ignored when [CountryPhonePickerThemeData.sheetSearchDecoration] is set on the effective theme.
  final CountryPickerSearchDecoration? searchFieldDecoration;

  /// Whether to clear [controller]'s text when the user selects a different
  /// country. Has no effect when the user re-selects the current country.
  /// Defaults to `true`.
  final bool clearTextOnCountryChange;

  /// When not [AutovalidateMode.disabled], validates the national number and
  /// shows an error below the field (unless [errorText] is set).
  final AutovalidateMode autovalidateMode;

  /// When `true`, after length validation passes, uses [phone_numbers_parser]
  /// rules for the selected country.
  final bool useStrictPhoneValidation;

  /// Builds the error line for a [PhoneValidationIssue]. Use with [AppLocalizations].
  final String Function(BuildContext context, PhoneValidationIssue issue, PhoneValidationContext ctx)?
      validationMessageBuilder;

  /// When `true`, pasting values such as `+20…` or `00…` sets the country and strips the prefix.
  final bool detectCountryOnPaste;

  /// How to choose a country when several share the same dial prefix (e.g. +1).
  final PasteAmbiguityPolicy pasteAmbiguityPolicy;

  @override
  State<CountryPhoneInput> createState() => _CountryPhoneInputState();
}

class _CountryPhoneInputState extends State<CountryPhoneInput> {
  late CountryModel _selectedCountry;
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;

  String? _internalValidationMessage;
  bool _userInteracted = false;

  String? get _effectiveErrorText => widget.errorText ?? _internalValidationMessage;

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
    widget.controller.addListener(_onControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.autovalidateMode == AutovalidateMode.always) {
        _runValidation();
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CountryPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
    if (oldWidget.autovalidateMode != widget.autovalidateMode ||
        oldWidget.useStrictPhoneValidation != widget.useStrictPhoneValidation ||
        oldWidget.errorText != widget.errorText) {
      _maybeRevalidate();
    }
  }

  void _onControllerChanged() {
    _maybeRevalidate();
  }

  void _maybeRevalidate() {
    if (widget.autovalidateMode == AutovalidateMode.disabled) {
      if (_internalValidationMessage != null) {
        setState(() => _internalValidationMessage = null);
      }
      return;
    }
    if (widget.autovalidateMode == AutovalidateMode.onUserInteraction && !_userInteracted) {
      return;
    }
    _runValidation();
  }

  void _runValidation() {
    if (!mounted) return;
    if (widget.autovalidateMode == AutovalidateMode.disabled) {
      setState(() => _internalValidationMessage = null);
      return;
    }
    if (widget.autovalidateMode == AutovalidateMode.onUserInteraction && !_userInteracted) {
      setState(() => _internalValidationMessage = null);
      return;
    }

    final text = widget.controller.text;
    final issue = PhoneValidation.validateNationalNumber(
      country: _selectedCountry,
      nationalDigits: text,
      strict: widget.useStrictPhoneValidation,
    );
    final msg = issue == null
        ? null
        : PhoneValidation.messageFor(
            issue,
            PhoneValidationContext(country: _selectedCountry, nationalDigits: text),
            builder: widget.validationMessageBuilder,
            context: context,
          );
    setState(() => _internalValidationMessage = msg);
  }

  void _applyPastedCountry(CountryModel country) {
    if (!mounted) return;
    _userInteracted = true;
    final changed = country.isoCode != _selectedCountry.isoCode;
    if (changed) {
      setState(() => _selectedCountry = country);
      widget.onCountryChanged(country);
    }
    _maybeRevalidate();
  }

  void _handlePhoneChanged(String value) {
    _userInteracted = true;
    widget.onChanged?.call(value);
    _maybeRevalidate();
  }

  List<TextInputFormatter> _phoneInputFormatters() {
    return [
      InternationalPasteFormatter(
        countries: widget.countries ?? CountriesData.all,
        priorityIsoCodes: widget.priorityCountryCodes ?? CountriesData.priorityCountryCodes,
        currentCountry: () => _selectedCountry,
        policy: widget.pasteAmbiguityPolicy,
        onCountryResolved: _applyPastedCountry,
        enabled: widget.enabled && widget.detectCountryOnPaste,
      ),
    ];
  }

  DialCodeDisplay get _dialCodeDisplay => widget.dialCodeDisplay ?? widget.theme?.dialCodeDisplay ?? DialCodeDisplay.inField;

  CountryBoxDecoration get _boxDeco =>
      widget.countryBoxDecoration ?? widget.theme?.countryBoxDecoration ?? const CountryBoxDecoration.pill();

  PhoneFieldDecoration get _fieldDeco =>
      widget.phoneFieldDecoration ?? widget.theme?.phoneFieldDecoration ?? const PhoneFieldDecoration.bordered();

  CountryPhonePickerThemeData? get _pickerTheme {
    if (widget.searchFieldDecoration == null) return widget.theme;
    final base = widget.theme ?? const CountryPhonePickerThemeData();
    return base.copyWith(searchFieldDecoration: widget.searchFieldDecoration);
  }

  Future<CountryModel?> _presentCountryPicker() {
    if (widget.countryPickerPresentation == CountryPickerPresentation.dialog) {
      return CountryPickerDialog.show(
        context,
        selectedIsoCode: _selectedCountry.isoCode,
        locale: widget.locale,
        countries: widget.countries,
        priorityCountryCodes: widget.priorityCountryCodes,
        theme: _pickerTheme,
      );
    }
    return CountryPickerBottomSheet.show(
      context,
      selectedIsoCode: _selectedCountry.isoCode,
      locale: widget.locale,
      countries: widget.countries,
      priorityCountryCodes: widget.priorityCountryCodes,
      theme: _pickerTheme,
    );
  }

  Future<void> _openPicker() async {
    if (!mounted) return;
    final country = await _presentCountryPicker();
    if (country != null && mounted) {
      _userInteracted = true;
      final countryChanged = country.isoCode != _selectedCountry.isoCode;
      setState(() => _selectedCountry = country);
      if (countryChanged && widget.clearTextOnCountryChange) {
        widget.controller.clear();
      }
      widget.onCountryChanged(country);
      _maybeRevalidate();
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
        if (_effectiveErrorText != null) ...[
          const SizedBox(height: 4),
          Text(
            _effectiveErrorText!,
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
                  style:
                      deco.dialCodeStyle ?? textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface) ?? const TextStyle(fontSize: 14),
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
    final hasError = _effectiveErrorText != null;

    if (deco.inputDecorationOverride != null) {
      return TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.phone,
        enabled: widget.enabled,
        maxLength: _selectedCountry.maxLength,
        inputFormatters: _phoneInputFormatters(),
        onChanged: _handlePhoneChanged,
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
                  inputFormatters: _phoneInputFormatters(),
                  onChanged: _handlePhoneChanged,
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

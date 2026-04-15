# customized_country_phone_picker

A fully customizable Flutter phone input field with country picker bottom sheet, bilingual country names (English + Arabic), phone number validation, and three dial code display modes.

## Features

- Country picker bottom sheet with search (English, Arabic, dial code, ISO code)
- Three dial code display modes: `inField`, `inBox`, `hidden`
- Country box presets: `pill`, `outlined`, `flat`
- Phone field presets: `bordered`, `filled`, `underline`
- Full theme customization via `CountryPhonePickerThemeData`
- Theme-aware defaults (reads from your app's Material `ThemeData`)
- 80+ countries with emoji flags and bilingual names
- Phone number length validation per country
- Zero external dependencies (Flutter SDK only)

## Installation

```yaml
dependencies:
  customized_country_phone_picker: ^0.1.0
```

## Quick Start

```dart
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

CountryPhoneInput(
  controller: phoneController,
  onCountryChanged: (country) {
    print('${country.dialCode} ${country.nameEn}');
  },
)
```

## Dial Code Display Modes

```dart
// Default: dial code as prefix in the text field
CountryPhoneInput(
  controller: ctrl,
  dialCodeDisplay: DialCodeDisplay.inField,
  onCountryChanged: (c) {},
)

// Dial code inside the country box
CountryPhoneInput(
  controller: ctrl,
  dialCodeDisplay: DialCodeDisplay.inBox,
  onCountryChanged: (c) {},
)

// Dial code hidden
CountryPhoneInput(
  controller: ctrl,
  dialCodeDisplay: DialCodeDisplay.hidden,
  onCountryChanged: (c) {},
)
```

## Country Box Presets

```dart
CountryPhoneInput(controller: ctrl, countryBoxDecoration: const CountryBoxDecoration.pill(), onCountryChanged: (c) {})
CountryPhoneInput(controller: ctrl, countryBoxDecoration: const CountryBoxDecoration.outlined(), onCountryChanged: (c) {})
CountryPhoneInput(controller: ctrl, countryBoxDecoration: const CountryBoxDecoration.flat(), onCountryChanged: (c) {})
```

## Phone Field Presets

```dart
CountryPhoneInput(controller: ctrl, phoneFieldDecoration: const PhoneFieldDecoration.bordered(), onCountryChanged: (c) {})
CountryPhoneInput(controller: ctrl, phoneFieldDecoration: const PhoneFieldDecoration.filled(), onCountryChanged: (c) {})
CountryPhoneInput(controller: ctrl, phoneFieldDecoration: const PhoneFieldDecoration.underline(), onCountryChanged: (c) {})
```

## Full Theme Customization

```dart
CountryPhoneInput(
  controller: ctrl,
  onCountryChanged: (c) {},
  theme: CountryPhonePickerThemeData(
    dialCodeDisplay: DialCodeDisplay.inBox,
    countryBoxDecoration: CountryBoxDecoration.pill(backgroundColor: Colors.grey.shade100),
    phoneFieldDecoration: PhoneFieldDecoration.bordered(focusBorderColor: Colors.red, borderRadius: 16),
    sheetSearchHint: 'Find a country...',
    tileSelectedColor: Colors.red.withOpacity(0.1),
  ),
)
```

## Standalone Picker

```dart
final country = await CountryPickerBottomSheet.show(context, selectedIsoCode: 'EG', locale: 'ar');
```

## License

MIT

# customized_country_phone_picker

Customizable Flutter phone input with a country list in a **bottom sheet** or **dialog**, bilingual names (English & Arabic), validation, dial-code display modes, and **themed picker search** (prefix/suffix widgets and clear control).

<p align="center">
  <img src="https://raw.githubusercontent.com/MustafaYounis27/customized_country_phone_picker/main/example/images/hero_light.png" alt="Signup form using CountryPhoneInput" width="320"/>
</p>

## Features

- Country picker as modal **bottom sheet** or **dialog** (`CountryPickerPresentation`)
- Searchable list (English, Arabic, dial code, ISO code)
- **Search field styling** via `CountryPickerSearchDecoration` (borders, fill, prefix/suffix, clear button)
- Three dial code display modes: `inField`, `inBox`, `hidden`
- Country box presets: `pill`, `outlined`, `flat`
- Phone field presets: `bordered`, `filled`, `underline`
- Full theme customization via `CountryPhonePickerThemeData` (includes `copyWith`)
- Theme-aware defaults (reads from your app's Material `ThemeData`)
- 80+ countries with emoji flags and bilingual names
- Phone number length validation per country
- Zero external dependencies (Flutter SDK only)

## Installation

```yaml
dependencies:
  customized_country_phone_picker: ^0.4.0
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

<img src="https://raw.githubusercontent.com/MustafaYounis27/customized_country_phone_picker/main/example/images/dial_modes_light.png" alt="Dial code display variants: in field, in box, hidden" width="320"/>

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

<img src="https://raw.githubusercontent.com/MustafaYounis27/customized_country_phone_picker/main/example/images/country_box_presets_light.png" alt="Country box presets: pill, outlined, flat" width="320"/>

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

## Picker presentation (sheet vs dialog)

<img src="https://raw.githubusercontent.com/MustafaYounis27/customized_country_phone_picker/main/example/images/picker_presentation_dialog_light.png" alt="Country picker rendered as a dialog" width="320"/>

```dart
CountryPhoneInput(
  controller: ctrl,
  countryPickerPresentation: CountryPickerPresentation.dialog,
  onCountryChanged: (c) {},
)
```

## Search field theming

<img src="https://raw.githubusercontent.com/MustafaYounis27/customized_country_phone_picker/main/example/images/themed_search_open_dark.png" alt="Themed search field with custom prefix and border" width="320"/>

Use `CountryPhonePickerThemeData.searchFieldDecoration`, or pass `searchFieldDecoration` on `CountryPhoneInput` to override for that field only. For a full `InputDecoration`, set `sheetSearchDecoration` on the theme (it replaces the built-in search layout).

```dart
CountryPhoneInput(
  controller: ctrl,
  onCountryChanged: (c) {},
  theme: CountryPhonePickerThemeData(
    sheetSearchHint: 'Search country',
    searchFieldDecoration: CountryPickerSearchDecoration(
      borderRadius: 16,
      prefix: Icon(Icons.public),
      clearIcon: Icons.close,
    ),
  ),
)
```

## Full theme customization

```dart
CountryPhoneInput(
  controller: ctrl,
  onCountryChanged: (c) {},
  theme: CountryPhonePickerThemeData(
    dialCodeDisplay: DialCodeDisplay.inBox,
    countryBoxDecoration: CountryBoxDecoration.pill(backgroundColor: Colors.grey.shade100),
    phoneFieldDecoration: PhoneFieldDecoration.bordered(focusBorderColor: Colors.red, borderRadius: 16),
    sheetSearchHint: 'Find a country...',
    tileSelectedColor: Colors.red.withValues(alpha: 0.1),
  ),
)
```

## Standalone picker

```dart
final country = await CountryPickerBottomSheet.show(
  context,
  selectedIsoCode: 'EG',
  locale: 'ar',
);

final countryFromDialog = await CountryPickerDialog.show(
  context,
  selectedIsoCode: 'EG',
  locale: 'ar',
);
```

## License

MIT

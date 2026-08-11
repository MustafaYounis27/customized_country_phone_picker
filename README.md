# customized_country_phone_picker

[![pub package](https://img.shields.io/pub/v/customized_country_phone_picker.svg)](https://pub.dev/packages/customized_country_phone_picker)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Customizable Flutter phone input with a country list in a **bottom sheet** or **dialog**, bilingual names (English & Arabic), validation, dial-code display modes, **inline country prefix**, and **themed picker search** (prefix/suffix widgets and clear control).

<p align="center">
  <img src="https://raw.githubusercontent.com/MustafaYounis27/customized_country_phone_picker/main/example/images/hero_light.png" alt="Signup form using CountryPhoneInput" width="320"/>
</p>

## Features

- Country picker as modal **bottom sheet** or **dialog** (`CountryPickerPresentation`)
- Searchable list (English, Arabic, dial code, ISO code)
- **Search field styling** via `CountryPickerSearchDecoration` (borders, fill, prefix/suffix, clear button)
- **Inline country prefix** — embed the country selector inside the phone field (`CountryPhoneInputLayout.inlinePrefix`)
- **Flag or ISO code** in the country selector (`CountryIdentifierDisplay.flag` / `isoCode`, e.g. `EG`)
- Three dial code display modes: `inField`, `inBox`, `hidden`
- Country box presets: `pill`, `outlined`, `flat`
- Phone field presets: `bordered`, `filled`, `underline`
- Full theme customization via `CountryPhonePickerThemeData` (includes `copyWith`)
- Theme-aware defaults (reads from your app's Material `ThemeData`)
- 80+ countries with emoji flags and bilingual names
- Phone number length validation per country; optional **strict** pattern validation (`useStrictPhoneValidation`, powered by [phone_numbers_parser](https://pub.dev/packages/phone_numbers_parser))
- **Paste-to-detect** for international numbers (`+…` / `00…`, and long digit pastes with multi-digit country codes)
- **Smart paste truncation** — when pasted digits exceed `maxLength`, keeps the trailing digits (drops from the start)
- **Autovalidate** with localizable messages (`autovalidateMode`, `validationMessageBuilder`, `PhoneValidationIssue`)
- Dependency: [phone_numbers_parser](https://pub.dev/packages/phone_numbers_parser) (Flutter SDK + this package)

## Installation

```yaml
dependencies:
  customized_country_phone_picker: ^0.6.0
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

## Inline country prefix

Embed the country picker inside the phone field as a tappable prefix — e.g. `EG (+20) ▾` followed by the number input.

```dart
CountryPhoneInput(
  controller: ctrl,
  layout: CountryPhoneInputLayout.inlinePrefix,
  countryIdentifierDisplay: CountryIdentifierDisplay.isoCode, // or .flag
  countryBoxDecoration: const CountryBoxDecoration.flat(showArrow: true),
  phoneFieldDecoration: PhoneFieldDecoration.filled(
    hintText: 'Enter your phone number',
  ),
  onCountryChanged: (c) {},
)
```

Set globally via theme:

```dart
theme: CountryPhonePickerThemeData(
  layout: CountryPhoneInputLayout.inlinePrefix,
  countryIdentifierDisplay: CountryIdentifierDisplay.isoCode,
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

> When using `CountryPhoneInputLayout.inlinePrefix`, the dial code is shown in the inline prefix widget (`(+20)`). The separate `DialCodeDisplay.inField` prefix is not duplicated.

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

Optional custom placeholder via `PhoneFieldDecoration.hintText` (defaults to the country's example number).

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
    layout: CountryPhoneInputLayout.inlinePrefix,
    countryIdentifierDisplay: CountryIdentifierDisplay.isoCode,
    dialCodeDisplay: DialCodeDisplay.inBox,
    countryBoxDecoration: CountryBoxDecoration.pill(backgroundColor: Colors.grey.shade100),
    phoneFieldDecoration: PhoneFieldDecoration.bordered(focusBorderColor: Colors.red, borderRadius: 16),
    sheetSearchHint: 'Find a country...',
    tileSelectedColor: Colors.red.withValues(alpha: 0.1),
  ),
)
```

## Paste-to-detect, autovalidate, and strict validation

Paste values such as `+20 100 123 4567` or `00201001234567` into the phone field to set Egypt and keep only the national digits (`detectCountryOnPaste`, default on). For shared prefixes such as `+1`, use `pasteAmbiguityPolicy` (`preferCurrentCountry`, `preferPriorityList`, or `firstAlphabeticalByIso`). Digit-only pastes that are only a single-digit calling code (e.g. US/CA) are **not** auto-detected unless the pasted text includes `+` or `00`.

When pasted digits exceed the country's `maxLength`, the field keeps the **last** `maxLength` digits (leading digits are dropped). This applies to both international and plain digit pastes.

Use `autovalidateMode` with an optional `validationMessageBuilder` to localize errors with your `AppLocalizations`. Enable `useStrictPhoneValidation` for [phone_numbers_parser](https://pub.dev/packages/phone_numbers_parser) pattern checks after length validation.

```dart
CountryPhoneInput(
  controller: ctrl,
  onCountryChanged: (c) {},
  autovalidateMode: AutovalidateMode.onUserInteraction,
  useStrictPhoneValidation: true,
  pasteAmbiguityPolicy: PasteAmbiguityPolicy.preferCurrentCountry,
  validationMessageBuilder: (context, issue, validationCtx) {
    // return AppLocalizations.of(context)!.phoneError(issue.name);
    return defaultPhoneValidationMessage(issue, validationCtx);
  },
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

## Example app

Run the included demo to explore all layouts and presets:

```bash
cd example
flutter run
```

Tabs: **Hero** (inline prefix signup), **Inline** (flag vs ISO code), **Dial Modes**, **Country Box**, **Phone Field**, **Picker**, **Themed Search**.

## License

MIT

## 0.6.0

- **Inline country prefix:** `CountryPhoneInputLayout.inlinePrefix` embeds the country selector inside the phone field as a tappable prefix (e.g. `EG (+20) ▾`). Set via `CountryPhoneInput.layout` or `CountryPhonePickerThemeData.layout`.
- **Country identifier display:** `CountryIdentifierDisplay` (`flag` or `isoCode`) to show a flag emoji or ISO code (e.g. `EG`) in the country selector. Configurable globally in theme or per widget (`countryIdentifierDisplay`).
- **Paste truncation:** when pasted digits exceed the country's `maxLength`, the field keeps the **trailing** digits and drops leading ones (via `InternationalPasteFormatter.truncateToMaxLength`).
- **Custom hint:** optional `PhoneFieldDecoration.hintText` overrides the default example-number placeholder.
- **Exports:** `country_phone_input_layout.dart`, `country_identifier_display.dart`.
- Example app: new **Inline** demo tab; hero signup screen uses inline prefix layout.

## 0.5.0

- **Paste-to-detect:** pasting `+…`, `00…`, or a long digit string starting with a country calling code updates the selected country and strips the prefix in the field (`detectCountryOnPaste`, `pasteAmbiguityPolicy`).
- **Localized validation:** `PhoneValidationIssue`, `PhoneValidationContext`, `defaultPhoneValidationMessage`, and `CountryPhoneInput.validationMessageBuilder` / `autovalidateMode` for in-field errors; `CountryModel.validateNationalDigitsIssue` for structured length checks.
- **Strict validation:** `useStrictPhoneValidation` uses [phone_numbers_parser](https://pub.dev/packages/phone_numbers_parser) (`PhoneValidationIssue.invalidNationalNumber`); new dependency `phone_numbers_parser`.
- `CountriesData.countriesMatchingLeadingDigits` for longest-prefix dial code matching.
- **Exports:** `phone_validation.dart`, `strict_phone_validator.dart`, `international_paste_formatter.dart` (`InternationalPasteFormatter`, `PasteAmbiguityPolicy`).

## 0.4.1

- Added `screenshots` in `pubspec.yaml` so pub.dev shows carousel and right-rail previews.
- README: pub.dev / GitHub status badges (version, points, popularity, license, stars).

## 0.4.0

- **Breaking:** `CountryPhoneInput` now clears the phone number text when the user picks a different country. Opt out with `clearTextOnCountryChange: false` to keep the previous behavior. Re-selecting the same country is a no-op.

## 0.3.3

- Rebuilt the `example/` app into a six-screen demo (hero signup, dial code modes, country box presets, phone field presets, picker presentation, themed search) with a brand-matched light/dark theme and an AppBar toggle.
- Added screenshots under `example/images/` and embedded them in the README next to the matching feature sections.
- No package API changes.

## 0.3.2

- Updated `LICENSE` copyright to Mustafa Younis.

## 0.3.1

- Shortened `pubspec.yaml` `description` to meet pub.dev length rules (60–180 characters).
- README: installation version, feature list, and examples aligned with dialog picker, search field theming, and `CountryPickerSearchDecoration`.

## 0.3.0

- Added `CountryPickerSearchDecoration` for granular styling of the picker search field (borders, fill, padding, hint, cursor, outlined/filled presets).
- Extended `CountryPhonePickerThemeData` with `searchFieldDecoration` and `copyWith`. `CountryPhoneInput.searchFieldDecoration` overrides the theme value for the picker only.
- Search field: optional custom `prefix` and `suffix` widgets; default clear control when the field is not empty (`showClearButton`, `clearIcon`, `clearIconColor`, `clearButton`, `clearButtonTooltip`).
- Picker search uses a `FocusNode` so focused border colors apply when using `CountryPickerSearchDecoration` (full `InputDecoration` via `sheetSearchDecoration` still overrides the built-in search layout).

## 0.2.0

- Fixed modal country picker so tapping the scrim dismisses the sheet (`DraggableScrollableSheet` no longer expands over the full screen).
- Added `CountryPickerPresentation` and `CountryPhoneInput.countryPickerPresentation` to open the list in a bottom sheet (default) or a centered dialog.
- Added `CountryPickerDialog.show` with the same options as the bottom sheet (`selectedIsoCode`, `locale`, `countries`, `priorityCountryCodes`, `theme`). Dialog uses `sheetBackgroundColor` and `sheetTopRadius` from the theme for surface and corner radius.

## 0.1.1

- Fixed country box and phone field height mismatch when displayed side by side

## 0.1.0

- Initial release
- `CountryPhoneInput` widget with country picker bottom sheet
- Three dial code display modes: `inField`, `inBox`, `hidden`
- `CountryBoxDecoration` with `pill`, `outlined`, `flat` presets
- `PhoneFieldDecoration` with `bordered`, `filled`, `underline` presets
- Bilingual country names (English + Arabic)
- Phone number length validation per country
- 80+ countries with emoji flags
- Zero external dependencies

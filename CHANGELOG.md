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

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

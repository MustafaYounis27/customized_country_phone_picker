# Example App UI Redesign — Design Spec

**Date:** 2026-04-19
**Scope:** `example/` app only — no changes to the package under `lib/`.
**Goal:** Rebuild the example app so it produces README-ready screenshots that showcase the package's features cleanly.

## Motivation

The current example (`example/lib/main.dart`) is a single-screen dev harness. It uses clashing demo colors (yellow background, red/blue/green borders), mixes multiple feature toggles in one list, and was written to verify functionality rather than present it. It is not suitable for pub.dev README screenshots.

The redesigned example must:

1. Present each major feature in a clean, focused frame suited to screenshots.
2. Feel like a real Flutter app, not a test harness.
3. Prove theme-awareness by rendering correctly in both light and dark mode.
4. Add zero new dependencies to the example.
5. Leave the package API untouched.

## Structural Decisions

| Decision | Choice |
| --- | --- |
| Layout strategy | Hybrid: hero landing screen + dedicated per-feature sub-screens |
| Brand identity | Refined red (seed `Color(0xFFC62828)`) + warm neutrals |
| Hero framing | Realistic "Create account" signup card |
| Theme support | Light + dark with toggle in the AppBar |
| Navigation | Scrollable top `TabBar` (six tabs) |
| Typography | System default — no `google_fonts` dependency |
| Screenshot output | New `example/screenshots/` folder (captured manually, not by code) |

## File Structure

```
example/lib/
  main.dart                          // MaterialApp + ThemeMode notifier + root Scaffold
  theme/
    app_theme.dart                   // lightTheme, darkTheme, shared brand palette
  screens/
    hero_signup_screen.dart
    dial_code_modes_screen.dart
    country_box_presets_screen.dart
    phone_field_presets_screen.dart
    picker_presentation_screen.dart
    themed_search_screen.dart
  widgets/
    section_header.dart              // screen title + one-line subtitle
    variant_label.dart               // small uppercase caption above each demo input
    demo_card.dart                   // rounded surface container wrapping a demo block
example/screenshots/                 // new, populated manually post-build
```

The six screens live in a `TabBarView` under a single root `Scaffold`. No push routes are used (except the picker itself, which is internal to the package).

## Theme Design

Both themes are derived from `ColorScheme.fromSeed(seedColor: Color(0xFFC62828))` with Material 3 enabled.

**Light**
- Scaffold: `#FAFAFA`
- Surface: `#FFFFFF`
- Primary: crimson (from seed)
- On-surface: `#1F2937`

**Dark**
- Built via `ColorScheme.fromSeed(seedColor: Color(0xFFC62828), brightness: Brightness.dark)` and used as-is (Material 3 derives an appropriately desaturated crimson primary automatically).
- Scaffold background override: `#0F1115`
- Surface override: `#1A1D23`
- On-surface override: `#E5E7EB`

**Shared component theming**
- `cardTheme`: 16px radius, elevation 0, 1px hairline border using `outlineVariant`.
- `appBarTheme`: transparent background, zero elevation, centered title.
- `textTheme`: `titleLarge` 20/600, `titleSmall` 14/600, `bodySmall` 13/400. Font family left unset (system default).
- `filledButtonTheme`: 48px min height, 12px radius.
- `inputDecorationTheme`: 12px radius, filled with `surfaceContainerHighest` in light, `surfaceContainer` in dark.

## Root Scaffold & Navigation

`main.dart` holds a top-level `ValueNotifier<ThemeMode>` (default `ThemeMode.light`). `MaterialApp` wraps a `ValueListenableBuilder` so toggling rebuilds the whole tree.

**AppBar**
- Title: "Country Phone Picker" (`titleLarge`).
- Single action: an `IconButton` that toggles the `ThemeMode` notifier. Icon is `Icons.light_mode` in dark mode, `Icons.dark_mode` in light mode.

**TabBar**
- `isScrollable: true`, `tabAlignment: TabAlignment.start`.
- Tabs in order: **Hero**, **Dial Modes**, **Country Box**, **Phone Field**, **Picker**, **Themed Search**.
- Unselected label color: `onSurfaceVariant`. Selected: `primary`. Indicator: 3px crimson underline with 8px corner radius.

**Body**
- `TabBarView` containing the six screens. Each screen mixes in `AutomaticKeepAliveClientMixin` so tab switches preserve scroll position.

No bottom navigation, no drawer.

## Hero Screen — Signup Mockup

A single centered card on the scaffold background. The card has 24px internal padding, 20px corner radius, `surface` background, 1px hairline border, and a max width of 420 (centered horizontally on wider viewports, 24px outer margin on phones).

Inside the card, top-to-bottom:

1. **Icon avatar** — `CircleAvatar` (48px) with a `phone_android` icon tinted crimson.
2. **Title** — "Create your account" (`titleLarge`).
3. **Subtitle** — "We'll send a verification code to your phone." (`bodyMedium`, muted via `onSurfaceVariant`).
4. **Country phone input** — default `CountryPhoneInput` (bottom sheet presentation). `FieldLabel`: "Phone number". Default country: Egypt (ISO `EG`).
5. **Terms row** — `Text.rich` reading "By continuing you agree to our Terms & Privacy" (12px, muted).
6. **Primary button** — full-width `FilledButton` labeled "Continue". Disabled until the controller's text has ≥ 6 characters; enabled state visually confirms validation.
7. **Secondary link** — centered `TextButton` "Already have an account? Sign in".

Vertical gaps between elements: 16px.

Screenshot candidates:
- Card at rest (light + dark).
- Card with picker bottom sheet open (light).

## Sub-Screen Shell

Every non-hero screen shares the same structure:

```
SafeArea → ListView(padding: 24) →
  SectionHeader(title, subtitle)
  SizedBox(height: 16)
  DemoCard(label, child)
  SizedBox(height: 16)
  DemoCard(label, child)
  ...
```

- `SectionHeader` = title (`titleLarge`) + one-line subtitle (`bodySmall`, muted).
- `DemoCard` = rounded `Material` container (surface, 16px radius, 1px hairline border, 20px padding) containing a `VariantLabel` then the demo widget.
- `VariantLabel` = uppercase caption (11px, 600 weight, crimson, 0.8 letter-spacing).

## Dial Code Modes Screen

- **Header**: "Dial code display" / "Three ways to show the dial code."
- Three `DemoCard`s labeled **IN FIELD**, **IN BOX**, **HIDDEN**.
- Each hosts a `CountryPhoneInput` with the matching `DialCodeDisplay` value and its own prefilled controller (Egyptian sample `5123456789`).

## Country Box Presets Screen

- **Header**: "Country box presets" / "Pill, outlined, or flat."
- Three `DemoCard`s labeled **PILL**, **OUTLINED**, **FLAT**.
- Each uses the preset's default constructor (`CountryBoxDecoration.pill()`, `.outlined()`, `.flat()`) with no color overrides. Phone field uses its own default.

## Phone Field Presets Screen

- **Header**: "Phone field presets" / "Bordered, filled, or underline."
- Three `DemoCard`s labeled **BORDERED**, **FILLED**, **UNDERLINE**.
- Each uses the preset default constructor with no color overrides.

## Picker Presentation Screen

- **Header**: "Picker presentation" / "Open as a bottom sheet or dialog."
- Two full-width `FilledButton.tonal` buttons stacked vertically with 12px gap: "Open as bottom sheet" / "Open as dialog".
- Each invokes the corresponding standalone picker (`CountryPickerBottomSheet.show` / `CountryPickerDialog.show`).
- Below the buttons, a result row: if a country has been selected, show a `DemoCard` containing the flag emoji, English name, and dial code.

## Themed Search Screen

- **Header**: "Themed picker search" / "Style the picker's search field to match your app."
- One `DemoCard` labeled **STYLED SEARCH** containing a `CountryPhoneInput` configured with:
  - Default bottom-sheet presentation.
  - `theme: CountryPhonePickerThemeData(sheetSearchHint: 'Find a country', searchFieldDecoration: CountryPickerSearchDecoration(borderRadius: 16, borderColor: crimson, focusedBorderColor: crimson, fillColor: <soft-crimson>, prefixIcon: Icons.public, clearIcon: Icons.close))`.
  - Soft fill color: `#FFF5F5` in light mode, `#2A1A1A` in dark mode. Resolved via `Theme.of(context).brightness`.
- Below the card, a short helper paragraph: "Tap the country box above to see the themed search field in action."

## Screenshot Workflow (Out of Scope for Code)

These captures are NOT produced by the example app — they're captured manually after the redesigned example runs. Listed here so the design stays honest about the deliverable.

| File | Screen | Mode | State |
| --- | --- | --- | --- |
| `hero_light.png` | Hero | Light | Rest |
| `hero_dark.png` | Hero | Dark | Rest |
| `hero_sheet_open_light.png` | Hero | Light | Sheet open, search visible |
| `dial_modes_light.png` | Dial Modes | Light | Rest |
| `dial_modes_dark.png` | Dial Modes | Dark | Rest |
| `country_box_presets_light.png` | Country Box | Light | Rest |
| `country_box_presets_dark.png` | Country Box | Dark | Rest |
| `phone_field_presets_light.png` | Phone Field | Light | Rest |
| `phone_field_presets_dark.png` | Phone Field | Dark | Rest |
| `picker_presentation_sheet_light.png` | Picker | Light | Sheet open |
| `picker_presentation_dialog_light.png` | Picker | Light | Dialog open |
| `themed_search_open_light.png` | Themed Search | Light | Sheet open with styled search |
| `themed_search_open_dark.png` | Themed Search | Dark | Sheet open with styled search |

Target device for capture: iPhone 14 Pro simulator (390×844) or Pixel 7 (412×915), portrait. Screenshots stored in `example/screenshots/`, referenced from README via relative paths (README updates are a separate follow-up task, not part of this spec).

## Out of Scope

- Changes to the package under `lib/`.
- README content updates (image embedding will be a separate task after screenshots exist).
- Web, desktop, or landscape layout optimization — phone portrait only.
- Localization toggle in-app (the picker already supports Arabic via its own `locale` parameter; the example app UI itself stays English).
- CI screenshot automation (`flutter_gen`, `golden_toolkit`, etc.) — out of scope.
- New dependencies of any kind for the example app.

## Risks & Notes

- The default constructors for `CountryBoxDecoration` and `PhoneFieldDecoration` presets must render acceptably on both light and dark surfaces without explicit color overrides. If any preset looks broken on dark surface, the correct fix is in the package (separate work), not a demo-time override. Flag any such case during implementation rather than papering over it.
- `AutomaticKeepAliveClientMixin` on every tab means all six screens stay in memory. This is fine for a demo app but worth noting.
- The theme toggle must not reset per-screen state (tab position, controllers, selected countries). Using a top-level `ValueNotifier<ThemeMode>` above the `TabController` achieves this naturally.

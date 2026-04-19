# Example UI Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild `example/` into a six-screen, light/dark-aware demo that produces README-ready screenshots, without adding dependencies or touching the package under `lib/`.

**Architecture:** Single `MaterialApp` with a top-level `ValueNotifier<ThemeMode>` driving light/dark. Root `Scaffold` hosts an `AppBar` (title + theme toggle action) above a scrollable `TabBar` and `TabBarView` with six feature screens. All screens share reusable widgets (`SectionHeader`, `DemoCard`, `VariantLabel`). Theme defined in a dedicated module and built from a single crimson seed color.

**Tech Stack:** Flutter 3.7+, Material 3, no new dependencies. The example depends on the parent package via relative path (already wired in `example/pubspec.yaml`).

**Working directory for all commands:** `example/` (inside `/Users/mustafayounis/Downloads/theaddressholding/customized_country_phone_picker/example`).

**No automated tests.** This is a UI demo app. Each task ends with `flutter analyze` and a manual visual verification step using `flutter run`. The package's own tests under `../test/` are unaffected.

**Spec:** `docs/superpowers/specs/2026-04-19-example-ui-redesign-design.md`.

---

## Task 1: Create the brand palette and theme module

**Files:**
- Create: `example/lib/theme/app_theme.dart`

- [ ] **Step 1: Create the file with light and dark themes**

```dart
// example/lib/theme/app_theme.dart
import 'package:flutter/material.dart';

/// Brand palette + light/dark [ThemeData] builders for the example app.
class AppTheme {
  AppTheme._();

  /// Refined deep crimson used as the Material 3 seed color.
  static const Color seed = Color(0xFFC62828);

  /// Soft crimson surface tint used on the themed-search screen.
  static const Color softCrimsonLight = Color(0xFFFFF5F5);
  static const Color softCrimsonDark = Color(0xFF2A1A1A);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: seed);
    return _build(
      scheme: scheme,
      scaffold: const Color(0xFFFAFAFA),
      surface: Colors.white,
      onSurface: const Color(0xFF1F2937),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
    return _build(
      scheme: scheme,
      scaffold: const Color(0xFF0F1115),
      surface: const Color(0xFF1A1D23),
      onSurface: const Color(0xFFE5E7EB),
    );
  }

  static ThemeData _build({
    required ColorScheme scheme,
    required Color scaffold,
    required Color surface,
    required Color onSurface,
  }) {
    final patched = scheme.copyWith(surface: surface, onSurface: onSurface);
    return ThemeData(
      useMaterial3: true,
      colorScheme: patched,
      scaffoldBackgroundColor: scaffold,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: patched.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: patched.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: patched.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
      ),
    );
  }
}
```

- [ ] **Step 2: Run static analysis**

Run: `cd example && flutter analyze lib/theme/app_theme.dart`
Expected: No issues found.

- [ ] **Step 3: Commit**

```bash
git add example/lib/theme/app_theme.dart
git commit -m "feat(example): add brand theme module"
```

---

## Task 2: Create shared layout widgets

**Files:**
- Create: `example/lib/widgets/section_header.dart`
- Create: `example/lib/widgets/variant_label.dart`
- Create: `example/lib/widgets/demo_card.dart`

- [ ] **Step 1: Create `section_header.dart`**

```dart
// example/lib/widgets/section_header.dart
import 'package:flutter/material.dart';

/// Screen-level header: large title + one-line muted subtitle.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Create `variant_label.dart`**

```dart
// example/lib/widgets/variant_label.dart
import 'package:flutter/material.dart';

/// Small uppercase caption shown above each demo variant.
class VariantLabel extends StatelessWidget {
  const VariantLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: colorScheme.primary,
      ),
    );
  }
}
```

- [ ] **Step 3: Create `demo_card.dart`**

```dart
// example/lib/widgets/demo_card.dart
import 'package:flutter/material.dart';
import 'variant_label.dart';

/// Rounded surface container that wraps a demo variant with its label.
class DemoCard extends StatelessWidget {
  const DemoCard({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VariantLabel(label),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run static analysis**

Run: `cd example && flutter analyze lib/widgets`
Expected: No issues found.

- [ ] **Step 5: Commit**

```bash
git add example/lib/widgets/
git commit -m "feat(example): add shared layout widgets"
```

---

## Task 3: Replace `main.dart` with the theme-aware root scaffold and placeholder screens

This task wires up the root structure so we can visually verify theme toggling and tab navigation before building individual screens.

**Files:**
- Modify: `example/lib/main.dart` (replace entire contents)

- [ ] **Step 1: Replace `main.dart` contents**

```dart
// example/lib/main.dart
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.light);

  @override
  void dispose() {
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Country Phone Picker',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: RootScaffold(themeMode: _themeMode),
        );
      },
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key, required this.themeMode});

  final ValueNotifier<ThemeMode> themeMode;

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> with TickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = <String>[
    'Hero',
    'Dial Modes',
    'Country Box',
    'Phone Field',
    'Picker',
    'Themed Search',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Phone Picker'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: widget.themeMode,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark ? 'Switch to light' : 'Switch to dark',
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  widget.themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
                },
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: colorScheme.primary,
          indicatorWeight: 3,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          tabs: [for (final t in _tabs) Tab(text: t)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _PlaceholderScreen(name: 'Hero'),
          _PlaceholderScreen(name: 'Dial Modes'),
          _PlaceholderScreen(name: 'Country Box'),
          _PlaceholderScreen(name: 'Phone Field'),
          _PlaceholderScreen(name: 'Picker'),
          _PlaceholderScreen(name: 'Themed Search'),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('$name screen'));
  }
}
```

- [ ] **Step 2: Run static analysis**

Run: `cd example && flutter analyze lib/main.dart`
Expected: No issues found.

- [ ] **Step 3: Run the app and verify**

Run: `cd example && flutter run -d <device_id>` (use `flutter devices` to pick an iOS/Android simulator).

Visual checks:
- AppBar shows "Country Phone Picker" title and a dark-mode icon button on the right.
- Six tabs are visible in a horizontally scrollable row; crimson underline under the active tab.
- Tapping the AppBar action swaps icons and the whole UI flips between light and dark; tab position persists across the toggle.
- Tapping each tab shows the placeholder text.

Stop the app (press `q` in the terminal) after visual confirmation.

- [ ] **Step 4: Commit**

```bash
git add example/lib/main.dart
git commit -m "feat(example): root scaffold with tabs and theme toggle"
```

---

## Task 4: Build the Hero (signup) screen

**Files:**
- Create: `example/lib/screens/hero_signup_screen.dart`
- Modify: `example/lib/main.dart` (swap the Hero placeholder for the real screen)

- [ ] **Step 1: Create `hero_signup_screen.dart`**

```dart
// example/lib/screens/hero_signup_screen.dart
import 'package:flutter/material.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

class HeroSignupScreen extends StatefulWidget {
  const HeroSignupScreen({super.key});

  @override
  State<HeroSignupScreen> createState() => _HeroSignupScreenState();
}

class _HeroSignupScreenState extends State<HeroSignupScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canContinue = _controller.text.length >= 6;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                      child: Icon(Icons.phone_android, color: colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Create your account',
                    style: textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We'll send a verification code to your phone.",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Phone number',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  CountryPhoneInput(
                    controller: _controller,
                    onCountryChanged: (_) {},
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'By continuing you agree to our Terms & Privacy.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: canContinue ? () {} : null,
                    child: const Text('Continue'),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Already have an account? Sign in'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Wire the Hero screen into `main.dart`**

In `example/lib/main.dart`, at the top add:

```dart
import 'screens/hero_signup_screen.dart';
```

Then replace the first child of `TabBarView`:

Find:
```dart
          _PlaceholderScreen(name: 'Hero'),
```
Replace with:
```dart
          const HeroSignupScreen(),
```

- [ ] **Step 3: Run static analysis**

Run: `cd example && flutter analyze lib/screens/hero_signup_screen.dart lib/main.dart`
Expected: No issues found.

- [ ] **Step 4: Visual verification**

Run: `cd example && flutter run -d <device_id>`

Checks on the Hero tab:
- Card is centered, rounded, with hairline border.
- Crimson-tinted avatar with phone icon at top.
- "Create your account" + subtitle.
- Country phone input with Egypt flag default.
- "Continue" button is disabled until you type ≥ 6 digits.
- Tapping the country box opens the bottom sheet picker.
- Toggle to dark mode and confirm the card stays readable and the border is visible.

- [ ] **Step 5: Commit**

```bash
git add example/lib/screens/hero_signup_screen.dart example/lib/main.dart
git commit -m "feat(example): hero signup screen"
```

---

## Task 5: Build the Dial Code Modes screen

**Files:**
- Create: `example/lib/screens/dial_code_modes_screen.dart`
- Modify: `example/lib/main.dart`

- [ ] **Step 1: Create `dial_code_modes_screen.dart`**

```dart
// example/lib/screens/dial_code_modes_screen.dart
import 'package:flutter/material.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

import '../widgets/demo_card.dart';
import '../widgets/section_header.dart';

class DialCodeModesScreen extends StatefulWidget {
  const DialCodeModesScreen({super.key});

  @override
  State<DialCodeModesScreen> createState() => _DialCodeModesScreenState();
}

class _DialCodeModesScreenState extends State<DialCodeModesScreen>
    with AutomaticKeepAliveClientMixin {
  final _inField = TextEditingController(text: '5123456789');
  final _inBox = TextEditingController(text: '5123456789');
  final _hidden = TextEditingController(text: '5123456789');

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _inField.dispose();
    _inBox.dispose();
    _hidden.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SectionHeader(
            title: 'Dial code display',
            subtitle: 'Three ways to show the dial code.',
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'In field',
            child: CountryPhoneInput(
              controller: _inField,
              dialCodeDisplay: DialCodeDisplay.inField,
              onCountryChanged: (_) {},
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'In box',
            child: CountryPhoneInput(
              controller: _inBox,
              dialCodeDisplay: DialCodeDisplay.inBox,
              onCountryChanged: (_) {},
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'Hidden',
            child: CountryPhoneInput(
              controller: _hidden,
              dialCodeDisplay: DialCodeDisplay.hidden,
              onCountryChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Wire into `main.dart`**

Add import:
```dart
import 'screens/dial_code_modes_screen.dart';
```

Replace:
```dart
          _PlaceholderScreen(name: 'Dial Modes'),
```
With:
```dart
          const DialCodeModesScreen(),
```

- [ ] **Step 3: Run static analysis**

Run: `cd example && flutter analyze lib/screens/dial_code_modes_screen.dart lib/main.dart`
Expected: No issues found.

- [ ] **Step 4: Visual verification**

Run the app. On the "Dial Modes" tab:
- Title "Dial code display" + subtitle visible.
- Three `DemoCard`s stacked with labels **IN FIELD**, **IN BOX**, **HIDDEN**.
- Each input shows the same prefilled number but renders the dial code differently per the label.
- Cards render correctly in light and dark.

- [ ] **Step 5: Commit**

```bash
git add example/lib/screens/dial_code_modes_screen.dart example/lib/main.dart
git commit -m "feat(example): dial code modes screen"
```

---

## Task 6: Build the Country Box Presets screen

**Files:**
- Create: `example/lib/screens/country_box_presets_screen.dart`
- Modify: `example/lib/main.dart`

- [ ] **Step 1: Create `country_box_presets_screen.dart`**

```dart
// example/lib/screens/country_box_presets_screen.dart
import 'package:flutter/material.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

import '../widgets/demo_card.dart';
import '../widgets/section_header.dart';

class CountryBoxPresetsScreen extends StatefulWidget {
  const CountryBoxPresetsScreen({super.key});

  @override
  State<CountryBoxPresetsScreen> createState() => _CountryBoxPresetsScreenState();
}

class _CountryBoxPresetsScreenState extends State<CountryBoxPresetsScreen>
    with AutomaticKeepAliveClientMixin {
  final _pill = TextEditingController(text: '5123456789');
  final _outlined = TextEditingController(text: '5123456789');
  final _flat = TextEditingController(text: '5123456789');

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pill.dispose();
    _outlined.dispose();
    _flat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SectionHeader(
            title: 'Country box presets',
            subtitle: 'Pill, outlined, or flat.',
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'Pill',
            child: CountryPhoneInput(
              controller: _pill,
              countryBoxDecoration: const CountryBoxDecoration.pill(),
              onCountryChanged: (_) {},
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'Outlined',
            child: CountryPhoneInput(
              controller: _outlined,
              countryBoxDecoration: const CountryBoxDecoration.outlined(),
              onCountryChanged: (_) {},
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'Flat',
            child: CountryPhoneInput(
              controller: _flat,
              countryBoxDecoration: const CountryBoxDecoration.flat(),
              onCountryChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Wire into `main.dart`**

Add import:
```dart
import 'screens/country_box_presets_screen.dart';
```

Replace:
```dart
          _PlaceholderScreen(name: 'Country Box'),
```
With:
```dart
          const CountryBoxPresetsScreen(),
```

- [ ] **Step 3: Run static analysis**

Run: `cd example && flutter analyze lib/screens/country_box_presets_screen.dart lib/main.dart`
Expected: No issues found.

- [ ] **Step 4: Visual verification**

On the "Country Box" tab:
- Title/subtitle rendered.
- Three cards: PILL, OUTLINED, FLAT — each visibly different.
- Both light and dark render cleanly. If a preset looks broken on dark surface, STOP and report it; the fix belongs in the package, not here.

- [ ] **Step 5: Commit**

```bash
git add example/lib/screens/country_box_presets_screen.dart example/lib/main.dart
git commit -m "feat(example): country box presets screen"
```

---

## Task 7: Build the Phone Field Presets screen

**Files:**
- Create: `example/lib/screens/phone_field_presets_screen.dart`
- Modify: `example/lib/main.dart`

- [ ] **Step 1: Create `phone_field_presets_screen.dart`**

```dart
// example/lib/screens/phone_field_presets_screen.dart
import 'package:flutter/material.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

import '../widgets/demo_card.dart';
import '../widgets/section_header.dart';

class PhoneFieldPresetsScreen extends StatefulWidget {
  const PhoneFieldPresetsScreen({super.key});

  @override
  State<PhoneFieldPresetsScreen> createState() => _PhoneFieldPresetsScreenState();
}

class _PhoneFieldPresetsScreenState extends State<PhoneFieldPresetsScreen>
    with AutomaticKeepAliveClientMixin {
  final _bordered = TextEditingController(text: '5123456789');
  final _filled = TextEditingController(text: '5123456789');
  final _underline = TextEditingController(text: '5123456789');

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _bordered.dispose();
    _filled.dispose();
    _underline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SectionHeader(
            title: 'Phone field presets',
            subtitle: 'Bordered, filled, or underline.',
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'Bordered',
            child: CountryPhoneInput(
              controller: _bordered,
              phoneFieldDecoration: const PhoneFieldDecoration.bordered(),
              onCountryChanged: (_) {},
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'Filled',
            child: CountryPhoneInput(
              controller: _filled,
              phoneFieldDecoration: const PhoneFieldDecoration.filled(),
              onCountryChanged: (_) {},
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'Underline',
            child: CountryPhoneInput(
              controller: _underline,
              phoneFieldDecoration: const PhoneFieldDecoration.underline(),
              onCountryChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Wire into `main.dart`**

Add import:
```dart
import 'screens/phone_field_presets_screen.dart';
```

Replace:
```dart
          _PlaceholderScreen(name: 'Phone Field'),
```
With:
```dart
          const PhoneFieldPresetsScreen(),
```

- [ ] **Step 3: Run static analysis**

Run: `cd example && flutter analyze lib/screens/phone_field_presets_screen.dart lib/main.dart`
Expected: No issues found.

- [ ] **Step 4: Visual verification**

On the "Phone Field" tab:
- Three cards labeled BORDERED, FILLED, UNDERLINE.
- Focus one field — focus border color uses the crimson primary.
- Light and dark both render cleanly.

- [ ] **Step 5: Commit**

```bash
git add example/lib/screens/phone_field_presets_screen.dart example/lib/main.dart
git commit -m "feat(example): phone field presets screen"
```

---

## Task 8: Build the Picker Presentation screen

**Files:**
- Create: `example/lib/screens/picker_presentation_screen.dart`
- Modify: `example/lib/main.dart`

- [ ] **Step 1: Create `picker_presentation_screen.dart`**

```dart
// example/lib/screens/picker_presentation_screen.dart
import 'package:flutter/material.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

import '../widgets/demo_card.dart';
import '../widgets/section_header.dart';

class PickerPresentationScreen extends StatefulWidget {
  const PickerPresentationScreen({super.key});

  @override
  State<PickerPresentationScreen> createState() => _PickerPresentationScreenState();
}

class _PickerPresentationScreenState extends State<PickerPresentationScreen>
    with AutomaticKeepAliveClientMixin {
  CountryModel? _lastPicked;

  @override
  bool get wantKeepAlive => true;

  Future<void> _openSheet() async {
    final result = await CountryPickerBottomSheet.show(context);
    if (result != null && mounted) setState(() => _lastPicked = result);
  }

  Future<void> _openDialog() async {
    final result = await CountryPickerDialog.show(context);
    if (result != null && mounted) setState(() => _lastPicked = result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SectionHeader(
            title: 'Picker presentation',
            subtitle: 'Open as a bottom sheet or dialog.',
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _openSheet,
            child: const Text('Open as bottom sheet'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: _openDialog,
            child: const Text('Open as dialog'),
          ),
          const SizedBox(height: 24),
          if (_lastPicked != null)
            DemoCard(
              label: 'Last selected',
              child: Row(
                children: [
                  Text(_lastPicked!.flag, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _lastPicked!.nameEn,
                      style: textTheme.bodyLarge,
                    ),
                  ),
                  Text(_lastPicked!.dialCode, style: textTheme.bodyLarge),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Wire into `main.dart`**

Add import:
```dart
import 'screens/picker_presentation_screen.dart';
```

Replace:
```dart
          _PlaceholderScreen(name: 'Picker'),
```
With:
```dart
          const PickerPresentationScreen(),
```

- [ ] **Step 3: Run static analysis**

Run: `cd example && flutter analyze lib/screens/picker_presentation_screen.dart lib/main.dart`
Expected: No issues found.

- [ ] **Step 4: Visual verification**

On the "Picker" tab:
- Header + two tonal buttons.
- Tapping "Open as bottom sheet" opens the sheet picker; selecting a country dismisses it and shows a "Last selected" card below with flag + name + dial code.
- Tapping "Open as dialog" opens the dialog picker; same behavior.
- Result card survives tab switches (verify by going to another tab and back).

- [ ] **Step 5: Commit**

```bash
git add example/lib/screens/picker_presentation_screen.dart example/lib/main.dart
git commit -m "feat(example): picker presentation screen"
```

---

## Task 9: Build the Themed Search screen

**Files:**
- Create: `example/lib/screens/themed_search_screen.dart`
- Modify: `example/lib/main.dart`

- [ ] **Step 1: Create `themed_search_screen.dart`**

```dart
// example/lib/screens/themed_search_screen.dart
import 'package:flutter/material.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

import '../theme/app_theme.dart';
import '../widgets/demo_card.dart';
import '../widgets/section_header.dart';

class ThemedSearchScreen extends StatefulWidget {
  const ThemedSearchScreen({super.key});

  @override
  State<ThemedSearchScreen> createState() => _ThemedSearchScreenState();
}

class _ThemedSearchScreenState extends State<ThemedSearchScreen>
    with AutomaticKeepAliveClientMixin {
  final _controller = TextEditingController(text: '5123456789');

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softFill = isDark ? AppTheme.softCrimsonDark : AppTheme.softCrimsonLight;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SectionHeader(
            title: 'Themed picker search',
            subtitle: "Style the picker's search field to match your app.",
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'Styled search',
            child: CountryPhoneInput(
              controller: _controller,
              onCountryChanged: (_) {},
              theme: CountryPhonePickerThemeData(
                sheetSearchHint: 'Find a country',
                searchFieldDecoration: CountryPickerSearchDecoration(
                  borderRadius: 16,
                  borderColor: colorScheme.primary,
                  focusedBorderColor: colorScheme.primary,
                  fillColor: softFill,
                  prefixIcon: Icons.public,
                  clearIcon: Icons.close,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap the country box above to see the themed search field in action.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Wire into `main.dart`**

Add import:
```dart
import 'screens/themed_search_screen.dart';
```

Replace:
```dart
          _PlaceholderScreen(name: 'Themed Search'),
```
With:
```dart
          const ThemedSearchScreen(),
```

Remove the now-unused `_PlaceholderScreen` class from `main.dart` (it has no remaining references).

- [ ] **Step 3: Run static analysis**

Run: `cd example && flutter analyze lib/screens/themed_search_screen.dart lib/main.dart`
Expected: No issues found.

- [ ] **Step 4: Visual verification**

On the "Themed Search" tab:
- Single DemoCard with the styled input.
- Tapping the country box opens the picker sheet; the search bar at the top has rounded corners, crimson border, soft crimson fill, and a globe prefix icon.
- The hint reads "Find a country".
- Toggle dark mode and verify the fill becomes the dark soft-crimson tint and the text stays readable.

- [ ] **Step 5: Commit**

```bash
git add example/lib/screens/themed_search_screen.dart example/lib/main.dart
git commit -m "feat(example): themed picker search screen"
```

---

## Task 10: Final polish, screenshots folder, and end-to-end verification

**Files:**
- Create: `example/screenshots/.gitkeep`

- [ ] **Step 1: Create the screenshots folder placeholder**

```bash
mkdir -p example/screenshots
: > example/screenshots/.gitkeep
```

- [ ] **Step 2: Run full static analysis on the example**

Run: `cd example && flutter analyze`
Expected: No issues found. If anything shows up, fix it before proceeding.

- [ ] **Step 3: Full visual walkthrough**

Run: `cd example && flutter run -d <device_id>`

Walk every tab in both light and dark modes. For each, confirm:

| Tab | What to confirm |
| --- | --- |
| Hero | Centered signup card, disabled-then-enabled "Continue" button, picker opens as sheet |
| Dial Modes | Three cards render, dial code position differs per card |
| Country Box | Three cards, visibly different box styles |
| Phone Field | Three cards, visibly different field styles |
| Picker | Both buttons open their respective pickers, result chip shows after selection |
| Themed Search | Styled search bar visible when picker is open, correct fill color per mode |

Toggle the AppBar theme action at least once per tab to confirm nothing snaps or resets.

- [ ] **Step 4: Ensure no unused demo code remains**

Search the example's `lib/` for `_PlaceholderScreen` — it should only have been a stepping stone and must not remain. If any matches remain, delete the class definition and any lingering references.

Run: `cd example && flutter analyze` one more time after cleanup.
Expected: No issues found.

- [ ] **Step 5: Commit the screenshots folder and any cleanup**

```bash
git add example/screenshots/.gitkeep example/lib/main.dart
git commit -m "chore(example): screenshots folder and final cleanup"
```

---

## Deliverables Summary

At the end of this plan:

- `example/lib/` contains a theme module, three shared widgets, six focused screens, and a root scaffold with theme toggle.
- Running `cd example && flutter run` on a phone-sized simulator produces all thirteen screenshot candidates listed in the spec (captured manually — see spec, not part of this plan).
- `example/screenshots/` exists and is tracked.
- No changes under `lib/` (the package itself).
- No new dependencies in `example/pubspec.yaml`.

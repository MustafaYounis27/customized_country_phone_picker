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

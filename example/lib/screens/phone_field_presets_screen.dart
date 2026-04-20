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

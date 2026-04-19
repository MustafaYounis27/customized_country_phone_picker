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

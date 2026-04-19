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

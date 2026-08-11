import 'package:flutter/material.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

import '../widgets/demo_card.dart';
import '../widgets/section_header.dart';

class InlinePrefixScreen extends StatefulWidget {
  const InlinePrefixScreen({super.key});

  @override
  State<InlinePrefixScreen> createState() => _InlinePrefixScreenState();
}

class _InlinePrefixScreenState extends State<InlinePrefixScreen> with AutomaticKeepAliveClientMixin {
  final _isoCode = TextEditingController();
  final _flag = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _isoCode.dispose();
    _flag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SectionHeader(
            title: 'Inline country prefix',
            subtitle: 'Country picker inside the phone field with flag or ISO code.',
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'ISO code (EG)',
            child: CountryPhoneInput(
              controller: _isoCode,
              layout: CountryPhoneInputLayout.inlinePrefix,
              countryIdentifierDisplay: CountryIdentifierDisplay.isoCode,
              countryBoxDecoration: const CountryBoxDecoration.flat(showArrow: true),
              phoneFieldDecoration: PhoneFieldDecoration.filled(
                backgroundColor: colorScheme.surfaceContainerHighest,
                hintText: 'Enter your phone number',
              ),
              onCountryChanged: (_) {},
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
            label: 'Flag',
            child: CountryPhoneInput(
              controller: _flag,
              layout: CountryPhoneInputLayout.inlinePrefix,
              countryIdentifierDisplay: CountryIdentifierDisplay.flag,
              countryBoxDecoration: const CountryBoxDecoration.flat(showArrow: true),
              phoneFieldDecoration: PhoneFieldDecoration.filled(
                backgroundColor: colorScheme.surfaceContainerHighest,
                hintText: 'Enter your phone number',
              ),
              onCountryChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

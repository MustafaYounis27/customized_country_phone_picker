import 'package:flutter/material.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Phone Picker Example',
      theme: ThemeData(colorSchemeSeed: Colors.red, useMaterial3: true),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final _ctrl1 = TextEditingController();
  final _ctrl2 = TextEditingController();
  final _ctrl3 = TextEditingController();
  final _ctrlDialog = TextEditingController();
  String _selectedDial = '+20';

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _ctrl3.dispose();
    _ctrlDialog.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Country Phone Picker')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Default (inField)', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          CountryPhoneInput(controller: _ctrl1, onCountryChanged: (c) => setState(() => _selectedDial = c.dialCode)),
          const SizedBox(height: 8),
          Text('Selected: $_selectedDial', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 32),
          Text('Dialog picker', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          CountryPhoneInput(
            controller: _ctrlDialog,
            countryPickerPresentation: CountryPickerPresentation.dialog,
            onCountryChanged: (c) {},
          ),
          const SizedBox(height: 32),
          Text('Dial code in box + outlined', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          CountryPhoneInput(
            controller: _ctrl2,
            countryBoxDecoration: CountryBoxDecoration.pill(backgroundColor: Colors.grey),
            phoneFieldDecoration: const PhoneFieldDecoration.bordered(
              borderColor: Colors.red,
              focusBorderColor: Colors.blue,
              errorBorderColor: Colors.green,
              borderWidth: 2,
              borderRadius: 10,
              backgroundColor: Colors.yellow,
              textStyle: TextStyle(color: Colors.red),
              hintStyle: TextStyle(color: Colors.blue),
            ),
            onCountryChanged: (c) {},
          ),
          const SizedBox(height: 32),
          Text('Hidden dial code + filled field + flat box', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          CountryPhoneInput(
            controller: _ctrl3,
            dialCodeDisplay: DialCodeDisplay.hidden,
            countryBoxDecoration: const CountryBoxDecoration.flat(),
            phoneFieldDecoration: const PhoneFieldDecoration.filled(),
            onCountryChanged: (c) {},
          ),
        ],
      ),
    );
  }
}

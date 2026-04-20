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

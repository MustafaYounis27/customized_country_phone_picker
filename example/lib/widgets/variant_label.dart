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

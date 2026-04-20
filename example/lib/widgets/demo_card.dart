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

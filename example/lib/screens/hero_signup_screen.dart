import 'package:flutter/material.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

class HeroSignupScreen extends StatefulWidget {
  const HeroSignupScreen({super.key});

  @override
  State<HeroSignupScreen> createState() => _HeroSignupScreenState();
}

class _HeroSignupScreenState extends State<HeroSignupScreen> with AutomaticKeepAliveClientMixin {
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
                  Text('Create your account', style: textTheme.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    "We'll send a verification code to your phone.",
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text('Phone number', style: textTheme.titleSmall),
                  const SizedBox(height: 8),
                  CountryPhoneInput(controller: _controller, onCountryChanged: (_) {}),
                  const SizedBox(height: 16),
                  Text(
                    'By continuing you agree to our Terms & Privacy.',
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: canContinue ? () {} : null, child: const Text('Continue')),
                  const SizedBox(height: 8),
                  Center(child: TextButton(onPressed: () {}, child: const Text('Already have an account? Sign in'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

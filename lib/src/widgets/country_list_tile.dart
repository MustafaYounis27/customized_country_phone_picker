import 'package:flutter/material.dart';

import '../models/country_model.dart';
import '../theme/country_phone_picker_theme.dart';

/// A single row in the country picker list showing flag, name, and dial code.
class CountryListTile extends StatelessWidget {
  const CountryListTile({
    super.key,
    required this.country,
    required this.locale,
    required this.onTap,
    this.isSelected = false,
    this.theme,
  });

  final CountryModel country;
  final String locale;
  final VoidCallback onTap;
  final bool isSelected;
  final CountryPhonePickerThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final nameStyle = theme?.tileNameStyle ?? textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
    final dialStyle = theme?.tileDialCodeStyle ?? nameStyle.copyWith(color: colorScheme.onSurfaceVariant);
    final selectedColor = theme?.tileSelectedColor ?? colorScheme.primary.withValues(alpha: 0.08);
    final checkColor = theme?.tileCheckColor ?? colorScheme.primary;
    final flagSize = theme?.tileFlagSize ?? 24;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? selectedColor : null,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(country.flag, style: TextStyle(fontSize: flagSize)),
            const SizedBox(width: 12),
            Expanded(child: Text(country.getName(locale), style: nameStyle, overflow: TextOverflow.ellipsis)),
            Text(country.dialCode, style: dialStyle),
            if (isSelected) ...[const SizedBox(width: 8), Icon(Icons.check, size: 18, color: checkColor)],
          ],
        ),
      ),
    );
  }
}

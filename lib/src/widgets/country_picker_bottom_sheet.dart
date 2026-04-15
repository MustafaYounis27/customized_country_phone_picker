import 'package:flutter/material.dart';

import '../models/country_model.dart';
import '../notifiers/country_picker_notifier.dart';
import '../theme/country_phone_picker_theme.dart';
import 'country_list_tile.dart';

/// A draggable bottom sheet that displays a searchable list of countries.
///
/// Use [CountryPickerBottomSheet.show] to present the picker modally.
/// Returns the selected [CountryModel], or `null` if dismissed.
class CountryPickerBottomSheet extends StatefulWidget {
  const CountryPickerBottomSheet._({
    required this.scrollController,
    required this.locale,
    this.selectedIsoCode,
    this.theme,
    this.countries,
    this.priorityCountryCodes,
  });

  final ScrollController scrollController;
  final String locale;
  final String? selectedIsoCode;
  final CountryPhonePickerThemeData? theme;
  final List<CountryModel>? countries;
  final List<String>? priorityCountryCodes;

  /// Shows the country picker as a modal bottom sheet.
  ///
  /// Returns the selected [CountryModel], or `null` if the user dismisses
  /// the sheet without selecting a country.
  static Future<CountryModel?> show(
    BuildContext context, {
    String? selectedIsoCode,
    String locale = 'en',
    List<CountryModel>? countries,
    List<String>? priorityCountryCodes,
    CountryPhonePickerThemeData? theme,
  }) {
    return showModalBottomSheet<CountryModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => CountryPickerBottomSheet._(
          scrollController: scrollController,
          locale: locale,
          selectedIsoCode: selectedIsoCode,
          theme: theme,
          countries: countries,
          priorityCountryCodes: priorityCountryCodes,
        ),
      ),
    );
  }

  @override
  State<CountryPickerBottomSheet> createState() => _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  late final CountryPickerNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = CountryPickerNotifier(
      countries: widget.countries,
      priorityCodes: widget.priorityCountryCodes,
    );
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = widget.theme;

    final bgColor = t?.sheetBackgroundColor ?? colorScheme.surface;
    final topRadius = t?.sheetTopRadius ?? 24;
    final handleColor = t?.sheetHandleColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
    final searchStyle = t?.sheetSearchStyle ?? textTheme.bodyMedium;
    final searchHint = t?.sheetSearchHint ?? 'Search';
    final dividerColor = t?.sheetDividerColor ?? colorScheme.outlineVariant;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(color: handleColor, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: TextField(
              onChanged: _notifier.search,
              decoration: t?.sheetSearchDecoration ??
                  InputDecoration(
                    hintText: searchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.outline)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.outline)),
                    contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
                  ),
              style: searchStyle,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder<CountryPickerState>(
              valueListenable: _notifier,
              builder: (context, state, _) {
                final hasPriority = state.priorityCountries.isNotEmpty;
                final totalItems = state.priorityCountries.length +
                    (hasPriority && state.filteredCountries.isNotEmpty ? 1 : 0) +
                    state.filteredCountries.length;

                return ListView.builder(
                  controller: widget.scrollController,
                  itemCount: totalItems,
                  itemBuilder: (context, index) {
                    if (index < state.priorityCountries.length) {
                      final country = state.priorityCountries[index];
                      return CountryListTile(
                        country: country, locale: widget.locale,
                        isSelected: country.isoCode == widget.selectedIsoCode,
                        theme: widget.theme,
                        onTap: () => Navigator.pop(context, country),
                      );
                    }
                    final adjustedIndex = index - state.priorityCountries.length;
                    if (hasPriority && state.filteredCountries.isNotEmpty && adjustedIndex == 0) {
                      return Divider(height: 0.5, thickness: 0.5, color: dividerColor);
                    }
                    final restIndex = adjustedIndex - (hasPriority && state.filteredCountries.isNotEmpty ? 1 : 0);
                    final country = state.filteredCountries[restIndex];
                    return CountryListTile(
                      country: country, locale: widget.locale,
                      isSelected: country.isoCode == widget.selectedIsoCode,
                      theme: widget.theme,
                      onTap: () => Navigator.pop(context, country),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

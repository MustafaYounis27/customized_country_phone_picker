import 'package:flutter/material.dart';

import '../models/country_model.dart';
import '../notifiers/country_picker_notifier.dart';
import '../theme/country_phone_picker_theme.dart';
import '../theme/country_picker_search_decoration.dart';
import 'country_list_tile.dart';

/// Search field + scrollable country list shared by the bottom sheet and dialog.
class CountryPickerBody extends StatefulWidget {
  const CountryPickerBody({
    super.key,
    required this.locale,
    this.scrollController,
    this.selectedIsoCode,
    this.theme,
    this.countries,
    this.priorityCountryCodes,
    this.showDragHandle = true,
  });

  final String locale;
  final ScrollController? scrollController;
  final String? selectedIsoCode;
  final CountryPhonePickerThemeData? theme;
  final List<CountryModel>? countries;
  final List<String>? priorityCountryCodes;
  final bool showDragHandle;

  @override
  State<CountryPickerBody> createState() => _CountryPickerBodyState();
}

class _CountryPickerBodyState extends State<CountryPickerBody> {
  late final CountryPickerNotifier _notifier;
  late final FocusNode _searchFocus;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _notifier = CountryPickerNotifier(countries: widget.countries, priorityCodes: widget.priorityCountryCodes);
    _searchFocus = FocusNode();
    _searchController = TextEditingController();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _notifier.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    _notifier.search('');
  }

  Widget? _buildSuffixIcon(CountryPickerSearchDecoration deco) {
    final trailing = <Widget>[];
    if (deco.suffix != null) trailing.add(deco.suffix!);
    if (deco.showClearButton && _searchController.text.isNotEmpty) {
      trailing.add(
        IconButton(
          tooltip: deco.clearButtonTooltip ?? 'Clear',
          onPressed: _clearSearch,
          icon: deco.clearButton ?? Icon(deco.clearIcon, color: deco.clearIconColor ?? Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }
    if (trailing.isEmpty) return null;
    if (trailing.length == 1) return trailing.single;
    return Row(mainAxisSize: MainAxisSize.min, children: trailing);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = widget.theme;

    final handleColor = t?.sheetHandleColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
    final searchStyle = t?.sheetSearchStyle ?? textTheme.bodyMedium;
    final searchHint = t?.sheetSearchHint ?? 'Search';
    final dividerColor = t?.sheetDividerColor ?? colorScheme.outlineVariant;

    final sheetSearchOverride = t?.sheetSearchDecoration;
    final searchField =
        sheetSearchOverride != null
            ? TextField(
              focusNode: _searchFocus,
              controller: _searchController,
              onChanged: _notifier.search,
              decoration: sheetSearchOverride.copyWith(hintText: sheetSearchOverride.hintText ?? searchHint),
              style: searchStyle,
            )
            : ListenableBuilder(
              listenable: _searchFocus,
              builder: (context, _) {
                final deco = t?.searchFieldDecoration ?? const CountryPickerSearchDecoration();
                return TextField(
                  focusNode: _searchFocus,
                  controller: _searchController,
                  onChanged: _notifier.search,
                  decoration: deco.buildDecoration(
                    context: context,
                    hintText: searchHint,
                    hasFocus: _searchFocus.hasFocus,
                    prefixIcon: deco.buildPrefix(context),
                    suffixIcon: _buildSuffixIcon(deco),
                  ),
                  style: searchStyle,
                  cursorColor: deco.cursorColor,
                  cursorWidth: deco.cursorWidth,
                );
              },
            );

    return Column(
      children: [
        if (widget.showDragHandle) ...[
          const SizedBox(height: 12),
          Center(
            child: Container(width: 36, height: 4, decoration: BoxDecoration(color: handleColor, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 12),
        ] else
          const SizedBox(height: 16),
        Padding(padding: const EdgeInsetsDirectional.symmetric(horizontal: 16), child: searchField),
        const SizedBox(height: 8),
        Expanded(
          child: ValueListenableBuilder<CountryPickerState>(
            valueListenable: _notifier,
            builder: (context, state, _) {
              final hasPriority = state.priorityCountries.isNotEmpty;
              final totalItems =
                  state.priorityCountries.length +
                  (hasPriority && state.filteredCountries.isNotEmpty ? 1 : 0) +
                  state.filteredCountries.length;

              return ListView.builder(
                controller: widget.scrollController,
                itemCount: totalItems,
                itemBuilder: (context, index) {
                  if (index < state.priorityCountries.length) {
                    final country = state.priorityCountries[index];
                    return CountryListTile(
                      country: country,
                      locale: widget.locale,
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
                    country: country,
                    locale: widget.locale,
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
    );
  }
}

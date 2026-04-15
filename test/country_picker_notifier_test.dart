import 'package:flutter_test/flutter_test.dart';
import 'package:customized_country_phone_picker/src/data/countries_data.dart';
import 'package:customized_country_phone_picker/src/notifiers/country_picker_notifier.dart';

void main() {
  group('CountryPickerNotifier', () {
    late CountryPickerNotifier notifier;

    setUp(() => notifier = CountryPickerNotifier());
    tearDown(() => notifier.dispose());

    test('initial state has priority and filtered countries', () {
      expect(notifier.value.priorityCountries, isNotEmpty);
      expect(notifier.value.filteredCountries, isNotEmpty);
      expect(notifier.value.searchQuery, isEmpty);
    });
    test('priority countries match default priority codes', () {
      final codes = notifier.value.priorityCountries.map((c) => c.isoCode).toSet();
      for (final code in CountriesData.priorityCountryCodes) {
        expect(codes.contains(code), isTrue);
      }
    });
    test('filtered countries exclude priority countries', () {
      final priorityCodes = CountriesData.priorityCountryCodes.toSet();
      for (final c in notifier.value.filteredCountries) {
        expect(priorityCodes.contains(c.isoCode), isFalse);
      }
    });
    test('search by English name', () {
      notifier.search('egypt');
      expect(notifier.value.priorityCountries.any((c) => c.isoCode == 'EG'), isTrue);
    });
    test('search by Arabic name', () {
      notifier.search('مصر');
      expect(notifier.value.priorityCountries.any((c) => c.isoCode == 'EG'), isTrue);
    });
    test('search by dial code', () {
      notifier.search('+20');
      expect(notifier.value.priorityCountries.any((c) => c.isoCode == 'EG'), isTrue);
    });
    test('search by ISO code', () {
      notifier.search('EG');
      expect(notifier.value.priorityCountries.any((c) => c.isoCode == 'EG'), isTrue);
    });
    test('empty search resets', () {
      notifier.search('egypt');
      notifier.search('');
      expect(notifier.value.priorityCountries.length, CountriesData.priorityCountries.length);
    });
    test('clearSearch resets', () {
      notifier.search('xyz');
      notifier.clearSearch();
      expect(notifier.value.searchQuery, isEmpty);
    });
    test('no match returns empty', () {
      notifier.search('xyznonexistent');
      expect(notifier.value.priorityCountries, isEmpty);
      expect(notifier.value.filteredCountries, isEmpty);
    });
    test('custom countries list', () {
      final custom = CountriesData.all.take(5).toList();
      final n = CountryPickerNotifier(countries: custom);
      final total = n.value.priorityCountries.length + n.value.filteredCountries.length;
      expect(total, lessThanOrEqualTo(5));
      n.dispose();
    });
  });
}

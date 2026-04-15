import 'package:flutter_test/flutter_test.dart';
import 'package:customized_country_phone_picker/src/data/countries_data.dart';

void main() {
  group('CountriesData', () {
    test('all list is not empty', () => expect(CountriesData.all, isNotEmpty));
    test('all countries have non-empty required fields', () {
      for (final c in CountriesData.all) {
        expect(c.nameEn, isNotEmpty, reason: '${c.isoCode} missing nameEn');
        expect(c.nameAr, isNotEmpty, reason: '${c.isoCode} missing nameAr');
        expect(c.isoCode.length, 2, reason: '${c.nameEn} isoCode not 2 chars');
        expect(c.dialCode.startsWith('+'), isTrue, reason: '${c.nameEn} dialCode missing +');
        expect(c.flag, isNotEmpty, reason: '${c.nameEn} missing flag');
        expect(c.minLength, greaterThan(0), reason: '${c.nameEn} minLength <= 0');
        expect(c.maxLength, greaterThanOrEqualTo(c.minLength), reason: '${c.nameEn} maxLength < minLength');
      }
    });
    test('no duplicate ISO codes', () {
      final codes = CountriesData.all.map((c) => c.isoCode).toList();
      expect(codes.toSet().length, codes.length);
    });
    test('findByIsoCode returns Egypt for EG', () {
      final eg = CountriesData.findByIsoCode('EG');
      expect(eg, isNotNull);
      expect(eg!.nameEn, 'Egypt');
    });
    test('findByIsoCode returns null for unknown', () => expect(CountriesData.findByIsoCode('ZZ'), isNull));
    test('findByDialCode returns Egypt for +20', () {
      final eg = CountriesData.findByDialCode('+20');
      expect(eg, isNotNull);
      expect(eg!.isoCode, 'EG');
    });
    test('findByDialCode returns null for unknown', () => expect(CountriesData.findByDialCode('+99999'), isNull));
    test('defaultCountry is Egypt', () => expect(CountriesData.defaultCountry.isoCode, 'EG'));
    test('priorityCountries contains all priority codes', () {
      final isoCodes = CountriesData.priorityCountries.map((c) => c.isoCode).toSet();
      for (final code in CountriesData.priorityCountryCodes) {
        expect(isoCodes.contains(code), isTrue, reason: '$code not in priority list');
      }
    });
  });
}

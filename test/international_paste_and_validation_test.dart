import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CountriesData.countriesMatchingLeadingDigits', () {
    test('longest prefix wins for overlapping codes', () {
      final eg = CountriesData.countriesMatchingLeadingDigits('201001234567', CountriesData.all);
      expect(eg.length, 1);
      expect(eg.first.isoCode, 'EG');
    });

    test('returns empty when no prefix matches', () {
      expect(CountriesData.countriesMatchingLeadingDigits('999', CountriesData.all), isEmpty);
    });
  });

  group('PhoneValidation', () {
    test('strict fails implausible NSN for Egypt', () {
      final eg = CountriesData.findByIsoCode('EG')!;
      expect(
        PhoneValidation.validateNationalNumber(country: eg, nationalDigits: '0000000000', strict: true),
        PhoneValidationIssue.invalidNationalNumber,
      );
    });

    test('strict accepts plausible Egypt mobile', () {
      final eg = CountriesData.findByIsoCode('EG')!;
      expect(PhoneValidation.validateNationalNumber(country: eg, nationalDigits: '1001234567', strict: true), isNull);
    });
  });

  group('InternationalPasteFormatter', () {
    test('strips +20 and yields national digits', () {
      final fmt = InternationalPasteFormatter(
        countries: CountriesData.all,
        priorityIsoCodes: CountriesData.priorityCountryCodes,
        currentCountry: () => CountriesData.defaultCountry,
        policy: PasteAmbiguityPolicy.preferCurrentCountry,
        onCountryResolved: (_) {},
        enabled: true,
      );

      final out = fmt.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '+20 100 123 4567'),
      );

      expect(out.text, '1001234567');
    });
  });
}

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
    InternationalPasteFormatter formatter({required int maxLength}) {
      return InternationalPasteFormatter(
        countries: CountriesData.all,
        priorityIsoCodes: CountriesData.priorityCountryCodes,
        currentCountry: () => CountriesData.defaultCountry,
        maxLength: () => maxLength,
        policy: PasteAmbiguityPolicy.preferCurrentCountry,
        onCountryResolved: (_) {},
        enabled: true,
      );
    }

    test('strips +20 and yields national digits', () {
      final fmt = formatter(maxLength: 10);

      final out = fmt.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '+20 100 123 4567'),
      );

      expect(out.text, '1001234567');
    });

    test('truncates pasted national digits from the start when over max length', () {
      final fmt = formatter(maxLength: 10);

      final out = fmt.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '100123456789012'),
      );

      expect(out.text, '3456789012');
    });

    test('truncates international paste from the start when national part exceeds max length', () {
      final fmt = formatter(maxLength: 10);

      final out = fmt.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '+20 100 123 4567 8901'),
      );

      expect(out.text, '2345678901');
    });
  });
}

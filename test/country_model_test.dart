import 'package:flutter_test/flutter_test.dart';
import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';

void main() {
  const egypt = CountryModel(
    nameEn: 'Egypt', nameAr: 'مصر', isoCode: 'EG', dialCode: '+20',
    flag: '🇪🇬', minLength: 10, maxLength: 10, exampleNumber: '1001234567',
  );

  group('CountryModel', () {
    test('getName returns English for en locale', () => expect(egypt.getName('en'), 'Egypt'));
    test('getName returns Arabic for ar locale', () => expect(egypt.getName('ar'), 'مصر'));
    test('getName returns English for unknown locale', () => expect(egypt.getName('fr'), 'Egypt'));
    test('validateNationalDigitsIssue returns length issue', () {
      expect(egypt.validateNationalDigitsIssue(''), PhoneValidationIssue.empty);
      expect(egypt.validateNationalDigitsIssue('123'), PhoneValidationIssue.lengthOutOfRange);
      expect(egypt.validateNationalDigitsIssue('1001234567'), isNull);
    });
    test('validatePhoneNumber returns error for empty', () => expect(egypt.validatePhoneNumber(''), isNotNull));
    test('validatePhoneNumber returns error for too short', () => expect(egypt.validatePhoneNumber('123'), isNotNull));
    test('validatePhoneNumber returns error for too long', () => expect(egypt.validatePhoneNumber('12345678901'), isNotNull));
    test('getFullNumber prepends dial code', () => expect(egypt.getFullNumber('1001234567'), '+201001234567'));
    test('equality by isoCode', () {
      const same = CountryModel(nameEn: 'Different', nameAr: 'مختلف', isoCode: 'EG', dialCode: '+20', flag: '🇪🇬', minLength: 10, maxLength: 10);
      expect(egypt, equals(same));
    });
    test('different isoCode means not equal', () {
      const sa = CountryModel(nameEn: 'Saudi Arabia', nameAr: 'السعودية', isoCode: 'SA', dialCode: '+966', flag: '🇸🇦', minLength: 9, maxLength: 9);
      expect(egypt, isNot(equals(sa)));
    });
  });
}

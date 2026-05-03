import '../models/country_model.dart';

/// Provides access to the built-in list of countries and lookup helpers.
class CountriesData {
  CountriesData._();

  /// ISO codes for countries shown at the top of the picker by default.
  static const List<String> priorityCountryCodes = ['EG', 'SA', 'AE', 'KW', 'BH', 'OM', 'QA', 'JO', 'LB', 'IQ'];

  /// Finds a country by its ISO 3166-1 alpha-2 [code], or returns `null`.
  static CountryModel? findByIsoCode(String code) {
    for (final country in all) {
      if (country.isoCode == code) return country;
    }
    return null;
  }

  /// Finds a country by its [dialCode] (e.g. "+20"), or returns `null`.
  static CountryModel? findByDialCode(String dialCode) {
    for (final country in all) {
      if (country.dialCode == dialCode) return country;
    }
    return null;
  }

  /// Countries in [countries] whose calling code is the **longest** prefix of [allDigits]
  /// (digits only, no `+`). Used for paste-to-detect. Empty if no prefix matches.
  static List<CountryModel> countriesMatchingLeadingDigits(String allDigits, List<CountryModel> countries) {
    if (allDigits.isEmpty) return [];
    var bestLen = 0;
    final matches = <CountryModel>[];
    for (final c in countries) {
      final prefix = c.dialCode.replaceFirst('+', '');
      if (prefix.isEmpty || !allDigits.startsWith(prefix)) continue;
      if (prefix.length > bestLen) {
        bestLen = prefix.length;
        matches
          ..clear()
          ..add(c);
      } else if (prefix.length == bestLen) {
        matches.add(c);
      }
    }
    return matches;
  }

  /// Returns the list of priority countries defined by [priorityCountryCodes].
  static List<CountryModel> get priorityCountries {
    return priorityCountryCodes.map((code) => findByIsoCode(code)).whereType<CountryModel>().toList();
  }

  /// The default country (Egypt).
  static CountryModel get defaultCountry => findByIsoCode('EG')!;

  /// All supported countries.
  static const List<CountryModel> all = [
    // ── Priority Countries ──────────────────────────────────────────────────────────────────────────
    CountryModel(
      nameEn: 'Egypt',
      nameAr: 'مصر',
      isoCode: 'EG',
      dialCode: '+20',
      flag: '🇪🇬',
      minLength: 10,
      maxLength: 10,
      exampleNumber: '1001234567',
    ),
    CountryModel(
      nameEn: 'Saudi Arabia',
      nameAr: 'المملكة العربية السعودية',
      isoCode: 'SA',
      dialCode: '+966',
      flag: '🇸🇦',
      minLength: 9,
      maxLength: 9,
      exampleNumber: '512345678',
    ),
    CountryModel(
      nameEn: 'United Arab Emirates',
      nameAr: 'الإمارات العربية المتحدة',
      isoCode: 'AE',
      dialCode: '+971',
      flag: '🇦🇪',
      minLength: 9,
      maxLength: 9,
      exampleNumber: '501234567',
    ),
    CountryModel(
      nameEn: 'Kuwait',
      nameAr: 'الكويت',
      isoCode: 'KW',
      dialCode: '+965',
      flag: '🇰🇼',
      minLength: 8,
      maxLength: 8,
      exampleNumber: '50012345',
    ),
    CountryModel(
      nameEn: 'Bahrain',
      nameAr: 'البحرين',
      isoCode: 'BH',
      dialCode: '+973',
      flag: '🇧🇭',
      minLength: 8,
      maxLength: 8,
      exampleNumber: '36001234',
    ),
    CountryModel(
      nameEn: 'Oman',
      nameAr: 'عُمان',
      isoCode: 'OM',
      dialCode: '+968',
      flag: '🇴🇲',
      minLength: 8,
      maxLength: 8,
      exampleNumber: '92123456',
    ),
    CountryModel(
      nameEn: 'Qatar',
      nameAr: 'قطر',
      isoCode: 'QA',
      dialCode: '+974',
      flag: '🇶🇦',
      minLength: 8,
      maxLength: 8,
      exampleNumber: '33123456',
    ),
    CountryModel(
      nameEn: 'Jordan',
      nameAr: 'الأردن',
      isoCode: 'JO',
      dialCode: '+962',
      flag: '🇯🇴',
      minLength: 9,
      maxLength: 9,
      exampleNumber: '790123456',
    ),
    CountryModel(
      nameEn: 'Lebanon',
      nameAr: 'لبنان',
      isoCode: 'LB',
      dialCode: '+961',
      flag: '🇱🇧',
      minLength: 7,
      maxLength: 8,
      exampleNumber: '71123456',
    ),
    CountryModel(
      nameEn: 'Iraq',
      nameAr: 'العراق',
      isoCode: 'IQ',
      dialCode: '+964',
      flag: '🇮🇶',
      minLength: 10,
      maxLength: 10,
      exampleNumber: '7901234567',
    ),

    // ── Other Countries (alphabetical by English name) ──────────────────────────────────────────────
    CountryModel(nameEn: 'Afghanistan', nameAr: 'أفغانستان', isoCode: 'AF', dialCode: '+93', flag: '🇦🇫', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Albania', nameAr: 'ألبانيا', isoCode: 'AL', dialCode: '+355', flag: '🇦🇱', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Algeria', nameAr: 'الجزائر', isoCode: 'DZ', dialCode: '+213', flag: '🇩🇿', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Argentina', nameAr: 'الأرجنتين', isoCode: 'AR', dialCode: '+54', flag: '🇦🇷', minLength: 10, maxLength: 11),
    CountryModel(nameEn: 'Australia', nameAr: 'أستراليا', isoCode: 'AU', dialCode: '+61', flag: '🇦🇺', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Austria', nameAr: 'النمسا', isoCode: 'AT', dialCode: '+43', flag: '🇦🇹', minLength: 10, maxLength: 11),
    CountryModel(nameEn: 'Azerbaijan', nameAr: 'أذربيجان', isoCode: 'AZ', dialCode: '+994', flag: '🇦🇿', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Bangladesh', nameAr: 'بنغلاديش', isoCode: 'BD', dialCode: '+880', flag: '🇧🇩', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Belgium', nameAr: 'بلجيكا', isoCode: 'BE', dialCode: '+32', flag: '🇧🇪', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Bolivia', nameAr: 'بوليفيا', isoCode: 'BO', dialCode: '+591', flag: '🇧🇴', minLength: 8, maxLength: 8),
    CountryModel(nameEn: 'Brazil', nameAr: 'البرازيل', isoCode: 'BR', dialCode: '+55', flag: '🇧🇷', minLength: 10, maxLength: 11),
    CountryModel(nameEn: 'Bulgaria', nameAr: 'بلغاريا', isoCode: 'BG', dialCode: '+359', flag: '🇧🇬', minLength: 8, maxLength: 9),
    CountryModel(nameEn: 'Cambodia', nameAr: 'كمبوديا', isoCode: 'KH', dialCode: '+855', flag: '🇰🇭', minLength: 8, maxLength: 9),
    CountryModel(nameEn: 'Cameroon', nameAr: 'الكاميرون', isoCode: 'CM', dialCode: '+237', flag: '🇨🇲', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Canada', nameAr: 'كندا', isoCode: 'CA', dialCode: '+1', flag: '🇨🇦', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Chile', nameAr: 'تشيلي', isoCode: 'CL', dialCode: '+56', flag: '🇨🇱', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'China', nameAr: 'الصين', isoCode: 'CN', dialCode: '+86', flag: '🇨🇳', minLength: 11, maxLength: 11),
    CountryModel(nameEn: 'Colombia', nameAr: 'كولومبيا', isoCode: 'CO', dialCode: '+57', flag: '🇨🇴', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Croatia', nameAr: 'كرواتيا', isoCode: 'HR', dialCode: '+385', flag: '🇭🇷', minLength: 8, maxLength: 9),
    CountryModel(nameEn: 'Cuba', nameAr: 'كوبا', isoCode: 'CU', dialCode: '+53', flag: '🇨🇺', minLength: 8, maxLength: 8),
    CountryModel(nameEn: 'Cyprus', nameAr: 'قبرص', isoCode: 'CY', dialCode: '+357', flag: '🇨🇾', minLength: 8, maxLength: 8),
    CountryModel(
      nameEn: 'Czech Republic',
      nameAr: 'جمهورية التشيك',
      isoCode: 'CZ',
      dialCode: '+420',
      flag: '🇨🇿',
      minLength: 9,
      maxLength: 9,
    ),
    CountryModel(nameEn: 'Denmark', nameAr: 'الدنمارك', isoCode: 'DK', dialCode: '+45', flag: '🇩🇰', minLength: 8, maxLength: 8),
    CountryModel(nameEn: 'Ecuador', nameAr: 'الإكوادور', isoCode: 'EC', dialCode: '+593', flag: '🇪🇨', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Estonia', nameAr: 'إستونيا', isoCode: 'EE', dialCode: '+372', flag: '🇪🇪', minLength: 7, maxLength: 8),
    CountryModel(nameEn: 'Ethiopia', nameAr: 'إثيوبيا', isoCode: 'ET', dialCode: '+251', flag: '🇪🇹', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Finland', nameAr: 'فنلندا', isoCode: 'FI', dialCode: '+358', flag: '🇫🇮', minLength: 9, maxLength: 10),
    CountryModel(nameEn: 'France', nameAr: 'فرنسا', isoCode: 'FR', dialCode: '+33', flag: '🇫🇷', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Georgia', nameAr: 'جورجيا', isoCode: 'GE', dialCode: '+995', flag: '🇬🇪', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Germany', nameAr: 'ألمانيا', isoCode: 'DE', dialCode: '+49', flag: '🇩🇪', minLength: 10, maxLength: 11),
    CountryModel(nameEn: 'Ghana', nameAr: 'غانا', isoCode: 'GH', dialCode: '+233', flag: '🇬🇭', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Greece', nameAr: 'اليونان', isoCode: 'GR', dialCode: '+30', flag: '🇬🇷', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Hong Kong', nameAr: 'هونغ كونغ', isoCode: 'HK', dialCode: '+852', flag: '🇭🇰', minLength: 8, maxLength: 8),
    CountryModel(nameEn: 'Hungary', nameAr: 'المجر', isoCode: 'HU', dialCode: '+36', flag: '🇭🇺', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Iceland', nameAr: 'آيسلندا', isoCode: 'IS', dialCode: '+354', flag: '🇮🇸', minLength: 7, maxLength: 7),
    CountryModel(nameEn: 'India', nameAr: 'الهند', isoCode: 'IN', dialCode: '+91', flag: '🇮🇳', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Indonesia', nameAr: 'إندونيسيا', isoCode: 'ID', dialCode: '+62', flag: '🇮🇩', minLength: 10, maxLength: 12),
    CountryModel(nameEn: 'Iran', nameAr: 'إيران', isoCode: 'IR', dialCode: '+98', flag: '🇮🇷', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Ireland', nameAr: 'أيرلندا', isoCode: 'IE', dialCode: '+353', flag: '🇮🇪', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Italy', nameAr: 'إيطاليا', isoCode: 'IT', dialCode: '+39', flag: '🇮🇹', minLength: 9, maxLength: 10),
    CountryModel(nameEn: 'Japan', nameAr: 'اليابان', isoCode: 'JP', dialCode: '+81', flag: '🇯🇵', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Kazakhstan', nameAr: 'كازاخستان', isoCode: 'KZ', dialCode: '+7', flag: '🇰🇿', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Kenya', nameAr: 'كينيا', isoCode: 'KE', dialCode: '+254', flag: '🇰🇪', minLength: 9, maxLength: 10),
    CountryModel(
      nameEn: 'South Korea',
      nameAr: 'كوريا الجنوبية',
      isoCode: 'KR',
      dialCode: '+82',
      flag: '🇰🇷',
      minLength: 9,
      maxLength: 10,
    ),
    CountryModel(nameEn: 'Latvia', nameAr: 'لاتفيا', isoCode: 'LV', dialCode: '+371', flag: '🇱🇻', minLength: 8, maxLength: 8),
    CountryModel(nameEn: 'Libya', nameAr: 'ليبيا', isoCode: 'LY', dialCode: '+218', flag: '🇱🇾', minLength: 9, maxLength: 10),
    CountryModel(nameEn: 'Lithuania', nameAr: 'ليتوانيا', isoCode: 'LT', dialCode: '+370', flag: '🇱🇹', minLength: 8, maxLength: 8),
    CountryModel(nameEn: 'Malaysia', nameAr: 'ماليزيا', isoCode: 'MY', dialCode: '+60', flag: '🇲🇾', minLength: 9, maxLength: 10),
    CountryModel(nameEn: 'Mexico', nameAr: 'المكسيك', isoCode: 'MX', dialCode: '+52', flag: '🇲🇽', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Morocco', nameAr: 'المغرب', isoCode: 'MA', dialCode: '+212', flag: '🇲🇦', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Nepal', nameAr: 'نيبال', isoCode: 'NP', dialCode: '+977', flag: '🇳🇵', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Netherlands', nameAr: 'هولندا', isoCode: 'NL', dialCode: '+31', flag: '🇳🇱', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'New Zealand', nameAr: 'نيوزيلندا', isoCode: 'NZ', dialCode: '+64', flag: '🇳🇿', minLength: 9, maxLength: 10),
    CountryModel(nameEn: 'Nigeria', nameAr: 'نيجيريا', isoCode: 'NG', dialCode: '+234', flag: '🇳🇬', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Norway', nameAr: 'النرويج', isoCode: 'NO', dialCode: '+47', flag: '🇳🇴', minLength: 8, maxLength: 8),
    CountryModel(nameEn: 'Pakistan', nameAr: 'باكستان', isoCode: 'PK', dialCode: '+92', flag: '🇵🇰', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Palestine', nameAr: 'فلسطين', isoCode: 'PS', dialCode: '+970', flag: '🇵🇸', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Peru', nameAr: 'بيرو', isoCode: 'PE', dialCode: '+51', flag: '🇵🇪', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Philippines', nameAr: 'الفلبين', isoCode: 'PH', dialCode: '+63', flag: '🇵🇭', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Poland', nameAr: 'بولندا', isoCode: 'PL', dialCode: '+48', flag: '🇵🇱', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Portugal', nameAr: 'البرتغال', isoCode: 'PT', dialCode: '+351', flag: '🇵🇹', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Romania', nameAr: 'رومانيا', isoCode: 'RO', dialCode: '+40', flag: '🇷🇴', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Russia', nameAr: 'روسيا', isoCode: 'RU', dialCode: '+7', flag: '🇷🇺', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Serbia', nameAr: 'صربيا', isoCode: 'RS', dialCode: '+381', flag: '🇷🇸', minLength: 9, maxLength: 10),
    CountryModel(nameEn: 'Singapore', nameAr: 'سنغافورة', isoCode: 'SG', dialCode: '+65', flag: '🇸🇬', minLength: 8, maxLength: 8),
    CountryModel(nameEn: 'South Africa', nameAr: 'جنوب أفريقيا', isoCode: 'ZA', dialCode: '+27', flag: '🇿🇦', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Spain', nameAr: 'إسبانيا', isoCode: 'ES', dialCode: '+34', flag: '🇪🇸', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Sri Lanka', nameAr: 'سريلانكا', isoCode: 'LK', dialCode: '+94', flag: '🇱🇰', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Sudan', nameAr: 'السودان', isoCode: 'SD', dialCode: '+249', flag: '🇸🇩', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Sweden', nameAr: 'السويد', isoCode: 'SE', dialCode: '+46', flag: '🇸🇪', minLength: 9, maxLength: 10),
    CountryModel(nameEn: 'Switzerland', nameAr: 'سويسرا', isoCode: 'CH', dialCode: '+41', flag: '🇨🇭', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Syria', nameAr: 'سوريا', isoCode: 'SY', dialCode: '+963', flag: '🇸🇾', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Taiwan', nameAr: 'تايوان', isoCode: 'TW', dialCode: '+886', flag: '🇹🇼', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Thailand', nameAr: 'تايلاند', isoCode: 'TH', dialCode: '+66', flag: '🇹🇭', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Tunisia', nameAr: 'تونس', isoCode: 'TN', dialCode: '+216', flag: '🇹🇳', minLength: 8, maxLength: 8),
    CountryModel(nameEn: 'Turkey', nameAr: 'تركيا', isoCode: 'TR', dialCode: '+90', flag: '🇹🇷', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Ukraine', nameAr: 'أوكرانيا', isoCode: 'UA', dialCode: '+380', flag: '🇺🇦', minLength: 9, maxLength: 9),
    CountryModel(
      nameEn: 'United Kingdom',
      nameAr: 'المملكة المتحدة',
      isoCode: 'GB',
      dialCode: '+44',
      flag: '🇬🇧',
      minLength: 10,
      maxLength: 10,
    ),
    CountryModel(
      nameEn: 'United States',
      nameAr: 'الولايات المتحدة',
      isoCode: 'US',
      dialCode: '+1',
      flag: '🇺🇸',
      minLength: 10,
      maxLength: 10,
    ),
    CountryModel(nameEn: 'Venezuela', nameAr: 'فنزويلا', isoCode: 'VE', dialCode: '+58', flag: '🇻🇪', minLength: 10, maxLength: 10),
    CountryModel(nameEn: 'Vietnam', nameAr: 'فيتنام', isoCode: 'VN', dialCode: '+84', flag: '🇻🇳', minLength: 9, maxLength: 10),
    CountryModel(nameEn: 'Yemen', nameAr: 'اليمن', isoCode: 'YE', dialCode: '+967', flag: '🇾🇪', minLength: 9, maxLength: 9),
    CountryModel(nameEn: 'Zimbabwe', nameAr: 'زيمبابوي', isoCode: 'ZW', dialCode: '+263', flag: '🇿🇼', minLength: 9, maxLength: 9),
  ];
}

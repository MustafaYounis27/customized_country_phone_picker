/// A fully customizable Flutter phone input field with country picker,
/// bilingual country names (English & Arabic), phone number validation,
/// and three dial code display modes.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:customized_country_phone_picker/customized_country_phone_picker.dart';
///
/// CountryPhoneInput(
///   controller: phoneController,
///   onCountryChanged: (country) {
///     print('${country.dialCode} ${country.nameEn}');
///   },
/// )
/// ```
library;

export 'src/models/country_model.dart';
export 'src/data/countries_data.dart';
export 'src/theme/dial_code_display.dart';
export 'src/theme/country_box_decoration.dart';
export 'src/theme/phone_field_decoration.dart';
export 'src/theme/country_phone_picker_theme.dart';
export 'src/widgets/country_phone_input.dart';
export 'src/widgets/country_picker_bottom_sheet.dart';

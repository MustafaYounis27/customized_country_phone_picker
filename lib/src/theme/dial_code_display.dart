/// Controls where the country dial code is displayed.
enum DialCodeDisplay {
  /// Dial code shown as a prefix inside the text field (e.g. "+20 1001234567").
  inField,

  /// Dial code shown inside the country box next to the flag (e.g. "🇪🇬 +20 ▾").
  inBox,

  /// Dial code not visible anywhere — still tracked internally via [CountryModel].
  hidden,
}

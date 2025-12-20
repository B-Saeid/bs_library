import 'dart:ui';

import 'package:collection/collection.dart';

enum SupportedLocale {
  ar,
  en
  ;

  bool get isArabic => this == SupportedLocale.ar;

  bool get isEnglish => this == SupportedLocale.en;

  static SupportedLocale fromLocale(Locale locale) => SupportedLocale.values.firstWhere(
    (element) => element.name == locale.languageCode,
  );

  String get displayName => switch (this) {
    SupportedLocale.ar => 'العربية',
    SupportedLocale.en => 'English',
  };

  static SupportedLocale? fromName(String? name) => SupportedLocale.values.firstWhereOrNull(
    (element) => element.name == name,
  );

  TextDirection get textDirection => switch (this) {
    SupportedLocale.ar => TextDirection.rtl,
    SupportedLocale.en => TextDirection.ltr,
  };

  /// If rootApp widget locale is set to null and device locale is set to a locale not in this list
  /// The root app will take the first locale supported AFTER THE MAIN ONE IN DEVICE SETTINGS LIST
  /// and if can't find any IT WILL THEN TAKE THE first locale in THIS list.
  ///
  /// THe above talk is experienced on both iOS 17.4 and Android 10
  static final list = [
    Locale(SupportedLocale.en.name),
    Locale(SupportedLocale.ar.name),
  ];
}

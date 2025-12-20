import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n_resources.dart';
import 'l10n_service.dart';
import 'supported_locale.dart';

enum LocaleSetting {
  auto,
  arabic,
  english
  ;

  Locale? get locale => switch (this) {
    LocaleSetting.auto => L10nService.deviceLocale,
    LocaleSetting.arabic => Locale(SupportedLocale.ar.name),
    LocaleSetting.english => Locale(SupportedLocale.en.name),
  };

  bool get isArabic => this == LocaleSetting.arabic;

  bool get isEnglish => this == LocaleSetting.english;

  bool get isAuto => this == LocaleSetting.auto;

  static LocaleSetting fromStored(String? value) {
    return LocaleSetting.values.firstWhereOrNull((e) => value == e.name) ?? LocaleSetting.auto;
  }

  String displayName(WidgetRef ref) => l10nR.localeSettingDisplayName(this, ref);

  static LocaleSetting fromSupported(SupportedLocale supported) => switch (supported) {
    SupportedLocale.ar => LocaleSetting.arabic,
    SupportedLocale.en => LocaleSetting.english,
  };
}

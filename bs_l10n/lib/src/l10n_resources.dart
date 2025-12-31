import 'package:bs_utils/bs_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_setting.dart';
import 'supported_locale.dart';

L10nR l10nR = L10nR.instance;

class L10nR {
  L10nR._();

  static final instance = L10nR._();

  late SupportedLocale Function([WidgetRef? ref]) _currentLocale;

  SupportedLocale Function([WidgetRef? ref]) get currentLocale => _currentLocale;

  /// This method must be called prior to using this class.
  ///
  /// ex: `l10nR.setCurrentLocaleCallback(callback);`
  ///
  /// ```dart
  /// SupportedLocale callback([WidgetRef? ref]) {
  ///   SupportedLocale? locale;
  ///   final context = RoutesBase.activeContext;
  ///   if (ref != null) {
  ///     final settingsLocale = ref.watch(settingProvider.select((p) => p.locale));
  ///     locale = SupportedLocale.fromLocale(settingsLocale!);
  ///   } else if (context != null) {
  ///     final settingsLocale = context.read(settingProvider).locale;
  ///     locale = SupportedLocale.fromLocale(settingsLocale!);
  ///   }
  ///   return locale ?? SupportedLocale.ar; // or the other fallback value in `SupportedLocale`
  /// }
  /// ```
  ///
  /// The above example will watch for changes to app locale settings
  /// and update lively IF ref is passed. Otherwise it will get the current
  /// locale setting and return the proper string value without watching for
  /// changes, this can be used when no critical update is required like showing
  /// toasts and dialogs and other circumstances when it is never possible for
  /// the locale to change meanwhile.
  void setCurrentLocaleCallback(SupportedLocale Function([WidgetRef? ref]) currentLocale) =>
      _currentLocale = currentLocale;

  String localeSettingDisplayName(LocaleSetting setting, [WidgetRef? ref]) => switch (setting) {
    LocaleSetting.auto => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.en => 'Device Language',
      SupportedLocale.ar => 'لغة الجهاز',
    },
    _ => SupportedLocale.fromLocale(setting.locale!).displayName,
  };

  String tDiscardScreenShot([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Discard ScreenShot',
    SupportedLocale.ar => 'تجاهل لقطة الشاشة',
  };

  String tDiscardScreenShotMessage([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en =>
    'Closing the feedback view will discard your screenshot.'
        '\n\n Are you sure you want to close?',
    SupportedLocale.ar =>
    'سيتم تجاهل لقطة الشاشة عند الاغلاق. '
        '\n\nهل تريد الاغلاق؟',
  };

  String tCancel([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Cancel',
    SupportedLocale.ar => 'إنهاء',
  };
}

extension DevicePlatformName on DevicePlatform {
  String tDisplayName([WidgetRef? ref]) => switch (this) {
    DevicePlatform.android => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.en => 'android',
      SupportedLocale.ar => 'اندرويد',
    },
    DevicePlatform.fuchsia => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.ar => 'فيوشا',
      SupportedLocale.en => 'Fuchsia',
    },
    DevicePlatform.iOS => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.ar => 'ايفون',
      SupportedLocale.en => 'iOS',
    },
    DevicePlatform.linux => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.ar => 'لينوكس',
      SupportedLocale.en => 'Linux',
    },
    DevicePlatform.macOS => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.ar => 'ماك بوك',
      SupportedLocale.en => 'macOS',
    },
    DevicePlatform.windows => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.en => 'Windows',
      SupportedLocale.ar => 'ويندوز',
    },
    DevicePlatform.web => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.en => 'Web App',
      SupportedLocale.ar => 'تطبيق ويب',
    },
  };
}

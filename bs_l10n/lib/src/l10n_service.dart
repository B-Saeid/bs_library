import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'supported_locale.dart';

abstract final class L10nService {
  static const delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static final supportedLocales = SupportedLocale.list;

  static Locale? _deviceLocale;

  static bool _initialized = false;

  static Locale? get deviceLocale => _deviceLocale;

  static bool get localeNeedsInit => _deviceLocale == null;

  /// You can pass a function like this in `localeSettingSetter`
  /// ```
  /// void setCachedSettings(BuildContext context) {
  ///   final cachedSettings = HiveService.settings.get(SettingsKeys.localeSetting);
  ///   final userCachedLocale = LocaleSetting.fromStored(cachedSettings);
  ///
  ///   context.read(settingProvider.notifier).setLocaleSetting(userCachedLocale);
  /// }
  /// ```
  static void init(
    BuildContext context, {
    required ValueSetter<BuildContext> localeSettingSetter,
  }) {
    if (deviceLocale == null && !_initialized) _deviceLocale = Localizations.localeOf(context);

    _initialized = true;

    return localeSettingSetter(context);
  }

  // ///
  // /// Returns true if it is initialized for the first time
  // /// false if the call is redundant.
  // static bool init(
  //     BuildContext context, {
  //       required ValueSetter<BuildContext> localeSettingSetter,
  //     }) {
  //   final wasInitialized = _initialized;
  //   if (deviceLocale == null && !_initialized) _deviceLocale = Localizations.localeOf(context);
  //
  //   _initialized = true;
  //
  //   localeSettingSetter(context);
  //   return wasInitialized;
  // }
}

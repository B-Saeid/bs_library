import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_riverpod_utils/bs_riverpod_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../providers/setting_provider.dart';

abstract final class L10nHelper {
  static void _setLocaleSettings(BuildContext context) =>
      context.read(settingProvider.notifier).setLocaleSetting(LocaleSetting.auto);

  static SupportedLocale _currentLocaleCallback([WidgetRef? ref]) {
    SupportedLocale? locale;
    final context = MyApp.navigatorKey.currentContext;
    if (ref != null) {
      final settingsLocale = ref.watch(settingProvider.select((p) => p.locale));
      locale = SupportedLocale.fromLocale(settingsLocale!);
    } else if (context != null) {
      final settingsLocale = context.read(settingProvider).locale;
      locale = SupportedLocale.fromLocale(settingsLocale!);
    }
    return locale ?? SupportedLocale.en; // or the other fallback value in `SupportedLocale`
  }

  static void init(BuildContext context) {
    L10nService.init(context, localeSettingSetter: _setLocaleSettings);
    l10nR.setCurrentLocaleCallback(_currentLocaleCallback);
  }
}

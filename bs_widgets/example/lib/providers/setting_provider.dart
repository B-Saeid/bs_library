import 'package:bs_l10n/bs_l10n.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setting_provider.freezed.dart';
part 'setting_provider.g.dart';

@Riverpod(keepAlive: true)
class Setting extends _$Setting {
  @override
  SettingState build() => _init();

  SettingState _init() => SettingState._(
    localeSettings: LocaleSetting.auto,
    locale: LocaleSetting.auto.locale,
    themeMode: ThemeMode.system,
  );

  @override
  set state(SettingState newState) {
    if (newState == state) return;
    super.state = newState;
  }

  /// GENERAL SETTINGS

  /// Language
  void setLocaleSetting(LocaleSetting newSetting) {
    state = state.copyWith(localeSettings: newSetting, locale: newSetting.locale);

    // Intl.defaultLocale = newSetting.locale!.languageCode;
  }

  /// ThemeMode
  void setThemeMode(ThemeMode newMode) {
    state = state.copyWith(themeMode: newMode);
    // HiveService.settings.put(SettingsKeys.themeMode, newMode.name);
  }
}

@freezed
class SettingState with _$SettingState {
  const SettingState._({
    required this.localeSettings,
    required this.locale,
    required this.themeMode,
  });

  @override
  final LocaleSetting localeSettings;

  @override
  final Locale? locale;

  @override
  final ThemeMode themeMode;
}

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod_widgets/consumer_or_stateless.dart';
import '../theme/adaptive_tiles_theme.dart';
import '../theme/adaptive_tiles_theme_helper.dart';
import 'platforms/android_tile.dart';
import 'platforms/apple_tile.dart';
import 'platforms/other_tile.dart';

enum AdaptiveTileType {
  simpleTile,
  switchTile,
  navigationTile
  ;

  bool get isSimple => this == AdaptiveTileType.simpleTile;

  bool get isSwitch => this == AdaptiveTileType.switchTile;
}

class AdaptiveInheritedTile extends InheritedWidget {
  const AdaptiveInheritedTile({super.key, required super.child, this.description});

  final Widget? description;

  @override
  bool updateShouldNotify(covariant AdaptiveInheritedTile oldWidget) =>
      oldWidget.description != description;
}

class AdaptiveTile extends ConsumerOrStatelessWidget {
  const AdaptiveTile({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    this.loading = false,
    this.platform,
    this.themeData,
    this.lightTheme,
    this.darkTheme,
    this.brightness,
    super.key,
  }) : onToggle = null,
       on = null,
       activeSwitchColor = null,
       tileType = AdaptiveTileType.simpleTile;

  /// Sets the trailing to a chevron icon on all Platforms except for android.
  const AdaptiveTile.navigation({
    this.leading,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    this.loading = false,
    this.platform,
    this.themeData,
    this.lightTheme,
    this.darkTheme,
    this.brightness,
    super.key,
  }) : trailing = null,
       onToggle = null,
       on = null,
       activeSwitchColor = null,
       tileType = AdaptiveTileType.navigationTile;

  /// Sets the trailing to a Adaptive Switch.
  const AdaptiveTile.switchTile({
    required this.on,
    required this.onToggle,
    this.activeSwitchColor,
    this.leading,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    this.loading = false,
    this.platform,
    this.themeData,
    this.lightTheme,
    this.darkTheme,
    this.brightness,
    super.key,
  }) : trailing = null,
       tileType = AdaptiveTileType.switchTile;

  final Widget? leading;
  final Widget? trailing;
  final Widget title;
  final Widget? description;
  final VoidCallback? onPressed;
  final bool loading;

  final Color? activeSwitchColor;
  final Widget? value;
  final Function(bool value)? onToggle;
  final AdaptiveTileType tileType;
  final bool? on;
  final bool enabled;
  final DevicePlatform? platform;
  final AdaptiveTilesThemeData? themeData;
  final AdaptiveTilesThemeData? lightTheme;
  final AdaptiveTilesThemeData? darkTheme;
  final Brightness? brightness;

  DevicePlatform get _platform => platform ?? StaticData.platform;

  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    final lookedUpTheme = AdaptiveTilesTheme.of(context);

    final platform = lookedUpTheme?.platform ?? _platform;

    Widget child;
    if (platform.isApple) {
      child = AppleTile(
        description: description,
        onPressed: onPressed,
        onToggle: onToggle,
        tileType: tileType,
        value: value,
        leading: leading,
        title: title,
        trailing: trailing,
        enabled: loading ? false : enabled,
        activeSwitchColor: activeSwitchColor,
        loading: loading,
        initialValue: on ?? false,
      );
    } else if (platform.isAndroid) {
      child = AndroidTile(
        description: description,
        onPressed: onPressed,
        onToggle: onToggle,
        tileType: tileType,
        value: value,
        leading: leading,
        title: title,
        enabled: loading ? false : enabled,
        activeSwitchColor: activeSwitchColor,
        loading: loading,
        on: on,
        trailing: trailing,
      );
    } else {
      child = OtherTile(
        description: description,
        onPressed: onPressed,
        onToggle: onToggle,
        tileType: tileType,
        value: value,
        leading: leading,
        title: title,
        enabled: loading ? false : enabled,
        trailing: trailing,
        loading: loading,
        activeSwitchColor: activeSwitchColor,
        initialValue: on ?? false,
      );
    }

    child = AdaptiveInheritedTile(
      key: key,
      description: description,
      child: child,
    );

    /// If parent has already been wrapped in AdaptiveTilesTheme
    /// then just return the child, and these properties will be ignored
    /// platform, themeData, lightTheme, darkTheme and brightness.
    if (lookedUpTheme != null) return child;

    /// If parent has not been wrapped in AdaptiveTilesTheme
    return ConsumerOrStateless(
      builder: (BuildContext context, WidgetRef? ref, Widget? child) {
        final tilesThemeData =
            AdaptiveTilesThemeHelper.getThemeData(
              platform: platform,
              isLight: LiveDataOrQuery.isLight(ref: ref, context: context),
            ).merge(
              themeData ?? (brightness == Brightness.dark ? darkTheme : lightTheme),
            );

        return AdaptiveTilesTheme(
          themeData: tilesThemeData,
          platform: platform,
          child: child!,
        );
      },
      child: child,
    );
  }
}

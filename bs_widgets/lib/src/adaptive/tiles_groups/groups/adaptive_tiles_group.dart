import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod_widgets/consumer_or_stateless.dart';
import '../theme/adaptive_tiles_theme.dart';
import '../theme/adaptive_tiles_theme_helper.dart';
import '../tiles/abstract_tile.dart';
import 'abstract_group.dart';
import 'platforms/android_tiles_group.dart';
import 'platforms/apple_tiles_group.dart';
import 'platforms/other_tiles_group.dart';

export 'abstract_group.dart';

class AdaptiveTilesGroup extends AbstractTilesGroup {
  const AdaptiveTilesGroup({
    required this.tiles,
    this.margin,
    this.constraints,
    this.header,
    this.platform,
    this.themeData,
    this.lightTheme,
    this.darkTheme,
    this.brightness,
    super.key,
  });

  final List<AbstractTile> tiles;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final Widget? header;
  final DevicePlatform? platform;
  final AdaptiveTilesThemeData? themeData;
  final AdaptiveTilesThemeData? lightTheme;
  final AdaptiveTilesThemeData? darkTheme;
  final Brightness? brightness;

  DevicePlatform get _platform => platform ?? StaticData.platform;

  @override
  Widget build(BuildContext context) {
    final lookedUpTheme = AdaptiveTilesTheme.of(context);
    final platform = lookedUpTheme?.platform ?? _platform;

    final Widget child;
    if (platform.isApple) {
      child = AppleTilesGroup(header: header, tiles: tiles, margin: margin);
    } else if (platform.isAndroid) {
      child = AndroidTilesGroup(header: header, tiles: tiles, margin: margin);
    } else {
      child = OtherTilesGroup(header: header, tiles: tiles, margin: margin);
    }

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
            ).copyWith(constraints: constraints);

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

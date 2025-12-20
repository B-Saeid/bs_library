import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'groups/abstract_group.dart';
import 'theme/adaptive_tiles_theme.dart';
import 'theme/adaptive_tiles_theme_helper.dart';

class AdaptiveTilesList extends ConsumerWidget {
  const AdaptiveTilesList({
    required this.sections,
    this.shrinkWrap = false,
    this.physics,
    this.platform,
    this.themeData,
    this.lightTheme,
    this.darkTheme,
    this.brightness,
    this.contentPadding,
    super.key,
  });

  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final DevicePlatform? platform;
  final AdaptiveTilesThemeData? themeData;
  final AdaptiveTilesThemeData? lightTheme;
  final AdaptiveTilesThemeData? darkTheme;
  final Brightness? brightness;
  final EdgeInsetsGeometry? contentPadding;
  final List<AbstractTilesGroup> sections;

  DevicePlatform get _platform => platform ?? StaticData.platform;

  AdaptiveTilesThemeData settingsThemeData(WidgetRef ref) =>
      AdaptiveTilesThemeHelper.getThemeData(
        platform: _platform,
        isLight: LiveData.isLight(ref),
      ).merge(
        themeData ?? (brightness == Brightness.dark ? darkTheme : lightTheme),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Future(() => ref.watch(adaptiveTilesThemeProvider.notifier).setTheme(
    //       themeData: settingsThemeData(ref),
    //       platform: _platform,
    //     ));

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1024),
        child: AdaptiveTilesTheme(
          themeData: settingsThemeData(ref),
          platform: _platform,
          child: ListView.builder(
            physics: physics,
            shrinkWrap: shrinkWrap,
            itemCount: sections.length,
            padding: contentPadding,
            itemBuilder: (_, index) => sections[index],
          ),
        ),
      ),
    );
  }
}

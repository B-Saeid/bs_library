import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod_widgets/consumer_or_stateless.dart';
import 'groups/abstract_group.dart';
import 'theme/adaptive_tiles_theme.dart';
import 'theme/adaptive_tiles_theme_helper.dart';

class AdaptiveTilesList extends ConsumerOrStatelessWidget {
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
    this.constraints,
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
  final BoxConstraints? constraints;
  final List<AbstractTilesGroup> sections;

  DevicePlatform get _platform => platform ?? StaticData.platform;

  AdaptiveTilesThemeData settingsThemeData(BuildContext context, WidgetRef? ref) =>
      AdaptiveTilesThemeHelper.getThemeData(
            platform: _platform,
            isLight: LiveDataOrQuery.isLight(ref: ref, context: context),
          )
          .merge(
            themeData ?? (brightness == Brightness.dark ? darkTheme : lightTheme),
          )
          .copyWith(constraints: constraints);

  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    // Future(() => ref.watch(adaptiveTilesThemeProvider.notifier).setTheme(
    //       themeData: settingsThemeData(ref),
    //       platform: _platform,
    //     ));

    return AdaptiveTilesTheme(
      themeData: settingsThemeData(context, ref),
      platform: _platform,
      child: CustomScrollView(
        physics: physics,
        slivers: [
          shrinkWrap
              ? SliverList.list(
                  children: [
                    ...sections.map(
                      (e) => Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: contentPadding ?? EdgeInsets.zero,
                          child: e,
                        ),
                      ),
                    ),
                  ],
                )
              : SliverList.builder(
                  itemBuilder: (context, index) => Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: contentPadding ?? EdgeInsets.zero,
                      child: sections[index],
                    ),
                  ),
                  itemCount: sections.length,
                ),
        ],
      ),
    );
  }
}

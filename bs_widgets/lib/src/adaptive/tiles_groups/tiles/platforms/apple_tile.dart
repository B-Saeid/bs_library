import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../adaptive_tiles_groups.dart';
import '../../../../cupertino/cupertino_well.dart';
import '../../../../layout/fit_within.dart';
import '../../../neat_circular_indicator.dart';


class AppleTile extends ConsumerWidget {
  const AppleTile({
    required this.tileType,
    required this.leading,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.onToggle,
    required this.value,
    required this.initialValue,
    required this.activeSwitchColor,
    required this.enabled,
    required this.trailing,
    required this.loading,
    super.key,
  });

  final AdaptiveTileType tileType;
  final Widget? leading;
  final Widget title;
  final Widget? description;
  final VoidCallback? onPressed;
  final Function(bool value)? onToggle;
  final Widget? value;
  final bool loading;
  final bool? initialValue;
  final bool enabled;
  final Color? activeSwitchColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final themeData = ref.watch(adaptiveTilesThemeProvider).themeData;
    final themeData = AdaptiveTilesTheme.of(context)!.themeData;

    return IgnorePointer(
      ignoring: !enabled,
      child: buildContent(context: context, themeData: themeData, ref: ref),
    );
  }

  Widget buildContent({
    required BuildContext context,
    required WidgetRef ref,
    required AdaptiveTilesThemeData themeData,
  }) {
    final symmetricVerticalPadding = tileType.isSwitch
        ? 8.delayedScale(ref, startFrom: 1.1, beforeStart: 0)
        : 8.scalable(ref);
    // return ConstrainedBox(
    //   constraints: const BoxConstraints(minHeight: 44),
    //   child: CupertinoListTile(
    //     title: title,
    //     onTap: tileType != TileType.switchTile
    //         ? onPressed
    //         : /*() => onToggle!(!initialValue!)*/ null,
    //     trailing: trailing ??
    //         (tileType == TileType.switchTile
    //             ? buildSwitch(context: context, theme: theme)
    //             : tileType == TileType.navigationTile
    //                 ? const CupertinoListTileChevron()
    //                 : null),
    //     additionalInfo: tileType != TileType.switchTile ? value : null,
    //     // leading: leading,
    //     // leading: buildLeading(theme: theme, ref: ref),
    //     leading: leading,
    //     subtitle: description,
    //   ),
    // );
    return CupertinoWell(
      separated: false,
      color: AppStyle.colors.onScaffoldBackground(ref),
      // color: theme.themeData.tileColor,
      pressedColor: themeData.tileHighlightColor,
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: symmetricVerticalPadding,
          start: 12,
          bottom: symmetricVerticalPadding,
        ),
        child: Row(
          children: [
            if (leading != null) buildLeading(ref),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: leading != null ? 12 : 0,
                  end: 18,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: trailing == null && !tileType.isSimple ? 2.scalable(ref) : 0,
                        ),
                        child: value == null || tileType == AdaptiveTileType.switchTile
                            ? buildTitle(themeData)
                            : Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceBetween,
                                spacing: 5,
                                // runSpacing: 5,
                                children: [
                                  /// Title & Value
                                  buildTitle(themeData),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 5.0.scalable(ref),
                                    ),
                                    child: buildValue(
                                      ref: ref,
                                      themeData: themeData,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    if (onPressed != null && tileType == AdaptiveTileType.switchTile)
                      buildVerticalDivider(ref),
                    buildTrailing(context, ref),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLeading(WidgetRef ref) => FitWithin(
    size: Size.square(32.scalable(ref, maxFactor: 2)),
    alignment: AlignmentDirectional.center,
    child: IconTheme.merge(
      data: IconThemeData(
        // color: enabled ? null : theme.themeData.inactiveTitleColor,
        color: enabled ? null : LiveData.themeData(ref).disabledColor,
      ),
      child: leading!,
    ),
  );

  Widget buildTitle(AdaptiveTilesThemeData themeData) => DefaultTextStyle.merge(
    style: TextStyle(
      // color: enabled ? theme.themeData.settingsTileTextColor : theme.themeData.inactiveTitleColor,
      color: enabled ? null : themeData.inactiveTitleColor,
      fontSize: 16,
    ),
    child: title,
  );

  Widget buildValue({
    required WidgetRef ref,
    required AdaptiveTilesThemeData themeData,
  }) => DefaultTextStyle.merge(
    style: LiveData.textTheme(ref).bodyMedium!.copyWith(
      color: enabled ? themeData.trailingTextColor : themeData.inactiveTitleColor,
      fontSize: 17,
    ),
    child: value!,
  );

  Widget buildTrailing(BuildContext context, WidgetRef ref) {
    if (trailing != null) {
      return IconTheme.merge(
        data: IconThemeData(
          size: 24.scalable(ref, maxValue: 32, allowBelow: false),
          color: enabled ? null : LiveData.themeData(ref).disabledColor,
        ),
        child: trailing!,
      );
    }

    final scaleFactor = LiveData.scalePercentage(ref);
    return switch (tileType) {
      _ when loading => const NeatCircularIndicator(),
      AdaptiveTileType.simpleTile => const SizedBox(),
      AdaptiveTileType.switchTile => CupertinoSwitch(
        value: initialValue!,
        onChanged: enabled ? onToggle : null,
        activeTrackColor: enabled ? activeSwitchColor : LiveData.themeData(ref).disabledColor,
      ),
      AdaptiveTileType.navigationTile => Padding(
        padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
        child: Icon(
          color: enabled ? null : LiveData.themeData(ref).disabledColor,
          Directionality.of(context) == TextDirection.ltr
              ? CupertinoIcons.chevron_forward
              : CupertinoIcons.chevron_left,
          size: 18 * scaleFactor,
        ),
      ),
    };
  }

  Widget buildVerticalDivider(WidgetRef ref) => Container(
    width: 2,
    height: 26,
    margin: const EdgeInsetsDirectional.only(start: 3, end: 6),
    decoration: ShapeDecoration(
      shape: const StadiumBorder(),
      color: LiveData.themeData(ref).dividerColor,
    ),
  );
}

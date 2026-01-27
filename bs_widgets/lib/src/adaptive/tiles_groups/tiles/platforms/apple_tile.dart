import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ThemeData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../adaptive_tiles_groups.dart';
import '../../../../cupertino/cupertino_well.dart';
import '../../../../layout/fit_within.dart';
import '../../../../riverpod_widgets/consumer_or_stateless.dart';

class AppleTile extends ConsumerOrStatelessWidget {
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
  Widget build(BuildContext context, WidgetRef? ref) {
    // final themeData = ref.watch(adaptiveTilesThemeProvider).themeData;
    final themeData = AdaptiveTilesTheme.of(context)!.themeData;

    return IgnorePointer(
      ignoring: !enabled,
      child: buildContent(context: context, themeData: themeData, ref: ref),
    );
  }

  Widget buildContent({
    required BuildContext context,
    required WidgetRef? ref,
    required AdaptiveTilesThemeData themeData,
  }) => CupertinoWell(
    separated: false,
    color: AppStyle.colors.onScaffoldBackground(ref: ref, context: context),
    // color: theme.themeData.tileColor,
    pressedColor: themeData.tileHighlightColor,
    onPressed: onPressed,

    /// Main content of the tile
    child: Padding(
      padding: EdgeInsetsDirectional.only(
        top: 8.scalableFlexible(ref: ref, context: context),
        start: 12,
        end: 12,
        bottom: 8.scalableFlexible(ref: ref, context: context),
      ),
      child: Row(
        children: [
          /// Leading
          if (leading != null) buildLeading(context, ref),

          /// The rest of the tile
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: leading != null ? 12 : 0,
              ),
              child: Row(
                children: [
                  /// Wrap ( Title <Space> Value )
                  /// can be: Wrap ( Title
                  ///                Value )
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: 4.scalableFlexible(ref: ref, context: context),
                      ),
                      child: value == null
                          ? buildTitle(context, ref, themeData)
                          : Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 8.scalableFlexible(ref: ref, context: context, maxFactor: 2),
                              runSpacing: 4.scalableFlexible(
                                ref: ref,
                                context: context,
                                maxValue: 10,
                              ),
                              children: [
                                buildTitle(context, ref, themeData),
                                if (value != null) buildValue(context, ref, themeData),
                              ],
                            ),
                    ),
                  ),
                  if (trailing != null || !tileType.isSimple)
                    SizedBox(
                      width: 4.scalableFlexible(ref: ref, context: context),
                    ),

                  /// | Trailing
                  if (onPressed != null && tileType.isSwitch) buildVerticalDivider(context, ref),
                  if (trailing != null || !tileType.isSimple)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Visibility.maintain(
                          visible: !loading,
                          child: buildTrailing(context, ref, themeData),
                        ),
                        if (loading) const Positioned.fill(child: CupertinoActivityIndicator()),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  ThemeData _mainThemeData(BuildContext context, WidgetRef? ref) =>
      LiveDataOrQuery.themeData(ref: ref, context: context);

  Widget buildLeading(BuildContext context, WidgetRef? ref) => FitWithin(
    size: Size.square(24.scalableFlexible(ref: ref, context: context, maxFactor: 1.5)),
    alignment: AlignmentDirectional.center,
    child: IconTheme.merge(
      data: IconThemeData(
        // color: enabled ? null : theme.themeData.inactiveTitleColor,
        color: enabled ? null : _mainThemeData(context, ref).disabledColor,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: enabled ? null : _mainThemeData(context, ref).disabledColor,
        ),
        child: leading!,
      ),
    ),
  );

  Widget buildTitle(
    BuildContext context,
    WidgetRef? ref,
    AdaptiveTilesThemeData themeData,
  ) => IconTheme.merge(
    data: IconThemeData(
      // color: enabled ? null : theme.themeData.inactiveTitleColor,
      color: enabled ? null : _mainThemeData(context, ref).disabledColor,
    ),
    child: DefaultTextStyle.merge(
      style: TextStyle(
        // color: enabled ? theme.themeData.settingsTileTextColor : theme.themeData.inactiveTitleColor,
        color: enabled ? null : themeData.inactiveTitleColor,
        fontSize: 16,
      ),
      child: title,
    ),
  );

  Widget buildValue(
    BuildContext context,
    WidgetRef? ref,
    AdaptiveTilesThemeData themeData,
  ) => IconTheme.merge(
    data: IconThemeData(
      // color: enabled ? null : theme.themeData.inactiveTitleColor,
      color: enabled ? null : _mainThemeData(context, ref).disabledColor,
    ),
    child: DefaultTextStyle.merge(
      style: TextStyle(
        color: enabled ? themeData.trailingTextColor : themeData.inactiveTitleColor,
      ),
      child: value!,
    ),
  );

  Widget buildTrailing(
    BuildContext context,
    WidgetRef? ref,
    AdaptiveTilesThemeData themeData,
  ) => trailing != null
      ? DefaultTextStyle.merge(
          style: TextStyle(
            color: enabled ? themeData.trailingTextColor : themeData.inactiveTitleColor,
          ),
          child: IconTheme.merge(
            data: IconThemeData(
              size: 24.scalableFlexible(
                ref: ref,
                context: context,
                maxValue: 32,
                allowBelow: false,
              ),
              color: enabled ? null : _mainThemeData(context, ref).disabledColor,
            ),
            child: trailing!,
          ),
        )
      : switch (tileType) {
          AdaptiveTileType.simpleTile => const SizedBox(),
          AdaptiveTileType.switchTile =>
            /// This 29 hard-coded height is a harmless UNSEEN fix to limit the height
            /// of the CupertinoSwitch, as it was forcing the tile to be taller than usual
            SizedBox(
              height: 29,
              child: CupertinoSwitch(
                value: initialValue!,
                onChanged: enabled ? onToggle : null,
                activeTrackColor: enabled
                    ? activeSwitchColor
                    : _mainThemeData(context, ref).disabledColor,
              ),
            ),
          AdaptiveTileType.navigationTile => Icon(
            color: enabled ? null : _mainThemeData(context, ref).disabledColor,
            Directionality.of(context) == TextDirection.ltr
                ? CupertinoIcons.chevron_forward
                : CupertinoIcons.chevron_left,
            size: 18.scalableFlexible(ref: ref, context: context, maxValue: 28),
          ),
        };

  Widget buildVerticalDivider(BuildContext context, WidgetRef? ref) => Container(
    width: 2,
    height: 26,
    margin: const EdgeInsetsDirectional.only(start: 3, end: 6),
    decoration: ShapeDecoration(
      shape: const StadiumBorder(),
      color: enabled
          ? _mainThemeData(context, ref).dividerColor
          : _mainThemeData(context, ref).disabledColor,
    ),
  );
}

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

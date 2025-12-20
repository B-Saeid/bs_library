import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../neat_circular_indicator.dart';
import '../../theme/adaptive_tiles_theme.dart';
import '../adaptive_tile.dart';

class OtherTile extends ConsumerWidget {
  const OtherTile({
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
  final bool? initialValue;
  final bool enabled;
  final Widget? trailing;
  final bool loading;
  final Color? activeSwitchColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final themeData = ref.watch(adaptiveTilesThemeProvider).themeData;
    final themeData = AdaptiveTilesTheme.of(context)!.themeData;

    final cantShowAnimation = tileType == AdaptiveTileType.switchTile
        ? (onToggle == null && onPressed == null)
        : onPressed == null;

    final borderRadius = BorderRadius.circular(12);
    return IgnorePointer(
      ignoring: !enabled,
      child: Material(
        // color: AppStyle.colors.adaptivePrimary(ref).withAlpha(80),
        color: AppStyle.colors.onScaffoldBackground(ref),
        shape: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            width: 0.5,
            style: LiveData.isLight(ref) ? BorderStyle.solid : BorderStyle.none,
            color: Colors.grey,
          ),
        ),
        child: InkWell(
          borderRadius: borderRadius, // Card default border radius
          onTap: cantShowAnimation
              ? null
              : () {
                  if (tileType == AdaptiveTileType.switchTile) {
                    if (initialValue! && onPressed != null) return onPressed!();
                    onToggle?.call(!initialValue!);
                  } else {
                    onPressed?.call();
                  }
                },
          // highlightColor: themeData.tileHighlightColor,
          child: Row(
            children: [
              if (leading != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 24),
                  child: buildLeading(ref, themeData),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 15,
                    end: 10,
                    top: 19.scalable(ref, maxValue: 25),
                    bottom: 19.scalable(ref, maxValue: 25),
                  ),
                  // padding: EdgeInsetsDirectional.only(start: leading != null ? 12 : 0, end: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 5,
                          children: [
                            /// Title & Value
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTitle(ref),
                                if (description != null) buildDescription(themeData, ref),
                              ],
                            ),
                            if (value != null)
                              buildValue(
                                context: context,
                                themeData: themeData,
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 16,
                          end: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (onPressed != null && tileType == AdaptiveTileType.switchTile)
                              buildVerticalDivider(ref),
                            buildTrailing(context, ref),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLeading(WidgetRef ref, AdaptiveTilesThemeData themeData) => IconTheme.merge(
    data: LiveData.themeData(ref).iconTheme.copyWith(
      color: enabled ? themeData.leadingIconsColor : LiveData.themeData(ref).disabledColor,
    ),
    child: leading!,
  );

  Widget buildValue({
    required BuildContext context,
    required AdaptiveTilesThemeData themeData,
  }) => switch (tileType) {
    AdaptiveTileType.switchTile => const SizedBox(),
    _ => DefaultTextStyle.merge(
      style: TextStyle(
        color: enabled ? themeData.trailingTextColor : themeData.inactiveTitleColor,
        fontSize: 17,
      ),
      child: value!,
    ),
  };

  Widget buildVerticalDivider(WidgetRef ref) => Container(
    width: 2,
    height: 26,
    margin: const EdgeInsetsDirectional.only(start: 3, end: 6),
    decoration: ShapeDecoration(
      shape: const StadiumBorder(),
      color: LiveData.themeData(ref).dividerColor,
    ),
  );

  Padding buildDescription(AdaptiveTilesThemeData themeData, WidgetRef ref) => Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: DefaultTextStyle.merge(
      style: LiveData.textTheme(ref).bodyMedium!.copyWith(
        color: enabled ? themeData.tileDescriptionTextColor : LiveData.themeData(ref).disabledColor,
      ),
      child: description!,
    ),
  );

  Widget buildTitle(WidgetRef ref) => DefaultTextStyle.merge(
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: enabled ? null : LiveData.themeData(ref).disabledColor,
    ),
    child: title,
  );

  Widget buildTrailing(BuildContext context, WidgetRef ref) => trailing != null
      ? IconTheme.merge(
          data: IconThemeData(
            size: 32.scalable(ref, maxValue: 40, allowBelow: false),
            color: enabled ? null : LiveData.themeData(ref).disabledColor,
          ),
          child: trailing!,
        )
      : switch (tileType) {
          _ when loading => const NeatCircularIndicator(),
          AdaptiveTileType.simpleTile => const SizedBox(),
          AdaptiveTileType.switchTile => Switch.adaptive(
            value: initialValue!,
            onChanged: enabled ? onToggle : null,
            activeThumbColor: enabled ? activeSwitchColor : LiveData.themeData(ref).disabledColor,
          ),
          AdaptiveTileType.navigationTile => Icon(
            color: enabled ? null : LiveData.themeData(ref).disabledColor,
            Directionality.of(context) == TextDirection.ltr
                ? CupertinoIcons.chevron_forward
                : CupertinoIcons.chevron_left,
            size: 18.scalable(ref),
          ),
        };
}

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../riverpod_widgets/consumer_or_stateless.dart';
import '../../../adaptive_loading_indicator.dart';
import '../../theme/adaptive_tiles_theme.dart';
import '../adaptive_tile.dart';

class OtherTile extends ConsumerOrStatelessWidget {
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
  Widget build(BuildContext context, WidgetRef? ref) {
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
        color: AppStyle.colors.onScaffoldBackground(ref: ref, context: context),
        shape: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            width: 0.5,
            style: LiveDataOrQuery.isLight(ref: ref, context: context)
                ? BorderStyle.solid
                : BorderStyle.none,
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
          /// Main content of the tile
          child: Row(
            children: [
              /// Leading
              if (leading != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 24),
                  child: buildLeading(context, ref, themeData),
                ),

              /// The rest of the tile
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 20,
                    end: 25,
                    top: 20.scalableFlexible(ref: ref, context: context, maxValue: 25),
                    bottom: 20.scalableFlexible(ref: ref, context: context, maxValue: 25),
                  ),
                  // padding: EdgeInsetsDirectional.only(start: leading != null ? 12 : 0, end: 18),
                  child: Row(
                    spacing: 15.scalableFlexible(ref: ref, context: context),
                    children: [
                      /// Title & Description <<< Space >>> Value
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,

                          /// The <<< Space >>>
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 20.scalableFlexible(ref: ref, context: context, maxFactor: 2),
                          runSpacing: 10.scalableFlexible(ref: ref, context: context, maxFactor: 2),
                          children: [
                            /// Title & Description
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4.scalableFlexible(ref: ref, context: context, maxFactor: 2),
                              children: [
                                buildTitle(context, ref),
                                if (description != null) buildDescription(context, ref, themeData),
                              ],
                            ),

                            /// Value
                            if (value != null) buildValue(context, ref, themeData),
                          ],
                        ),
                      ),

                      /// | Trailing
                      if (trailing != null || !tileType.isSimple)
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onPressed != null && tileType.isSwitch)
                                buildVerticalDivider(context, ref),
                              if (trailing != null || !tileType.isSimple)
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Visibility.maintain(
                                      visible: !loading,
                                      child: buildTrailing(context, ref),
                                    ),
                                    if (loading)
                                      const Positioned.fill(
                                        child: AdaptiveLoadingIndicator(
                                          platform: DevicePlatform.windows,
                                        ),
                                      ),
                                  ],
                                ),
                            ],
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

  ThemeData _mainThemeData(BuildContext context, WidgetRef? ref) =>
      LiveDataOrQuery.themeData(ref: ref, context: context);

  Widget buildLeading(BuildContext context, WidgetRef? ref, AdaptiveTilesThemeData themeData) =>
      IconTheme.merge(
        data: IconThemeData(
          size: 32.scalableFlexible(ref: ref, context: context, maxValue: 35),
          color: enabled ? themeData.leadingIconsColor : _mainThemeData(context, ref).disabledColor,
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: enabled
                ? themeData.leadingIconsColor
                : _mainThemeData(context, ref).disabledColor,
          ),
          child: leading!,
        ),
      );

  Widget buildTitle(BuildContext context, WidgetRef? ref) => DefaultTextStyle.merge(
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: enabled ? null : _mainThemeData(context, ref).disabledColor,
    ),
    child: title,
  );

  Widget buildDescription(
    BuildContext context,
    WidgetRef? ref,
    AdaptiveTilesThemeData themeData,
  ) {
    final color = enabled
        ? themeData.tileDescriptionTextColor
        : _mainThemeData(context, ref).disabledColor;

    return IconTheme.merge(
      data: IconThemeData(color: color),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: color),
        child: description!,
      ),
    );
  }

  Widget buildValue(
    BuildContext context,
    WidgetRef? ref,
    AdaptiveTilesThemeData themeData,
  ) {
    final color = enabled
        ? themeData.trailingTextColor
        : _mainThemeData(context, ref).disabledColor;

    return IconTheme.merge(
      data: IconThemeData(color: color),
      child: DefaultTextStyle.merge(
        style: _mainThemeData(context, ref).textTheme.labelLarge?.copyWith(color: color),
        child: value!,
      ),
    );
  }

  Widget buildVerticalDivider(BuildContext context, WidgetRef? ref) => Container(
    width: 2,
    height: 26,
    margin: const EdgeInsetsDirectional.only(start: 3, end: 6),
    decoration: ShapeDecoration(
      shape: const StadiumBorder(),
      color: _mainThemeData(context, ref).dividerColor,
    ),
  );

  Widget buildTrailing(BuildContext context, WidgetRef? ref) => trailing != null
      ? DefaultTextStyle.merge(
          style: TextStyle(
            color: enabled ? null : _mainThemeData(context, ref).disabledColor,
          ),
          child: IconTheme.merge(
            data: IconThemeData(
              size: 24.scalableFlexible(ref: ref, context: context, maxValue: 35),
              color: enabled ? null : _mainThemeData(context, ref).disabledColor,
            ),
            child: trailing!,
          ),
        )
      : switch (tileType) {
          AdaptiveTileType.simpleTile => const SizedBox(),
          AdaptiveTileType.switchTile => Switch(
            value: initialValue!,
            onChanged: enabled ? onToggle : null,
            activeTrackColor: enabled
                ? activeSwitchColor
                : _mainThemeData(context, ref).disabledColor,
          ),
          AdaptiveTileType.navigationTile => Icon(
            color: enabled ? null : _mainThemeData(context, ref).disabledColor,
            Directionality.of(context) == TextDirection.ltr
                ? CupertinoIcons.chevron_forward
                : CupertinoIcons.chevron_left,
            size: 24.scalableFlexible(ref: ref, context: context, maxValue: 35),
          ),
        };
}

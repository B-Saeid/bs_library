import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../riverpod_widgets/consumer_or_stateless.dart';
import '../../../adaptive_loading_indicator.dart';
import '../adaptive_tile.dart';

class AndroidTile extends ConsumerOrStatelessWidget {
  const AndroidTile({
    required this.tileType,
    required this.leading,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.onToggle,
    required this.value,
    required this.on,
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
  final bool? on;
  final bool enabled;
  final Color? activeSwitchColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    // final theme = SettingsTheme.of(context);
    // final scaleFactor = LiveDataOrQuery.scalePercentage(ref);
    //
    // final cantShowAnimation = tileType == SettingsTileType.switchTile
    //     ? onToggle == null && onPressed == null
    //     : onPressed == null;

    // final old = IgnorePointer(
    //   ignoring: !enabled,
    //   child: Material(
    //     color: Colors.transparent,
    //     child: InkWell(
    //       onTap: cantShowAnimation
    //           ? null
    //           : () {
    //               if (tileType == SettingsTileType.switchTile) {
    //                 onToggle?.call(!initialValue);
    //               } else {
    //                 onPressed?.call(context);
    //               }
    //             },
    //       highlightColor: theme.themeData.tileHighlightColor,
    //       child: Row(
    //         children: [
    //           if (leading != null)
    //             Padding(
    //               padding: const EdgeInsetsDirectional.only(start: 24),
    //               child: IconTheme(
    //                 data: IconTheme.of(context).copyWith(
    //                   color: enabled
    //                       ? theme.themeData.leadingIconsColor
    //                       : theme.themeData.inactiveTitleColor,
    //                 ),
    //                 child: leading!,
    //               ),
    //             ),
    //           Expanded(
    //             child: Padding(
    //               padding: EdgeInsetsDirectional.only(
    //                 start: 24,
    //                 end: 24,
    //                 bottom: 19 * scaleFactor,
    //                 top: 19 * scaleFactor,
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   DefaultTextStyle(
    //                     style: TextStyle(
    //                       color: enabled
    //                           ? theme.themeData.settingsTileTextColor
    //                           : theme.themeData.inactiveTitleColor,
    //                       fontSize: 18,
    //                       fontWeight: FontWeight.w400,
    //                     ),
    //                     child: title ?? Container(),
    //                   ),
    //                   if (value != null)
    //                     Padding(
    //                       padding: const EdgeInsets.only(top: 4.0),
    //                       child: DefaultTextStyle(
    //                         style: TextStyle(
    //                           color: enabled
    //                               ? theme.themeData.tileDescriptionTextColor
    //                               : theme.themeData.inactiveSubtitleColor,
    //                         ),
    //                         child: value!,
    //                       ),
    //                     )
    //                   else if (description != null)
    //                     Padding(
    //                       padding: const EdgeInsets.only(top: 4.0),
    //                       child: DefaultTextStyle(
    //                         style: TextStyle(
    //                           color: enabled
    //                               ? theme.themeData.tileDescriptionTextColor
    //                               : theme.themeData.inactiveSubtitleColor,
    //                         ),
    //                         child: description!,
    //                       ),
    //                     ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           // if (tileType == SettingsTileType.switchTile)
    //           //   SizedBox(
    //           //     height: 30,
    //           //     child: VerticalDivider(),
    //           //   ),
    //           if (trailing != null)
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 16),
    //               child: trailing!,
    //             )
    //           else if (tileType == SettingsTileType.switchTile)
    //             Padding(
    //               padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
    //               child: Switch.adaptive(
    //                 value: initialValue,
    //                 onChanged: onToggle,
    //                 activeColor: enabled ? activeSwitchColor : theme.themeData.inactiveTitleColor,
    //               ),
    //             ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return IgnorePointer(
      ignoring: !enabled,
      child: buildListTile(context, ref),
    );
  }

  Widget buildListTile(BuildContext context, WidgetRef? ref) => ListTile(
    leading: leading,
    title: description != null || value != null
        ? Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            spacing: 15.scalableFlexible(ref: ref, context: context, maxValue: 30),
            runSpacing: 6.scalableFlexible(ref: ref, context: context, maxValue: 10),
            children: [
              /// Title & Description (Vertical Always)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2.scalableFlexible(ref: ref, context: context),
                children: [
                  title,
                  if (description != null)
                    DefaultTextStyle.merge(
                      style: _mainThemeData(context, ref).textTheme.bodyMedium?.copyWith(
                        color: enabled
                            ? _mainThemeData(context, ref).colorScheme.onSurfaceVariant
                            : _mainThemeData(context, ref).disabledColor,
                      ),
                      child: description!,
                    ),
                ],
              ),

              /// value will be places in subtitle if description is not null
              if (description != null && value != null) buildValue(context, ref),
            ],
          )
        : title,
    subtitle: description == null ? value : null,
    enabled: enabled,
    onTap: onPressed ?? (onToggle == null ? null : () => onToggle!(!on!)),
    trailing: trailing != null || tileType.isSwitch ? buildTrailing(context, ref) : null,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
  );

  Widget buildValue(BuildContext context, WidgetRef? ref) => DefaultTextStyle.merge(
    style: _mainThemeData(context, ref).textTheme.labelLarge?.copyWith(
      color: enabled ? null : _mainThemeData(context, ref).disabledColor,
    ),
    child: value!,
  );

  Widget buildTrailing(BuildContext context, WidgetRef? ref) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (onPressed != null && tileType.isSwitch) buildVerticalDivider(context, ref),
      Stack(
        alignment: Alignment.center,
        children: [
          Visibility.maintain(
            visible: !loading,
            child: trailing ?? Switch(value: on!, onChanged: enabled ? onToggle : null),
          ),
          if (loading)
            const Positioned.fill(
              child: AdaptiveLoadingIndicator(targetPlatform: TargetPlatform.android),
            ),
        ],
      ),
    ],
  );

  Widget buildVerticalDivider(BuildContext context, WidgetRef? ref) => Container(
    width: 1,
    height: 26,
    margin: const EdgeInsetsDirectional.only(start: 3, end: 6),
    decoration: ShapeDecoration(
      shape: const StadiumBorder(),
      color: enabled
          ? _mainThemeData(context, ref).dividerColor
          : _mainThemeData(context, ref).disabledColor,
    ),
  );

  ThemeData _mainThemeData(BuildContext context, WidgetRef? ref) =>
      LiveDataOrQuery.themeData(ref: ref, context: context);
}

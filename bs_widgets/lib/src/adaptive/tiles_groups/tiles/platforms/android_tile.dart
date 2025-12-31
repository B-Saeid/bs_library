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
      child: switch (tileType) {
        AdaptiveTileType.switchTile => buildSwitchTile(),
        _ => buildListTile(context, ref),
      },
    );
  }

  Widget buildListTile(BuildContext context, WidgetRef? ref) => ListTile(
    leading: leading,
    title: description != null && value != null
        ? Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            spacing: 5,
            // runSpacing: 5,
            children: [
              title,
              Padding(
                padding: EdgeInsets.only(
                  top: 5.0.scalableFlexible(ref: ref, context: context),
                ),
                child: buildValue(context, ref),
              ),
            ],
          )
        : title,
    subtitle: description ?? value,
    onTap: onPressed,
    enabled: enabled,
    trailing: loading ? const AdaptiveLoadingIndicator() : trailing,
  );

  Widget buildValue(BuildContext context, WidgetRef? ref) => DefaultTextStyle.merge(
    style: LiveDataOrQuery.textTheme(ref: ref, context: context).bodyMedium!.copyWith(),
    child: value!,
  );

  Widget buildSwitchTile() {
    final switchValue = on!;
    assert(trailing == null);
    return ListTile(
      leading: leading,
      enabled: enabled,
      title: title,
      trailing: loading
          ? const AdaptiveLoadingIndicator()
          : Switch(value: switchValue, onChanged: enabled ? onToggle : null),
      onTap: onPressed ?? () => onToggle?.call(!switchValue),
      subtitle: description,
    );
  }
}

import 'package:bs_widgets/adaptive_tiles_groups.dart';
import 'package:flutter/material.dart';

class TileInGroup extends AbstractTile {
  const TileInGroup({
    super.key,
    required this.data,
    required this.enabled,
    required this.trailingInStandard,
    this.on,
    this.onToggle,
    this.onPressed = false,
    this.isSwitch = false,
    this.isNavigation = false,
    this.loading = false,
    this.androidNavigationTileTip,
  }) : assert(!isSwitch || (on != null && onToggle != null));

  final (IconData?, String, String?, String?) data;
  final bool enabled;
  final IconData? trailingInStandard;
  final bool? on;
  final ValueSetter<bool>? onToggle;
  final bool onPressed;
  final bool isSwitch;
  final bool isNavigation;
  final bool loading;
  final String? androidNavigationTileTip;

  /// This is solely used on apple platforms to access
  /// description independently.
  @override
  Widget? get description => data.$3 != null ? Text(data.$3!) : null;

  @override
  Widget build(BuildContext context) {
    return isSwitch
        ? AdaptiveTile.switchTile(
            enabled: enabled,
            leading: data.$1 != null ? Icon(data.$1) : null,
            title: Text(data.$2),
            description: description,
            value: data.$4 != null ? Text(data.$4!) : null,
            onPressed: onPressed ? () {} : null,
            on: on,
            onToggle: onToggle,
            loading: loading,
          )
        : isNavigation
        ? Tooltip(
            message: androidNavigationTileTip ?? '',
            child: AdaptiveTile.navigation(
              enabled: enabled,
              leading: data.$1 != null ? Icon(data.$1) : null,
              title: Text(data.$2),
              description: description,
              value: data.$4 != null ? Text(data.$4!) : null,
              onPressed: onPressed ? () {} : null,
              loading: loading,
            ),
          )
        : AdaptiveTile(
            enabled: enabled,
            leading: data.$1 != null ? Icon(data.$1) : null,
            title: Text(data.$2),
            description: description,
            trailing: trailingInStandard != null ? Icon(trailingInStandard) : null,
            value: data.$4 != null ? Text(data.$4!) : null,
            onPressed: onPressed ? () {} : null,
            loading: loading,
          );
  }
}

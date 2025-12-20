import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'parts/android_list_tile.dart';
import 'parts/apple_list_tile.dart';
import 'parts/others_list_tile.dart';

class AdaptiveListTile extends ConsumerWidget {
  const AdaptiveListTile({
    super.key,
    this.platform,
    this.leading,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    this.trailing,
  });

  final Widget? leading;
  final Widget title;
  final Widget? description;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? trailing;

  @protected
  final DevicePlatform? platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) => switch (platform ?? StaticData.platform) {
    DevicePlatform.android => AndroidListTile(
      leading: leading,
      title: title,
      trailing: trailing,
      onPressed: onPressed,
      enabled: enabled,
      description: description,
    ),
    DevicePlatform.iOS || DevicePlatform.macOS => AppleListTile(
      leading: leading,
      title: title,
      trailing: trailing,
      onPressed: onPressed,
      enabled: enabled,
      description: description,
    ),
    _ => OthersListTile(
      leading: leading,
      title: title,
      trailing: trailing,
      onPressed: onPressed,
      enabled: enabled,
      description: description,
    ),
  };
}

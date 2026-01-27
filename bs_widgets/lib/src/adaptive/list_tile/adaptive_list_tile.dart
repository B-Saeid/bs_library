import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'parts/abstract_adaptive_list_tile.dart';
import 'parts/android_list_tile.dart';
import 'parts/apple_list_tile.dart';
import 'parts/others_list_tile.dart';

class AdaptiveListTile extends AbstractAdaptiveListTile {
  const AdaptiveListTile({
    super.key,
    super.leading,
    required super.title,
    super.description,
    super.enabled,
    super.onPressed,
    super.trailing,
    super.platform,
  });

  @override
  Widget build(BuildContext context, WidgetRef? ref) => switch (platform ?? StaticData.platform) {
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

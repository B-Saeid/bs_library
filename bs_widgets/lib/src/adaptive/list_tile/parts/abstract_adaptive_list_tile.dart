import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/material.dart';

import '../../../riverpod_widgets/consumer_or_stateless.dart';

abstract class AbstractAdaptiveListTile extends ConsumerOrStatelessWidget {
  const AbstractAdaptiveListTile({
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
}

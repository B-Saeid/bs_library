import 'package:flutter/widgets.dart';

import 'timer_refresh_widget.dart';

/// Refresh/rebuild the widget based on a [Duration]
class TimerRefresh extends TimerRefreshWidget {
  const TimerRefresh({
    super.key,
    this.child,
    required this.builder,
    super.refreshRate = null,
  });

  /// Optional `child`
  final Widget? child;

  /// The `builder` has access to the `child` if necessary and rebuilds.
  final TransitionBuilder builder;

  @override
  Widget build(BuildContext context) => builder.call(context, child);
}

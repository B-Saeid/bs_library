import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum BsGravity {
  top,
  centerLeft,
  center,
  centerRight,
  bottomSafe,
  // centerBottomPadded,
  snackBar
  ;

  bool get isBottomSafe => this == BsGravity.bottomSafe;

  bool get isSnackBar => this == BsGravity.snackBar;

  Widget positionedBuilder(Widget child) => switch (this) {
    BsGravity.top => Positioned(
      top: 100.0,
      left: 16.0,
      right: 16.0,
      child: child,
    ),
    BsGravity.center => Positioned(
      top: 50.0,
      bottom: 50.0,
      left: 16.0,
      right: 16.0,
      child: child,
    ),
    // BsGravity.centerBottomPadded => Positioned(
    //   bottom: 100.0,
    //   right: 50.0,
    //   left: 50.0,
    //   child: child,
    // ),
    BsGravity.centerRight => Positioned(
      top: 50.0,
      bottom: 50.0,
      right: 50.0,
      child: child,
    ),
    BsGravity.centerLeft => Positioned(
      top: 50.0,
      bottom: 50.0,
      left: 50.0,
      child: child,
    ),
    BsGravity.bottomSafe => Positioned(
      bottom: 50.0,
      left: 16.0,
      right: 16.0,
      child: child,
    ),
    BsGravity.snackBar => Positioned(
      bottom: 0,
      left: 16.0,
      right: 16.0,
      child: child,
    ),
  };
}

enum BsPriority {
  regular,
  ifEmpty,
  noRepeat,
  nowNoRepeat,
  now,
  replaceAll,

  /// Only used internally by [BsOverlay.show]
  @internal
  overall
  ;

  bool get isRegular => this == BsPriority.regular;

  bool get isIfEmpty => this == BsPriority.ifEmpty;

  bool get isNoRepeat => this == BsPriority.noRepeat;

  bool get isNow => this == BsPriority.now;

  bool get isReplaceAll => this == BsPriority.replaceAll;

  bool get isOverall => this == BsPriority.overall;
}

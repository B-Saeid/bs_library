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

    /// SHOWING OVERLAY BEHIND Keyboard BUG FIXED
    /// This was Copied from the orig package
    // Check for keyboard open
    //             /// If open will ignore the gravity bottom and change it to center
    //             if (gravity == ToastGravity.BOTTOM) {
    //           if (MediaQuery.of(context!).viewInsets.bottom != 0) {
    //             gravity = ToastGravity.CENTER;
    //           }
    //         }
    /// However sometimes it works and sometimes it does not
    /// and we already discussed the cause of this bug but to recap
    /// when MediaQuery.of(context) is called from some deeply nested widget
    /// especially in build methods with CONST widgets it may not
    /// register a callback to these build methods and that results in
    /// NOT reflecting current MediaQueryData values.
    ///
    /// So we use here our [LiveData] class - upgrade to sessionData using Riverpod -
    /// and we use the context of the root app to keep it updated
    /// so no chance In Sha' Allah for anything to go wrong.
    BsGravity.bottomSafe => Positioned(
      // this 50.0 is the default space used by the plugin when
      // [ToastGravity.BOTTOM] is used.
      bottom: /* This is handled in the widget /// LiveData.viewInsets(ref).bottom + */ 50.0,
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

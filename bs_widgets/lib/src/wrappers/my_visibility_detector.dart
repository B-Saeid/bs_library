import 'dart:async';

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';

enum ScrollType { horizontal, vertical }

/// A widget that checks every [checkInterval] for the visibility of a [child]
/// in a [Scrollable] that takes the entire body of a Scaffold with control over
/// whether or not to take `query`'s `viewPadding`, `viewInsets`
/// and [appBarHeight] into account.
///
class MyVisibilityDetector extends StatefulWidget {
  const MyVisibilityDetector({
    super.key,
    required this.child,
    required this.childKey,
    required this.visibilityCallback,
    required this.scrollType,
    this.percentage = 0.0,
    this.checkInterval = const Duration(milliseconds: 300),
    this.removeViewPaddings = true,
    this.removeViewInsets = true,
    this.removeAppbarHeight = true,
    this.appBarHeight = kToolbarHeight,
    this.visibleThreshold = Duration.zero,
    this.active = true,
  }) : assert(
         visibleThreshold == Duration.zero || visibleThreshold > checkInterval,
         'Since threshold is not Duration.zero and must be greater than checkInterval',
       );

  final Widget child;
  final GlobalKey childKey;

  /// Whether or not the widget is actively checking for visibility
  final bool active;

  /// The callback to be called when the visibility of the widget changes
  final void Function(bool visible) visibilityCallback;

  /// The interval at which to check the visibility of the widget
  final Duration checkInterval;

  /// The duration that the [child] must stay visible
  /// before it is considered visible.
  ///
  /// defaults to [Duration.zero] i.e. the [child] will
  /// immediately be marked as visible whenever it appears
  /// ,of course, with respect to [percentage].
  ///
  /// NOTE: If specified, i.e. not [Duration.zero] then
  /// it has to be greater than [checkInterval].
  final Duration visibleThreshold;

  /// The direction of the scrollable in which the widget is placed in.
  ///
  /// Note: If the widget is not in a scrollable
  /// then try using [StatefulWidget] instead.
  final ScrollType scrollType;

  /// The percentage of the widget size that should be visible
  /// in order to determine the [bool] in visibilityCallback.
  ///
  /// default to 0 i.e. when the first pixel of the widget is visible
  final double percentage;

  /// Set this to false if have a scrollable that is immersive
  /// i.e. takes the whole screen without taking viewPadding into account.
  ///
  /// default to true
  final bool removeViewPaddings;

  /// Set this to false if you do not want to take `viewInsets` into account
  /// e.g. if you want the [child] to be marked as visible when it appears
  /// behind the area of a virtual keyboard.
  ///
  /// default to true
  final bool removeViewInsets;

  /// Set this to true if you want to have an appBar in you screen
  /// that you do NOT want your widget to marked as visible if rendered below it.
  ///
  /// has no effect if [scrollType] is set to [ScrollType.horizontal]
  ///
  /// default to true
  final bool removeAppbarHeight;

  /// Set this Only if you have different appBar height
  /// than the default one [kToolbarHeight] which is 56.0 px
  ///
  /// has no effect if [removeAppbarHeight] is false
  /// or if [scrollType] is [ScrollType.horizontal]
  final double appBarHeight;

  @override
  State<MyVisibilityDetector> createState() => _MyVisibilityDetectorState();
}

class _MyVisibilityDetectorState extends State<MyVisibilityDetector> {
  Timer? timer;
  bool _cachedVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.active) _initMainTimer();
  }

  @override
  void didUpdateWidget(covariant MyVisibilityDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active != oldWidget.active) {
      widget.active ? _initMainTimer() : _releaseTimers();
    }
  }

  void _initMainTimer() {
    timer ??= Timer.periodic(widget.checkInterval, (_) => _checkVisibility());
  }

  @override
  void dispose() {
    _releaseTimers();
    super.dispose();
  }

  void _releaseTimers() {
    timer?.cancel();
    timer = null;
    _thresholdTimer?.cancel();
    _thresholdTimer = null;
  }

  Timer? _thresholdTimer;

  void _checkVisibility() {
    var visible = false;
    final box = widget.childKey.currentContext?.findRenderObject();

    if (box != null) {
      final hasSize = (box as RenderBox).hasSize;
      if (hasSize) {
        switch (widget.scrollType) {
          case ScrollType.horizontal:
            final xPosition = box.localToGlobal(Offset.zero).dx;
            final childWidth = box.size.width;
            visible = _horizontalCheck(xPosition, childWidth);

          case ScrollType.vertical:
            final yPosition = box.localToGlobal(Offset.zero).dy;
            final childHeight = box.size.height;
            visible = _verticalCheck(yPosition, childHeight);
        }
      }
    }

    if (visible != _cachedVisible && timer != null) {
      _cachedVisible = visible;
      if (widget.visibleThreshold == Duration.zero) {
        widget.visibilityCallback(visible);
      } else {
        if (!visible) {
          if (_thresholdTimer != null) {
            _thresholdTimer?.cancel();
            _thresholdTimer = null;
          } else {
            widget.visibilityCallback(false);
          }
        } else {
          // if (!notify) return;
          _thresholdTimer ??= Timer(widget.visibleThreshold, () {
            _checkVisibility();
            if (_thresholdTimer == null) return;
            if (_cachedVisible) widget.visibilityCallback(true);
            _thresholdTimer = null;
          });
        }
      }
    }
  }

  bool _verticalCheck(double yPosition, double childHeight) {
    var visible = false;
    final topPadding =
        (widget.removeViewPaddings ? StaticData.viewPadding.top : 0.0) +
        (widget.removeViewInsets ? StaticData.viewInsets.top : 0.0);
    final bottomPadding =
        (widget.removeViewPaddings ? StaticData.viewPadding.bottom : 0.0) +
        (widget.removeViewInsets ? StaticData.viewInsets.bottom : 0.0);
    final appBarHeight = widget.removeAppbarHeight ? widget.appBarHeight : 0.0;
    final yTop = topPadding + appBarHeight;
    final yBottom = StaticData.deviceHeight - bottomPadding;
    final yBoxTop = yPosition;
    final yBoxBottom = yPosition + childHeight;
    // final boxRect = Rect.fromPoints(
    //   Offset(0, yBoxTop),
    //   Offset(0, yBoxBottom),
    // );
    // final visibleRect = Rect.fromPoints(
    //   Offset(0, yTop),
    //   Offset(0, yBottom),
    // );
    //
    // final overlaps = boxRect.overlaps(visibleRect);
    // final intersect = boxRect.intersect(visibleRect);
    // print('overlaps $overlaps');
    // print('intersect $intersect');
    /// Is Totally above visible area
    if (yBoxBottom < yTop) {
      // print('Is Totally above visible area');
    }
    /// Is Totally below visible area
    else if (yBoxTop > yBottom) {
      // print('Is Totally below visible area');
    }
    /// Is approaching visible area from TOP
    else if (yBoxTop < yTop && yBoxBottom < yBottom) {
      // print('Is approaching visible area from TOP');
      final childPercentage = childHeight * widget.percentage;
      final desiredY = yBoxBottom - childPercentage;
      visible = desiredY > yTop;
    }
    /// Is leaving visible area to Below
    else if (yBoxTop < yBottom && yBoxBottom > yBottom) {
      // print('Is leaving visible area to Below');
      final childPercentage = childHeight * widget.percentage;
      final desiredY = yBoxTop + childPercentage;
      visible = desiredY < yBottom;
    }
    /// is fully visible
    else {
      // print('is fully visible');
      visible = true;
    }

    /// Is above the screen
    // if (yPosition.isNegative) {
    //   final desiredY = yPosition + (box.size.height - childPercentage);
    //   final topPadding = widget.removeViewPaddings ? StaticData.viewPadding.top : 0.0;
    //   final appBarHeight = widget.removeAppbarHeight ? widget.appBarHeight : 0.0;
    //   safeDeviceHeight = StaticData.deviceHeight + topPadding + appBarHeight;
    //   if (safeDeviceHeight - desiredY < safeDeviceHeight) visible = true;
    // } else {
    //   final desiredY = yPosition + childPercentage;
    //   final bottomPadding = widget.removeViewPaddings ? StaticData.viewPadding.bottom : 0.0;
    //   safeDeviceHeight = StaticData.deviceHeight - bottomPadding;
    //   if (desiredY < safeDeviceHeight) visible = true;
    //   // if (yPosition < deviceHeight - desiredY) visible = true;
    // }
    // if (safeDeviceHeight - yPosition < safeDeviceHeight) visible = true;

    return visible;
  }

  bool _horizontalCheck(double xPosition, double childWidth) {
    var visible = false;
    final rightPadding =
        (widget.removeViewPaddings ? StaticData.viewPadding.right : 0.0) +
        (widget.removeViewInsets ? StaticData.viewInsets.right : 0.0);
    final leftPadding =
        (widget.removeViewPaddings ? StaticData.viewPadding.left : 0.0) +
        (widget.removeViewInsets ? StaticData.viewInsets.left : 0.0);
    final xLeft = leftPadding;
    final xRight = StaticData.deviceWidth - rightPadding;
    final xBoxLeft = xLeft;
    final xBoxRight = xPosition + childWidth;
    // final xPosition = box.localToGlobal(Offset.zero).dx;
    // final desiredX = box.size.width * widget.percentage;
    // final deviceWidth = StaticData.deviceWidth -
    //     (widget.removeViewPaddings
    //         ? StaticData.viewPadding.left + StaticData.viewPadding.right
    //         : 0);
    // if (xPosition < deviceWidth - desiredX) visible = true;
    /// Is Totally before visible area
    if (xBoxRight < xLeft) {
      // print('Is Totally before visible area');
    }
    /// Is Totally After visible area
    else if (xBoxLeft > xRight) {
      // print('Is Totally After visible area');
    }
    /// Is approaching visible area from LEFT
    else if (xBoxLeft < xLeft && xBoxRight < xRight) {
      // print('Is approaching visible area from LEFT');
      final childPercentage = childWidth * widget.percentage;
      final desiredX = xBoxRight - childPercentage;
      visible = desiredX > xLeft;
    }
    /// Is leaving visible area to going Right
    else if (xBoxLeft < xRight && xBoxRight > xRight) {
      // print('Is leaving visible area to going Right');
      final childPercentage = childWidth * widget.percentage;
      final desiredX = xBoxLeft + childPercentage;
      visible = desiredX < xRight;
    }
    /// is fully visible
    else {
      // print('is fully visible');
      visible = true;
    }

    return visible;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

import 'dart:async';

import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/material.dart';


class CustomAnimatedSize extends StatelessWidget {
  const CustomAnimatedSize({
    super.key,
    required this.child,
    this.duration,
    this.appearDelay,
    this.origin,
    this.curve,
  });

  static Future<bool>? show = Future.value(true);

  final Widget child;

  /// defaults to 1 second
  final Duration? duration;

  /// Use this to delay the appearance of the widget
  final Duration? appearDelay;

  /// defaults to [Alignment.topCenter]
  final Alignment? origin;

  /// defaults to [Curves.easeInOutCubicEmphasized]
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    if (appearDelay == null) {
      return buildAnimatedSize(child);
    } else {
      return buildAnimatedSize(
        FutureBuilder(
          future: appearDelay!.delay,
          builder: (context, snapshot) =>
              !snapshot.connectionState.isDone ? const SizedBox() : child,
        ),
      );
    }
  }

  AnimatedSize buildAnimatedSize(Widget child) {
    return AnimatedSize(
      duration: duration ?? const Duration(seconds: 1),
      curve: curve ?? Curves.easeInOutCubicEmphasized,
      alignment: origin ?? Alignment.topCenter,
      child: child,
    );
  }
}

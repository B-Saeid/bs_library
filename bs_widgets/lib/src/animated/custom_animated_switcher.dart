import 'dart:async';

import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/material.dart';


class CustomAnimatedSwitcher extends StatelessWidget {
  const CustomAnimatedSwitcher({
    super.key,
    required this.child,
    this.scaleTransition = true,
    this.duration = const Duration(milliseconds: 500),
    this.inverseDuration = const Duration(milliseconds: 250),
    this.appearDelay,
  });

  static Future<bool>? show = Future.value(true);

  final Widget child;

  /// If false it will default to Fade Transition
  final bool scaleTransition;
  final Duration duration;
  final Duration inverseDuration;
  final Duration? appearDelay;

  @override
  Widget build(BuildContext context) => appearDelay == null
      ? buildAnimatedSwitcher(child)
      : buildAnimatedSwitcher(
          FutureBuilder(
            future: appearDelay!.delay,
            builder: (context, snapshot) =>
                !snapshot.connectionState.isDone ? const SizedBox() : child,
          ),
        );

  AnimatedSwitcher buildAnimatedSwitcher(Widget child) => AnimatedSwitcher(
    duration: duration,
    reverseDuration: inverseDuration,
    transitionBuilder: scaleTransition
        ? (child, animation) => ScaleTransition(scale: animation, child: child)
        : AnimatedSwitcher.defaultTransitionBuilder,
    switchInCurve: Curves.easeInOutCubicEmphasized,
    switchOutCurve: Curves.easeInOutCubic,
    child: child,
  );
}

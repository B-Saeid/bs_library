import 'dart:math';

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod_widgets/consumer_or_stateless.dart';

class BottomPadding extends ConsumerOrStatelessWidget {
  /// This widget is used to add padding to the bottom of the screen
  /// taking keyboard appearance into account
  const BottomPadding({
    super.key,
    this.kbPadding = 30,
    this.minPadding = 30,
    this.scalable = false,
  });

  /// The padding to add to the bottom of the screen
  /// when the keyboard **is shown**
  ///
  /// defaults to 30
  final double kbPadding;

  /// The padding to add to the bottom of the screen
  /// when the keyboard is **not shown**
  ///
  /// **IGNORED** if it is less than the `viewPadding.bottom` i.e. the bottom of safe area.
  ///
  /// defaults to 30
  final double minPadding;

  /// This indicates whether or not the padding is scalable
  /// according to accessibility textScale charges.
  ///
  /// defaults to false
  final bool scalable;

  static EdgeInsets asBottomEdgeInsets(
    BuildContext context,
    WidgetRef? ref, {
    double kbPadding = 30,
    double minPadding = 30,
    bool scalable = false,
  }) {
    final viewInsets = LiveDataOrQuery.viewInsets(ref: ref, context: context);
    final viewPadding = LiveDataOrQuery.viewPadding(ref: ref, context: context);
    final keyboardIsShown = viewInsets.bottom > 50;
    return EdgeInsets.only(
      bottom: keyboardIsShown
          ? scalable
                ? kbPadding.scalableFlexible(ref: ref, context: context)
                : kbPadding
          : scalable
          ? max(minPadding, viewPadding.bottom).scalableFlexible(ref: ref, context: context)
          : max(minPadding, viewPadding.bottom),
    );
  }

  static double asDouble(
    BuildContext context,
    WidgetRef? ref, {
    double kbPadding = 30,
    double minPadding = 30,
    bool scalable = false,
  }) {
    final viewInsets = LiveDataOrQuery.viewInsets(ref: ref, context: context);
    final viewPadding = LiveDataOrQuery.viewPadding(ref: ref, context: context);
    final keyboardIsShown = viewInsets.bottom > 50;
    return keyboardIsShown
        ? scalable
              ? kbPadding.scalableFlexible(ref: ref, context: context)
              : kbPadding
        : scalable
        ? max(minPadding, viewPadding.bottom).scalableFlexible(ref: ref, context: context)
        : max(minPadding, viewPadding.bottom);
  }

  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    final viewInsets = LiveDataOrQuery.viewInsets(ref: ref, context: context);
    final viewPadding = LiveDataOrQuery.viewPadding(ref: ref, context: context);
    final keyboardIsShown = viewInsets.bottom > 50;
    return SizedBox(
      height: keyboardIsShown
          ? scalable
                ? kbPadding.scalableFlexible(ref: ref, context: context)
                : kbPadding
          : scalable
          ? max(minPadding, viewPadding.bottom).scalableFlexible(ref: ref, context: context)
          : max(minPadding, viewPadding.bottom),
    );
  }
}

import 'dart:math';

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod_widgets/consumer_or_stateless.dart';

class CustomConstrainedWidget extends ConsumerOrStatelessWidget {
  const CustomConstrainedWidget({
    super.key,
    this.maxWidth,
    this.maxWidthFraction,
    this.maxHeight,
    this.maxHeightFraction,
    required this.child,
  });

  final double? maxWidth;
  final double? maxWidthFraction;
  final double? maxHeight;
  final double? maxHeightFraction;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    final effectiveMaxWidth = min(
      maxWidth ?? double.infinity,
      maxWidthFraction == null
          ? double.infinity
          : LiveDataOrQuery.deviceWidth(ref: ref, context: context) * maxWidthFraction!,
    );
    final effectiveMaxHeight = min(
      maxHeight ?? double.infinity,
      maxHeightFraction == null
          ? double.infinity
          : LiveDataOrQuery.deviceHeight(ref: ref, context: context) * maxHeightFraction!,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: effectiveMaxWidth,
        maxHeight: effectiveMaxHeight,
      ),
      child: child,
    );
  }
}

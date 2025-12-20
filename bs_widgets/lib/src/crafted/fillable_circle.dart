import 'package:flutter/material.dart';

import '../clippers/circle_slicer.dart';

class FillableCircle extends StatelessWidget {
  const FillableCircle({
    required this.child,
    this.fillColor,
    super.key,
    required this.progress,
    // this.progressDirection = ProgressDirection.downToUp,
  });

  /// Values from 0.0 to 1.0
  final double progress;

  /// Direction of the progress
  ///
  /// defaults to [ProgressDirection.downToUp]
  // final ProgressDirection progressDirection;

  /// defaults to app Primary Color
  final Color? fillColor;

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: ClipPath(
          clipper: CircleSlicer(
            progress: progress,
            // progressDirection: progressDirection,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fillColor ?? Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
      child,
    ],
  );
}

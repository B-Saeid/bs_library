import 'dart:math';

import 'package:flutter/rendering.dart';

/// Later on
// enum ProgressDirection {
//   upToDown,
//   downToUp,
//   leftToRight,
//   rightToLeft,
// }

class CircleSlicer extends CustomClipper<Path> {
  const CircleSlicer({
    required this.progress,
    // this.progressDirection = ProgressDirection.downToUp,
  });

  final double progress;
  // final ProgressDirection progressDirection;

  @override
  Path getClip(Size size) {
    final d = size.width;
    final r = d / 2;
    assert(size.width == size.height, 'Width is not equal to height');

    final path = Path()..fillType = PathFillType.evenOdd;

    final y = d * (1 - progress);
    path.moveTo(r, y);

    /// When the angle is == 360º i.e. y == 0, the below arcToPoint is no-op.
    if (y == 0) {
      path.addOval(Rect.fromCircle(center: Offset(r, r), radius: r));
      return path;
    }

    final opposite = y - r; // العمود المرسوم من المركز على  الوتر
    final theta = asin(opposite / r);
    final halfLength = opposite / tan(theta);
    path.lineTo(r - halfLength, y);
    path.arcToPoint(
      Offset(r + halfLength, y),
      radius: Radius.circular(r),
      clockwise: false,
      largeArc: true,
    );
    path.close(); // Same as: path.lineTo(r, y);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

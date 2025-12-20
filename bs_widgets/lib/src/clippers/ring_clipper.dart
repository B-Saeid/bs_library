import 'package:flutter/rendering.dart';

class RingClipper extends CustomClipper<Path> {
  const RingClipper({required this.ringWidth});

  final double ringWidth;

  @override
  Path getClip(Size size) {
    final outerRadius = size.width / 2;
    assert(size.width == size.height, 'Width is not equal to height');

    final path = Path()..fillType = PathFillType.evenOdd;

    path.addOval(
      Rect.fromCircle(
        center: Offset(outerRadius, outerRadius),
        radius: outerRadius,
      ),
    );
    path.addOval(
      Rect.fromCircle(
        center: Offset(outerRadius, outerRadius),
        radius: outerRadius - ringWidth,
      ),
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

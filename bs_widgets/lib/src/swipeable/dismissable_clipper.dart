import 'package:flutter/material.dart';

class DismissibleClipper extends CustomClipper<Rect> {
  DismissibleClipper({required this.axis, required this.moveAnimation})
    : super(reclip: moveAnimation);

  final Axis axis;
  final Animation<Offset> moveAnimation;

  @override
  Rect getClip(Size size) {
    switch (axis) {
      case Axis.horizontal:
        final offset = moveAnimation.value.dx * size.width;
        if (offset < 0) {
          return Rect.fromLTRB(size.width + offset, 0.0, size.width, size.height);
        }
        return Rect.fromLTRB(0.0, 0.0, offset, size.height);
      case Axis.vertical:
        final offset = moveAnimation.value.dy * size.height;
        if (offset < 0) {
          return Rect.fromLTRB(0.0, size.height + offset, size.width, size.height);
        }
        return Rect.fromLTRB(0.0, 0.0, size.width, offset);
    }
  }

  @override
  Rect getApproximateClipRect(Size size) => getClip(size);

  @override
  bool shouldReclip(DismissibleClipper oldClipper) {
    return oldClipper.axis != axis || oldClipper.moveAnimation.value != moveAnimation.value;
  }
}

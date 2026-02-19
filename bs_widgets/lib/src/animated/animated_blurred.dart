import 'dart:ui';

import 'package:flutter/material.dart';

/// Cloning from AnimatedOpacity
// class AnimatedBlurred extends ImplicitlyAnimatedWidget {
//   const AnimatedBlurred({
//     super.key,
//     super.duration = const Duration(milliseconds: 600),
//     super.curve = Curves.fastOutSlowIn,
//     super.onEnd,
//     this.blur = 0.0,
//     required this.child,
//   });
//
//   final double blur;
//   final Widget child;
//
//   @override
//   ImplicitlyAnimatedWidgetState<AnimatedBlurred> createState() => _AnimatedBlurredState();
// }
//
// class _AnimatedBlurredState extends ImplicitlyAnimatedWidgetState<AnimatedBlurred> {
//   Tween<double>? _blurTween;
//   late Animation<double> _blurAnimation;
//
//   @override
//   Widget build(BuildContext context) => AnimatedBuilder(
//     animation: _blurAnimation,
//     builder: (context, child) => ImageFiltered(
//       imageFilter: ImageFilter.blur(
//         sigmaX: _blurAnimation.value,
//         sigmaY: _blurAnimation.value,
//       ),
//       child: widget.child,
//     ),
//   );
//
//   @override
//   void forEachTween(TweenVisitor<dynamic> visitor) {
//     _blurTween =
//         visitor(
//               _blurTween,
//               widget.blur,
//               (dynamic value) => Tween<double>(begin: value as double),
//             )
//             as Tween<double>?;
//   }
//
//   @override
//   void didUpdateTweens() => _blurAnimation = animation.drive(_blurTween!);
// }
/// After Understanding the concept of ImplicitlyAnimatedWidgetState
class AnimatedBlurred extends StatefulWidget {
  const AnimatedBlurred({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.fastOutSlowIn,
    this.blur = 0.0,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double blur;

  @override
  State<AnimatedBlurred> createState() => _AnimatedBlurredState();
}

class _AnimatedBlurredState extends State<AnimatedBlurred> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> _tweenAnimation;

  late Tween<double> _tween;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );


    _tween = Tween<double>(begin: 0.0, end: widget.blur);
    // ----------------
    _tweenAnimation = _tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );
    // Same as above
    // _tweenAnimation = CurvedAnimation(
    //   parent: controller,
    //   curve: widget.curve,
    // ).drive(_tween);
    // ----------------

    animate();
  }

  @override
  void didUpdateWidget(covariant AnimatedBlurred oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.blur == widget.blur) return;

    _tween = Tween<double>(begin: oldWidget.blur, end: widget.blur);
    _tweenAnimation = _tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );
    animate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void animate() => controller.forward(from: 0);

  @override
  Widget build(BuildContext context) =>
      AnimatedBuilder(
        animation: _tweenAnimation,
        builder: (BuildContext context, Widget? child) =>
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _tweenAnimation.value,
                sigmaY: _tweenAnimation.value,
              ),
              child: child!,
            ),
        child: widget.child,
      );

/// You can use this without the overhead of the StatefulWidget, AnimatedBuilder,
/// AnimationController but It does not over control over the animation
/// it just animates when It is build ... may reanimate on every build
// @override
// Widget build(BuildContext context) => TweenAnimationBuilder(
//       tween: _tween,
//       duration: widget.duration ?? 3.seconds,
//       curve: widget.curve ?? Curves.easeInOutCubicEmphasized,
//       builder: (BuildContext context, double value, Widget? child) => ImageFiltered(
//         imageFilter: ImageFilter.blur(
//           sigmaX: value,
//           sigmaY: value,
//         ),
//         child: child!,
//       ),
//       child: widget.child,
//     );
}

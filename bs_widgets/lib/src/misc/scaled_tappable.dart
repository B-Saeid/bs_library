import 'package:flutter/material.dart';

class ScaledTappable extends StatefulWidget {
  const ScaledTappable({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  State<ScaledTappable> createState() => _ScaledTappableState();
}

class _ScaledTappableState extends State<ScaledTappable> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastEaseInToSlowEaseOut,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.6,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  bool tapped = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTapDown: (_) {
        setState(() => tapped = true);
        _controller.reverse();
      },
      onTapUp: (_) {
        if (tapped) widget.onPressed();
        _controller.forward();
        setState(() => tapped = false);
      },
      onTapCancel: () {
        _controller.forward();
        setState(() => tapped = false);
      },
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    ),
  );
}

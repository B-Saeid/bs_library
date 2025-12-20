import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/material.dart';

import '../riverpod_widgets/ref_widget.dart';

class CupertinoWell extends StatefulWidget {
  const CupertinoWell({
    super.key,
    this.width,
    this.height,
    this.onPressed,
    required this.child,
    this.pressedColor,
    this.color,
    this.borderRadius,
    this.margin,
    this.padding,
    this.separated = true,
    this.constraints,
    this.shadowed = false,
    this.alignment,
  });

  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final Widget child;
  final Color? pressedColor;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool separated;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final bool shadowed;

  @override
  State<CupertinoWell> createState() => _CupertinoWellState();
}

class _CupertinoWellState extends State<CupertinoWell> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: widget.onPressed == null
        ? null
        : () {
            setIsPressed(true);
            widget.onPressed!.call();
            100.milliseconds.delay.then((_) => setIsPressed(false));
          },
    onTapDown: (_) => widget.onPressed == null ? null : setIsPressed(true),
    onTapUp: (_) => widget.onPressed == null ? null : setIsPressed(false),
    onTapCancel: () => widget.onPressed == null ? null : setIsPressed(false),
    child: RefWidget(
      (ref) => AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        padding: widget.padding,
        constraints: widget.constraints ?? const BoxConstraints(minHeight: 44),
        decoration: BoxDecoration(
          border: widget.separated
              ? Border.all(
                  width: 0.5,
                  style: LiveData.isLight(ref) ? BorderStyle.solid : BorderStyle.none,
                  color: Colors.grey,
                )
              : null,
          borderRadius: widget.borderRadius,
          boxShadow: widget.shadowed ? [const BoxShadow(blurRadius: 2)] : null,
          color: isPressed
              ? widget.pressedColor ??
                    widget.color?.darken(by: 0.2) ??
                    LiveData.themeData(ref).highlightColor
              : widget.color,
        ),
        alignment: widget.alignment,
        child: widget.child,
      ),
    ),
  );

  void setIsPressed(bool isPressed) {
    if (mounted) {
      setState(() => this.isPressed = isPressed);
    }
  }
}

import 'package:flutter/cupertino.dart';

class CupertinoCard extends StatelessWidget {
  /// Creates an iOS-style rounded rectangle popup surface.
  const CupertinoCard({
    super.key,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.alignment,
    required this.child,
  });

  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final Color? color;
  final Color? borderColor;
  final Widget child;

  static const BorderRadius _defaultBorderRadius = BorderRadius.all(Radius.circular(13));

  static const Color _kDialogColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xCCEDE2E2),
    darkColor: Color(0xCC2D2D2D),
  );

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsetsDirectional.symmetric(vertical: 4.0, horizontal: 8.0),
    margin: margin,
    alignment: alignment,
    decoration: ShapeDecoration(
      shape: RoundedSuperellipseBorder(
        borderRadius: borderRadius ?? _defaultBorderRadius,
        side: borderColor == null ? BorderSide.none : BorderSide(color: borderColor!),
      ),
      color: color ?? CupertinoDynamicColor.resolve(_kDialogColor, context),
    ),
    child: child,
  );
}

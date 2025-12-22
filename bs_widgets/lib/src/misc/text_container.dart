import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adaptive/adaptive_tappable.dart';

class TextContainer extends ConsumerWidget {
  const TextContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.animated = false,
    this.onTap,
    this.textAlign,
    this.alignment,
    this.padding,
    this.margin,
    this.borderRadius,
    this.forceTappable = false,
  });

  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool animated;
  final VoidCallback? onTap;
  final TextAlign? textAlign;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  /// This is used to force returning the tappable widget
  /// even if [onTap] is null
  final bool forceTappable;

  EdgeInsetsGeometry get getPadding =>
      padding ?? const EdgeInsets.symmetric(vertical: 6, horizontal: 10);

  BorderRadius get getBorderRadius => borderRadius ?? BorderRadius.circular(12);

  EdgeInsetsGeometry get getMargin => margin ?? const EdgeInsets.symmetric(horizontal: 8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultColor = color ?? AppStyle.colors.adaptiveGrey(ref: ref, context: context);
    final container = animated
        ? AnimatedContainer(
            width: width,
            height: height,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
            margin: getMargin,
            alignment: alignment,
            padding: getPadding,
            decoration: BoxDecoration(
              borderRadius: getBorderRadius,
              // boxShadow: onTap == null ? null : [BoxShadow(color: Colors.black, blurRadius: 2)],
              color: defaultColor,
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
              child: child,
            ),
          )
        : Container(
            width: width,
            height: height,
            margin: getMargin,
            padding: getPadding,
            alignment: alignment,
            decoration: BoxDecoration(
              borderRadius: getBorderRadius,
              // boxShadow: onTap == null ? null : [BoxShadow(color: Colors.black, blurRadius: 2)],
              color: defaultColor,
            ),
            child: DefaultTextStyle.merge(
              textAlign: textAlign ?? TextAlign.center,
              child: child,
            ),
          );
    return onTap != null || forceTappable
        ? AdaptiveTappable(
            animated: animated,
            width: width,
            height: height,
            color: color,
            onTap: onTap,
            borderRadius: getBorderRadius,
            padding: getPadding,
            margin: getMargin,
            alignment: alignment,
            textAlign: textAlign,
            child: child,
          )
        : container;
  }
}

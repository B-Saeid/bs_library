import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../animated/custom_animated_size.dart';
import '../cupertino/cupertino_well.dart';
import '../riverpod_widgets/consumer_or_stateless.dart';

class AdaptiveTappable extends ConsumerOrStatelessWidget {
  const AdaptiveTappable({
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

  EdgeInsetsGeometry get getMargin => margin ?? const EdgeInsets.symmetric(horizontal: 8);

  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    late final Widget widget;

    if (StaticData.platform.isApple) {
      // final defaultColor = color ?? AppStyle.colors.adaptiveIPrimary(ref);
      final colorScheme = LiveDataOrQuery.themeData(ref: ref, context: context).colorScheme;
      final defaultColor =
          color ??
          (LiveDataOrQuery.isLight(ref: ref, context: context)
              ? colorScheme.primaryFixedDim
              : colorScheme.secondaryContainer);
      final cupertinoWell = CupertinoWell(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        width: width,
        height: height,
        onPressed: onTap,
        alignment: alignment,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        constraints: const BoxConstraints(),
        margin: getMargin,
        color: defaultColor,
        pressedColor: Color.alphaBlend(
          AppStyle.colors.whiteLightBlackDark(ref: ref, context: context).withAlpha(120),
          defaultColor,
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: colorScheme.onPrimaryContainer),
          textAlign: textAlign ?? TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: child,
        ),
      );

      widget = cupertinoWell;
    } else {
      final actionChip = Container(
        padding: getMargin,
        width: width,
        height: height,
        alignment: alignment,
        child: FittedBox(
          child: ActionChip.elevated(
            onPressed: onTap,
            label: DefaultTextStyle.merge(
              textAlign: textAlign ?? TextAlign.center,
              child: child,
            ),
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    side: ChipTheme.of(context).shape?.side ?? BorderSide.none,
                    borderRadius: borderRadius!,
                  ),
            padding: padding,
            backgroundColor: color,
          ),
        ),
      );

      widget = actionChip;
    }

    return animated ? CustomAnimatedSize(child: widget) : widget;
  }
}

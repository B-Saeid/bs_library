import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RingProgress extends ConsumerWidget {
  const RingProgress({
    super.key,
    this.size,
    this.progress,
    this.stroke = 4.0,
    this.activeColor,
    this.backgroundColor,
    this.progressAnimation,
    this.progressColorAnimation,
    this.displayPercent = false,
    // this.localizedPercent = true,
    this.percentageWrapper,
    this.percentFill = false,
    this.child,
  });

  /// Determines the size of the widget
  /// defaults to 48.scalable(ref, maxValue: 60)
  final double? size;

  /// Used to display percentage of progress inside the widget
  final bool displayPercent;

  // /// Used to determine if the percentage text should be localized
  // ///
  // /// has no effect if [displayPercent] is false
  // ///
  // /// defaults to true
  // final bool localizedPercent;
  /// Used to format the percentage text
  /// the percentage will be passed as an integer from 0 to 100
  /// either percentageWrapper is null or not, '%' will be added to the end.
  final String Function(int)? percentageWrapper;

  /// Used to determine if the percentage text should fill
  /// the inside of the progress indicator
  final bool percentFill;

  /// default to 4.0
  final double stroke;

  /// Values from 0 to 1
  final double? progress;

  /// default to app primary color
  final Color? activeColor;

  /// default to activeColor with [shade900] and [withAlpha] of 100
  final Color? backgroundColor;

  /// A widget to be placed within the progress indicator
  /// Should not be used along side with [displayPercent]
  /// defaults to null
  final Widget? child;

  /// TODO: Implement these
  final Animation<double>? progressAnimation;
  final Animation<Color>? progressColorAnimation;

  Color _color(WidgetRef ref) => activeColor ?? LiveData.themeData(ref).colorScheme.primary;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox.square(
    dimension: size ?? 48.scalable(ref, maxValue: 60),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: CircularProgressIndicator(
            color: _color(ref),
            value: progress,
            backgroundColor: backgroundColor ?? _color(ref).withAlpha(80),
            strokeCap: StrokeCap.round,
            valueColor: progressColorAnimation,
            strokeWidth: stroke,
          ),
        ),
        if (displayPercent)
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(stroke + 2),
              child: FittedBox(
                fit: percentFill ? BoxFit.contain : BoxFit.scaleDown,
                child: Text(
                  // '${localizedPercent ? L10nR.tNumString((progress! * 100).ceil()) : (progress! * 100).ceil().toString()}%',
                  '$getPercentage%',
                  style: LiveData.textTheme(ref).labelLarge,
                ),
              ),
            ),
          ),
        if (child != null) Positioned.fill(child: child!),
      ],
    ),
  );

  String get getPercentage {
    final percentage = (progress! * 100).ceil();
    return percentageWrapper?.call(percentage) ?? percentage.toString();
  }
}

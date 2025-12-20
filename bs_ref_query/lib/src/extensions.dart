part of 'session_data.dart';

extension LiveScaledValue on num {
  /// a method that returns the scaled value of a number based on the current scale factor
  /// It uses the riverpod [WidgetRef] to get a more reliable scale factor than a [BuildContext].
  ///
  /// {@template scalable}
  /// `maxValue` is the maximum value of the scaled value above which scaling is no longer applied.
  ///
  /// `maxFactor` is the maximum scaling factor above which scaling is no longer applied.
  /// {@endtemplate}
  ///
  /// {@template allowBelow}
  /// `allowBelow` is a flag that indicates whether scaling is allowed below the base value
  /// that only occurs when scale factor is less than `1.0`.
  /// {@endtemplate}
  ///
  /// see also: [delayedScale] if you need delayed scaling.
  double scalable(
    WidgetRef ref, {
    bool allowBelow = true,
    double? maxValue,
    double? maxFactor,
  }) {
    assert(
      (maxValue ?? double.infinity) > this,
      'maxValue $maxValue must be greater than $this',
    );
    return LiveData._getScaledValue(
      ref,
      baseValue: toDouble(),
      allowBelow: allowBelow,
      maxFactor: maxFactor,
      maxValue: maxValue,
    );
  }

  /// a method that returns a delayed scaled value of a number based on the current scale factor
  /// It uses the riverpod [WidgetRef] to get a more reliable scale factor than a [BuildContext].
  ///
  /// `startFrom` is the scaling factor at which the scaling starts.
  ///
  /// if `beforeStart` is null then the baseValue -the value you are calling this method on-
  /// will be returned until scaling factor reaches the `startFrom` value.
  ///
  /// {@macro scalable}
  ///
  /// see also: [scalable] for standard scaling.
  double delayedScale(
    WidgetRef ref, {
    required double startFrom,
    bool allowBelow = true,
    double? beforeStart,
    double? maxValue,
    double? maxFactor,
  }) {
    _safetyAssertion(startFrom, maxValue, maxFactor);
    return LiveData._getScaledValue(
      ref,
      startFrom: startFrom,
      beforeStart: beforeStart,
      baseValue: toDouble(),
      maxFactor: maxFactor,
      maxValue: maxValue,
      allowBelow: allowBelow,
    );
  }

  void _safetyAssertion(
    double startFrom,
    double? maxValue,
    double? maxPercentage,
  ) {
    assert(
      startFrom.isFinite && !startFrom.isNegative,
      'startFrom must be finite and non-negative',
    );
    // assert(
    //   (maxValue ?? double.infinity) >= this * startFrom,
    //   'maxValue $maxValue must be greater than ${this * startFrom}',
    // );
    assert(
      (maxPercentage ?? double.infinity) > startFrom && !startFrom.isNegative,
      'maxPercentage $maxPercentage must be greater than $startFrom',
    );
  }
}

extension LiveStringSize on String {
  TextPainter _getPainter(
    TextStyle style, {
    bool ltr = true,
    BuildContext? context,
    WidgetRef? ref,
    bool followScale = true,
    bool allowBelow = true,
    double? maxValue,
    double? maxFactor,
  }) {
    assert(style.fontSize != null, 'style.fontSize must not be null');

    final double fontSize;

    if (!followScale) {
      fontSize = style.fontSize!;
    } else {
      final double scaledFontSize;
      if (ref != null) {
        scaledFontSize = style.fontSize!.scalable(
          ref,
          allowBelow: allowBelow,
          maxValue: maxValue,
          maxFactor: maxFactor,
        );
      } else {
        final scaleFactor = 16 / MediaQuery.textScalerOf(context!).scale(16);
        scaledFontSize = LiveData.applyScaleLogic(
          scaleFactor,
          baseValue: style.fontSize!,
          allowBelow: allowBelow,
          maxValue: maxValue,
          maxFactor: maxFactor,
        );
      }

      fontSize = scaledFontSize;
    }

    final textSpan = TextSpan(
      text: this,
      style: style.copyWith(fontSize: fontSize),
    );
    final tp =
        TextPainter(
            text: textSpan,
            textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
          )
          // The text and textDirection properties must be non-null before this is called.
          ..layout();

    return tp;
  }

  /// Obtains the size of the text for the given [style].
  ///
  /// {@template ScaleAndFollowScale}
  /// `followScale` is a flag that indicates whether scaling is to be applied.
  /// defaults to true.
  ///
  /// if `followScale` is true then you have to either pass [ref] or [context] **NOT BOTH**
  /// in order to lively follow the scale factor. [ref] is more preferable than [context].
  ///
  // Not included when mentioning {@macro ScaleAndFollowScale}
  // Find a way to make it work later.
  // /// {@macro scalable}
  // ///
  // /// {@macro allowBelow}
  /// if `followScale` is false then all of
  /// `ref`, `context`, `maxValue`, `maxFactor` and  `allowBelow`
  /// will be ignored.
  /// {@endtemplate}
  ///
  /// {@macro scalable}
  ///
  /// {@macro allowBelow}
  Size getSize(
    TextStyle style, {
    bool ltr = true,
    BuildContext? context,
    WidgetRef? ref,
    bool followScale = true,
    bool allowBelow = true,
    double? maxValue,
    double? maxFactor,
  }) {
    assert(
      (!followScale || (ref == null) ^ (context == null)),
      'When followScale is true, Only one of ref and context must be passed, '
      '${context == null && ref == null ? 'neither was passed' : 'NOT BOTH'}.',
    );
    return _getPainter(
      style,
      ltr: ltr,
      ref: ref,
      context: context,
      followScale: followScale,
      allowBelow: allowBelow,
      maxValue: maxValue,
      maxFactor: maxFactor,
    ).size;
  }

  /// Obtains the width of the text for the given [style].
  ///
  /// {@macro ScaleAndFollowScale}
  ///
  /// {@macro scalable}
  ///
  /// {@macro allowBelow}
  ///
  /// see also: [getHeight] to obtain the height.
  /// see also: [getSize] to obtain the width and height.
  double getWidth(
    TextStyle style, {
    bool ltr = true,
    BuildContext? context,
    WidgetRef? ref,
    bool followScale = true,
    bool allowBelow = true,
    double? maxValue,
    double? maxFactor,
  }) => getSize(
    style,
    ltr: ltr,
    context: context,
    ref: ref,
    followScale: followScale,
    allowBelow: allowBelow,
    maxValue: maxValue,
    maxFactor: maxFactor,
  ).width;

  /// Obtains the height of the text for the given [style].
  ///
  /// {@macro ScaleAndFollowScale}
  ///
  /// {@macro scalable}
  ///
  /// {@macro allowBelow}
  ///
  /// see also: [getWidth] to obtain the width.
  /// see also: [getSize] to obtain the width and height.
  double getHeight(
    TextStyle style, {
    bool ltr = true,
    BuildContext? context,
    WidgetRef? ref,
    bool followScale = true,
    bool allowBelow = true,
    double? maxValue,
    double? maxFactor,
  }) => getSize(
    style,
    ltr: ltr,
    context: context,
    ref: ref,
    followScale: followScale,
    allowBelow: allowBelow,
    maxValue: maxValue,
    maxFactor: maxFactor,
  ).height;
}

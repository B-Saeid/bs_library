part of 'session_data.dart';

extension LiveScaledValue on num {
  /// {@template flexible_scale}
  /// A flexible method that returns the scaled value of a number
  /// based on the current textScale factor.
  ///
  /// It uses [LiveData.scalePercentage] if `ref` is passed and if not available
  /// while `context` is passed it fallbacks to using `MediaQuery.textScalerOf(context)`.
  ///
  /// ###### Be aware:
  /// If neither is passed it uses [StaticData], which needs [LiveData] to be at least initialized.
  /// Otherwise make sure you pass either `ref` or `context`.
  /// {@endtemplate}
  ///
  /// {@template scalable}
  ///   - `maxValue` is the maximum value of the scaled value above which scaling is no longer applied.
  ///   - `maxFactor` is the maximum scaling factor above which scaling is no longer applied.
  ///   - `allowBelow` is a flag that indicates whether scaling is allowed below the base value
  ///      that only occurs when scale factor is less than `1.0`.
  /// {@endtemplate}
  ///
  /// see also: [delayedScaleFlexible] if you need delayed scaling.
  double scalableFlexible({
    WidgetRef? ref,
    BuildContext? context,
    bool allowBelow = true,
    double? maxValue,
    double? maxFactor,
  }) {
    assert(
      (maxValue ?? double.infinity) > this,
      'maxValue $maxValue must be greater than $this',
    );

    final scaleFactor = LiveDataOrQuery.scalePercentage(ref: ref, context: context);
    return LiveData.applyScaleLogic(
      scaleFactor,
      baseValue: toDouble(),
      allowBelow: allowBelow,
      maxFactor: maxFactor,
      maxValue: maxValue,
    );
  }

  /// {@template ref_scale}
  /// A method that returns the scaled value of a number based on the current textScale factor
  /// It uses the riverpod [WidgetRef] to get a more reliable scale factor than a [BuildContext].
  /// {@endtemplate}
  ///
  /// {@macro scalable}
  /// see also: [delayedScaleFlexible] if you need delayed scaling.
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
    final scaleFactor = LiveData.scalePercentage(ref);
    return LiveData.applyScaleLogic(
      scaleFactor,
      baseValue: toDouble(),
      allowBelow: allowBelow,
      maxFactor: maxFactor,
      maxValue: maxValue,
    );
  }

  /// {@macro flexible_scale}
  /// {@template delayed_scale}
  ///   - `startFrom` is the scaling factor at which the scaling starts.
  ///
  ///   - if `beforeStart` is null then the baseValue -the value you are calling this method on-
  ///     will be returned until scaling factor reaches the `startFrom` value.
  /// {@endtemplate}
  ///
  /// {@macro scalable}
  /// Note that `allowBelow` is no-op in cases `startFrom` is >= `1.0`
  ///
  /// see also: [scalableFlexible] for standard scaling.
  double delayedScaleFlexible({
    WidgetRef? ref,
    BuildContext? context,
    required double startFrom,
    bool allowBelow = true,
    double? beforeStart,
    double? maxValue,
    double? maxFactor,
  }) {
    _safetyAssertion(startFrom, maxValue, maxFactor);
    final scaleFactor = LiveDataOrQuery.scalePercentage(ref: ref, context: context);
    return LiveData.applyScaleLogic(
      scaleFactor,
      startFrom: startFrom,
      beforeStart: beforeStart,
      baseValue: toDouble(),
      maxFactor: maxFactor,
      maxValue: maxValue,
      allowBelow: allowBelow,
    );
  }

  /// {@macro ref_scale}
  /// {@macro delayed_scale}
  /// {@macro scalable}
  /// Note that `allowBelow` is no-op in cases `startFrom` is >= `1.0`
  ///
  /// see also: [scalableFlexible] for standard scaling.
  double delayedScale(
    WidgetRef ref, {
    required double startFrom,
    bool allowBelow = true,
    double? beforeStart,
    double? maxValue,
    double? maxFactor,
  }) {
    _safetyAssertion(startFrom, maxValue, maxFactor);
    final scaleFactor = LiveData.scalePercentage(ref);
    return LiveData.applyScaleLogic(
      scaleFactor,
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
      final scaledFontSize = LiveData.applyScaleLogic(
        LiveDataOrQuery.scalePercentage(ref: ref, context: context),
        baseValue: style.fontSize!,
        allowBelow: allowBelow,
        maxValue: maxValue,
        maxFactor: maxFactor,
      );

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

extension ResponsiveDouble on num {
  double _responsive({
    required DeviceType current,
    DeviceType base = DeviceType.mobile480,
    double min = 0.0,
    double max = double.infinity,
    double percentageFactor = 1.0,
  }) {
    if (base == current) return toDouble();

    final change = this * _calculatePercentageStep(base, current, percentageFactor);
    final result = this + change;

    print('orig = $this, change: $change, = $result');

    return result.clamp(min, max);
  }

  /// {@template responsive_double}
  /// Returns a responsive double value by comparing `maxWidth` of `current` deviceType
  /// with [base] if:
  ///   - == `current` returns the double unchanged.
  ///   - \> `current` then we scale down
  ///   - < `current` then we scale up
  ///
  /// Scaling is calculated based on the percentage difference (the increase/decrease)
  /// between (base and current)'s maxWidth value and then reflect
  /// this change in the resulting double.
  ///
  /// Note: You can factor this percentage either by taking a portion of it if
  /// you see it too big, or scale it even bigger by using `percentageFactor`.
  ///
  /// {@endtemplate}
  double responsive(
    WidgetRef ref, {
    DeviceType base = DeviceType.mobile480,
    double min = 0.0,
    double max = double.infinity,
    double percentageFactor = 1.0,
  }) => _responsive(
    current: LiveData.deviceType(ref),
    base: base,
    min: min,
    max: max,
    percentageFactor: percentageFactor,
  );

  /// Same as [responsive] method but it has the flexiblity to use `context` as well as `ref`
  /// to internally get the current [DeviceType].
  ///
  /// It uses [LiveData.deviceType] if `ref` is passed and if not available
  /// ,while `context` is passed, it fallbacks to using [LiveDataOrQuery.deviceType], which
  /// internally uses `MediaQuery.sizeOf(context).width` to determine the current [DeviceType].
  ///
  /// ###### Be aware:
  /// If neither is passed it uses [StaticData], which needs [LiveData] to be at least initialized.
  /// Otherwise make sure you pass either `ref` or `context`.
  ///
  /// {@macro responsive_double}
  double responsiveFlexible({
    WidgetRef? ref,
    BuildContext? context,
    DeviceType base = DeviceType.mobile480,
    double min = 0.0,
    double max = double.infinity,
    double percentageFactor = 1.0,
  }) => _responsive(
    current: LiveDataOrQuery.deviceType(ref: ref, context: context),
    base: base,
    min: min,
    max: max,
    percentageFactor: percentageFactor,
  );

  double _calculatePercentageStep(DeviceType base, DeviceType current, double percentageFactor) {
    assert(
      base != current,
      'Base cannot be equal to current, try returning the style without any calculations',
    );
    assert(
      percentageFactor.isFinite && !percentageFactor.isNegative,
      'Percentage Factor must be finite and positive',
    );
    double percentageStep;
    if (current.maxWidth < base.maxWidth) {
      /// Scaling down
      percentageStep = -(base.maxWidth - current.maxWidth) / base.maxWidth;
    } else {
      /// Scaling up
      percentageStep = (current.maxWidth - base.maxWidth) / current.maxWidth;
    }
    return percentageStep * percentageFactor.abs();
  }
}

extension ResponsiveTypography on TextStyle {
  // TextStyle? changeSize({double? change, double? percentage}) {
  //   assert(
  //     (change != null) ^ (percentage != null),
  //     'Only one of change and percentage must be passed, '
  //     '${change == null && change == null ? 'Neither was passed' : 'NOT BOTH'}.',
  //   );

  //   if (fontSize == null) return null;

  //   double newFontSize;
  //   final baseSize = fontSize!;

  //   if (change != null) {
  //     newFontSize = baseSize + change;
  //   } else {
  //     newFontSize = baseSize + (baseSize * percentage!);
  //   }
  //   return copyWith(fontSize: newFontSize);
  // }

  /// {@template responsive_textStyle}
  /// Returns a responsive textStyle by adjusting its `fontsize` value. It is done by comparing
  /// `maxWidth` of `current` deviceType with [base] if:
  ///   - == `current` returns the same textStyle.
  ///   - \> `current` then we scale down
  ///   - < `current` then we scale up
  ///
  /// Scaling is calculated based on the percentage difference (the increase/decrease)
  /// between (base and current)'s maxWidth value and then reflect
  /// this change in the resulting double.
  ///
  /// Note: You can factor this percentage either by taking a portion of it if
  /// you see it too big, or scale it even bigger by using `percentageFactor`.
  ///
  /// Here, we only take _half_ of the percentage difference because the actual
  /// value will be too large to account for. Here is why:
  ///
  /// when [base] == [DeviceType.mini1280] and [current] is [DeviceType.standard1920]
  /// (1920 - 1280) / 1280  = 1 / 2, which means a textStyle of fontSize `16`
  /// would be `24` i.e `50%` increase (too big). We handled that by only taking half
  /// of the percentage (making `percentageFactor` defaults to `0.5`)
  /// which in the above case would be only `25%` increase i.e. `16` -> `20` instead of `16` -> `24`
  ///
  /// This is more reasonable for the step from a miniScreen to a standardScreen
  /// {@endtemplate}
  TextStyle? responsive(
    WidgetRef ref, {
    DeviceType base = DeviceType.mobile480,
    double min = 0.0,
    double max = double.infinity,
    double percentageFactor = 0.5,
  }) {
    if (fontSize == null) return null;

    return copyWith(
      fontSize: fontSize?.responsive(
        ref,
        base: base,
        min: min,
        max: max,
        percentageFactor: percentageFactor,
      ),
    );
  }

  /// Same as [responsive] method but it has the flexiblity to use `context` as well as `ref`
  /// to internally get the current [DeviceType].
  ///
  /// It uses [LiveData.deviceType] if `ref` is passed and if not available
  /// ,while `context` is passed, it fallbacks to using [LiveDataOrQuery.deviceType], which
  /// internally uses `MediaQuery.sizeOf(context).width` to determine the current [DeviceType].
  ///
  /// ###### Be aware:
  /// If neither is passed it uses [StaticData], which needs [LiveData] to be at least initialized.
  /// Otherwise make sure you pass either `ref` or `context`.
  ///
  /// {@macro responsive_textStyle}
  TextStyle? responsiveFlexibe({
    WidgetRef? ref,
    BuildContext? context,
    DeviceType base = DeviceType.mobile480,
    double min = 0.0,
    double max = double.infinity,
    double percentageFactor = 0.5,
  }) {
    if (fontSize == null) return null;

    return copyWith(
      fontSize: fontSize?.responsiveFlexible(
        ref: ref,
        context: context,
        base: base,
        min: min,
        max: max,
        percentageFactor: percentageFactor,
      ),
    );
  }
}

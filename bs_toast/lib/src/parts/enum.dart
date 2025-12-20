import 'dart:ui' show Color;

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Just a color convenience enum.
enum ToastState {
  /// sets the color to adaptive grey
  regular,
  /// sets the color according to appTheme's [colorScheme.surfaceTint]
  success,
  /// sets the color to yellow #FFC038
  warning,
  /// sets the color to red #980B0B
  error
  ;

  static Map<ToastState, Color>? _userDefinedColor;

  /// Sets the color map for the toast states.
  ///
  /// This is useful when you want to change the colors of the toast states
  /// without passing the color parameter to the [Toast.show] methods.
  static void setStateColorMap(Map<ToastState, Color> stateColorMap) =>
      _userDefinedColor = stateColorMap;

  Color color(WidgetRef ref) =>
      _userDefinedColor?[this] ??
      switch (this) {
        ToastState.regular => AppStyle.colors.adaptiveGrey(ref),

        //   ToastState.success => AppStyle.colors.highlightPrimary(ref),
        ToastState.success => LiveData.themeData(ref).colorScheme.surfaceTint,
        ToastState.warning => const Color(0xFFFFC038),
        ToastState.error => const Color(0xFF980B0B),
      };
}

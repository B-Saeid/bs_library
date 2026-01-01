import 'dart:math' as math;

import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// Workaround the deprecation of `withOpacity`
  ///
  /// 1.0 > Opaque
  /// 0.0 > Transparent
  Color withAlphaFraction(double fraction) => withAlpha((fraction * 255).round());

  /// Darken color according to [by] value
  ///  * [by] must be between 0.0 and 1.0 by default: `0.1`
  ///  * [decreaseAlpha] is used to decrease opacity by default: `false`
  ///  * color cannot be black unless its alpha can be decreased
  ///  with [by] value and of course [decreaseAlpha] is passed with true
  Color darken({double by = 0.1, bool decreaseAlpha = false}) {
    assert(by >= 0.0 && by <= 1.0, '[by] must be between 0.0 and 1.0');

    assert(
      r > 0.0 || g > 0.0 || b > 0.0 || decreaseAlpha ? a + by > 0 : false,
      decreaseAlpha && a + by <= 0
          ? 'Color can not darkened with given [by] of $by Try lowering the [by] value'
          : 'BLACK can not be darkened',
    );

    return Color.fromARGB(
      Color.getAlphaFromOpacity(decreaseAlpha ? a - by : a),
      (math.max<double>(0.0, r - by) * 255).round(),
      (math.max<double>(0.0, g - by) * 255).round(),
      (math.max<double>(0.0, b - by) * 255).round(),
    );
  }

  /// Lighten color according to [by] value
  ///  * [by] must be between 0.0 and 1.0 by default: `0.1`
  ///  * [increaseAlpha] is used to increase opacity by default: `false`
  ///  * color cannot be white unless its alpha can be increased
  ///  with [by] value and of course [increaseAlpha] is passed with true
  Color lighten({double by = 0.1, bool increaseAlpha = false}) {
    assert(by >= 0.0 && by <= 1.0, '[by] must be between 0.0 and 1.0');
    assert(
      r < 255.0 || g < 255.0 || b < 255.0 || increaseAlpha ? a + by < 255 : false,
      increaseAlpha && a + by >= 255
          ? 'Color can not lightened with given [by] of $by Try lowering the [by] value'
          : 'WHITE can not be lightened',
    );
    return Color.fromARGB(
      Color.getAlphaFromOpacity(increaseAlpha ? a + by : a),
      (math.min<double>(1.0, r + by) * 255).round(),
      (math.min<double>(1.0, g + by) * 255).round(),
      (math.min<double>(1.0, b + by) * 255).round(),
    );
  }

  /// returns black or white depending on the luminance of the base color
  ///
  /// if Luminant (Close to white) > returns black
  /// if Dimmed (Close to black) > returns white
  ///
  /// Expensive method; Use reasonably
  Color get invertedBW => computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

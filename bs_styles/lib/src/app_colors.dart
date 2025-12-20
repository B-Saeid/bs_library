import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'color_extension.dart';

final class AppColors {
  const AppColors._();

  static final instance = const AppColors._();

  // /// In September 2019 Dark mode was introduced by Android 10 Q (API 29) and iOS 13
  // /// This line is to show automatic themeMode is Android 10 and above
  // /// Note: We are not checking on iOS as we do not support iOS below 13
  // /// however we support from Android 6 (API 23)
  // bool get isDarkModeSupported => (DeviceInfoService.android?.apiLevel ?? 30) >= 29;

  TextStyle? positiveChoiceStyle(WidgetRef ref, {bool bold = true}) =>
      LiveData.textTheme(ref).bodyMedium?.copyWith(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: LiveData.themeData(ref).colorScheme.surfaceTint,
      );

  TextStyle? staticPositiveChoiceStyle({bool bold = true}) =>
      StaticData.textTheme.bodyMedium?.copyWith(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: StaticData.themeData.colorScheme.surfaceTint,
      );

  TextStyle? negativeChoiceStyle(WidgetRef ref) => LiveData.textTheme(ref).bodyMedium?.copyWith(
    color: negativeColor(ref),
  );

  TextStyle? get staticNegativeChoiceStyle => StaticData.textTheme.bodyMedium?.copyWith(
    color: staticNegativeColor,
  );

  Color negativeColor(WidgetRef ref) => LiveData.themeData(ref).colorScheme.error;

  Color get staticNegativeColor => StaticData.themeData.colorScheme.error;

  Color adaptiveNegativeColor(WidgetRef ref, BuildContext context) => StaticData.platform.isApple
      ? CupertinoColors.destructiveRed.resolveFrom(context)
      : LiveData.themeData(ref).colorScheme.error;

  Color get staticAdaptiveNegativeColor => StaticData.platform.isApple
      ? CupertinoColors.destructiveRed
      : StaticData.themeData.colorScheme.error;

  Color whiteDarkBlackLight(WidgetRef ref) => LiveData.isLight(ref) ? Colors.black : Colors.white;

  Color staticWhiteDarkBlackLight(WidgetRef ref) =>
      StaticData.isLight ? Colors.black : Colors.white;

  Color whiteLightBlackDark(WidgetRef ref) => LiveData.isLight(ref) ? Colors.white : Colors.black;

  Color staticWhiteLightBlackDark(WidgetRef ref) =>
      StaticData.isLight ? Colors.white : Colors.black;

  LinearGradient opacityGradient(Color color, [(double from, double to)? bounds]) => LinearGradient(
    colors: [
      color.withAlphaFraction(bounds?.$1 ?? 0.15),
      color.withAlphaFraction(bounds?.$2 ?? 0.05),
    ],
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
  );

  Color get green => Colors.green.shade700;

  Color get greenLight => Colors.green.shade400;

  Color adaptiveGreen(WidgetRef ref) => LiveData.isLight(ref) ? green : greenLight;

  Color get staticAdaptiveGreen => StaticData.isLight ? green : greenLight;

  Color adaptiveIGreen(WidgetRef ref) => LiveData.isLight(ref) ? greenLight : green;

  Color get staticAdaptiveIGreen => StaticData.isLight ? greenLight : green;

  Color get grey => const Color(0xff4b4b4b);

  Color get greyLight => const Color(0xffd2d2d2);

  Color adaptiveGrey(WidgetRef ref) =>
      LiveData.isLight(ref) ? const Color(0xffd2d2d2) : const Color(0xff4b4b4b);

  Color get staticAdaptiveGrey =>
      StaticData.isLight ? const Color(0xffd2d2d2) : const Color(0xff4b4b4b);

  Color get yellow => const Color(0xff7b6727);

  Color get yellowLight => const Color(0xfffff799);

  Color adaptiveYellow(WidgetRef ref) => LiveData.isLight(ref) ? yellow : yellowLight;

  Color get staticAdaptiveYellow => StaticData.isLight ? yellow : yellowLight;

  Color adaptiveIYellow(WidgetRef ref) => LiveData.isLight(ref) ? yellowLight : yellow;

  Color get staticAdaptiveIYellow => StaticData.isLight ? yellowLight : yellow;

  Color get red => const Color(0xffb33c3c);

  Color get redLight => const Color(0xffff9999);

  Color adaptiveRed(WidgetRef ref) => LiveData.isLight(ref) ? red : redLight;

  Color get staticAdaptiveRed => StaticData.isLight ? red : redLight;

  Color adaptiveIRed(WidgetRef ref) => LiveData.isLight(ref) ? redLight : red;

  Color get staticAdaptiveIRed => StaticData.isLight ? redLight : red;

  Color get blue => const Color(0xFF3c6ab3);

  Color get purple => const Color(0xFF6a3cb3);

  Color get blueLight => const Color(0xff88b2ff);

  Color get purpleLight => const Color(0xffb388ff);

  Color adaptiveBlue(WidgetRef ref) => LiveData.isLight(ref) ? blue : blueLight;

  Color get staticAdaptiveBlue => StaticData.isLight ? blue : blueLight;

  Color adaptivePurple(WidgetRef ref) => LiveData.isLight(ref) ? purple : purpleLight;

  Color get staticAdaptivePurple => StaticData.isLight ? purple : purpleLight;

  Color scaffoldBackground(WidgetRef ref) => LiveData.themeData(ref).scaffoldBackgroundColor;

  Color get staticScaffoldBackground => StaticData.themeData.scaffoldBackgroundColor;

  Color onScaffoldBackground(WidgetRef ref) {
    return LiveData.themeData(ref).colorScheme.surfaceContainerLowest;
    // final scaBg = LiveData.themeData(ref).scaffoldBackgroundColor;
    // return LiveData.isLight(ref)
    //     ? Colors.white
    //     : Color.fromARGB(
    //         255,
    //         scaBg.red + 4,
    //         scaBg.green + 4,
    //         scaBg.blue + 4,
    //       );
  }

  Color get staticOnScaffoldBackground => StaticData.themeData.colorScheme.surfaceContainerLowest;
}

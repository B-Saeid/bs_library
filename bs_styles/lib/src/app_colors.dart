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

  TextStyle? positiveChoiceStyle({WidgetRef? ref, BuildContext? context, bool bold = true}) =>
      LiveDataOrQuery.textTheme(ref: ref, context: context).bodyMedium?.copyWith(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: LiveDataOrQuery.themeData(ref: ref, context: context).colorScheme.surfaceTint,
      );

  TextStyle? negativeChoiceStyle({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.textTheme(ref: ref, context: context).bodyMedium?.copyWith(
        color: negativeColor(ref: ref, context: context),
      );

  Color negativeColor({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.themeData(ref: ref, context: context).colorScheme.error;

  Color adaptiveNegativeColor({WidgetRef? ref, BuildContext? context}) =>
      StaticData.platform.isApple
      ? context != null
            ? CupertinoColors.destructiveRed.resolveFrom(context)
            : CupertinoColors.destructiveRed
      : LiveDataOrQuery.themeData(ref: ref, context: context).colorScheme.error;

  Color whiteDarkBlackLight({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? Colors.black : Colors.white;

  Color whiteLightBlackDark({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? Colors.white : Colors.black;

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

  Color adaptiveGreen({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? green : greenLight;

  Color adaptiveIGreen({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? greenLight : green;

  Color get grey => const Color(0xff4b4b4b);

  Color get greyLight => const Color(0xffd2d2d2);

  Color adaptiveGrey({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context)
      ? const Color(0xffd2d2d2)
      : const Color(0xff4b4b4b);

  Color get yellow => const Color(0xff7b6727);

  Color get yellowLight => const Color(0xfffff799);

  Color adaptiveYellow({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? yellow : yellowLight;

  Color adaptiveIYellow({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? yellowLight : yellow;

  Color get red => const Color(0xffb33c3c);

  Color get redLight => const Color(0xffff9999);

  Color adaptiveRed({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? red : redLight;

  Color adaptiveIRed({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? redLight : red;

  Color get blue => const Color(0xFF3c6ab3);

  Color get purple => const Color(0xFF6a3cb3);

  Color get blueLight => const Color(0xff88b2ff);

  Color get purpleLight => const Color(0xffb388ff);

  Color adaptiveBlue({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? blue : blueLight;

  Color adaptivePurple({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.isLight(ref: ref, context: context) ? purple : purpleLight;

  Color scaffoldBackground({WidgetRef? ref, BuildContext? context}) =>
      LiveDataOrQuery.themeData(ref: ref, context: context).scaffoldBackgroundColor;

  Color onScaffoldBackground({WidgetRef? ref, BuildContext? context}) {
    return LiveDataOrQuery.themeData(ref: ref, context: context).colorScheme.surfaceContainerLowest;
    // final scaBg = LiveDataOrQuery.themeData(ref: ref, context: context).scaffoldBackgroundColor;
    // return LiveDataOrQuery.isLight(ref: ref, context: context
    //     ? Colors.white
    //     : Color.fromARGB(
    //   255,
    //   scaBg.red + 4,
    //   scaBg.green + 4,
    //   scaBg.blue + 4,
    // );
  }
}

// ignore_for_file: constant_identifier_names
import 'package:flutter/cupertino.dart';

abstract final class OverriddenIcons {
  final s = CupertinoIcons.star_lefthalf_fill;
  static const String iconFont = 'CupertinoIcons';

  /// The dependent package providing the Cupertino icons font.
  static const String iconFontPackage = 'cupertino_icons';

  static const IconData star_lefthalf_fill = IconData(
    0xf823,
    fontFamily: iconFont,
    fontPackage: iconFontPackage,
    matchTextDirection: false,
  );

  static const IconData star_lefthalf_fill_TD = IconData(
    0xf823,
    fontFamily: iconFont,
    fontPackage: iconFontPackage,
    matchTextDirection: true,
  );

  static const IconData star_half_rounded = IconData(
    0xf01d0,
    fontFamily: 'MaterialIcons',
    matchTextDirection: false,
  );

  static const IconData star_half_rounded_TD = IconData(
    0xf01d0,
    fontFamily: 'MaterialIcons',
    matchTextDirection: true,
  );

  static const IconData chevron_right = IconData(
    0xf3d3,
    fontFamily: iconFont,
    fontPackage: iconFontPackage,
    matchTextDirection: false,
  );

  static const IconData chevron_right_TD = IconData(
    0xf3d3,
    fontFamily: iconFont,
    fontPackage: iconFontPackage,
    matchTextDirection: true,
  );

  static const IconData chevron_right_rounded = IconData(
    0xf63b,
    fontFamily: 'MaterialIcons',
    matchTextDirection: false,
  );

  static const IconData chevron_right_rounded_TD = IconData(
    0xf63b,
    fontFamily: 'MaterialIcons',
    matchTextDirection: true,
  );

  static const IconData chevron_left = IconData(
    0xf3d2,
    fontFamily: iconFont,
    fontPackage: iconFontPackage,
    matchTextDirection: false,
  );

  static const IconData chevron_left_TD = IconData(
    0xf3d2,
    fontFamily: iconFont,
    fontPackage: iconFontPackage,
    matchTextDirection: true,
  );

  static const IconData chevron_left_rounded = IconData(
    0xf63a,
    fontFamily: 'MaterialIcons',
    matchTextDirection: false,
  );

  static const IconData chevron_left_rounded_TD = IconData(
    0xf63a,
    fontFamily: 'MaterialIcons',
    matchTextDirection: true,
  );
}

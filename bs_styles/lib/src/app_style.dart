import 'package:flutter/foundation.dart';

import 'adaptive_icons.dart';
import 'app_colors.dart';

abstract final class AppStyle {
  static final colors = AppColors.instance;
  static final icons = AdaptiveIcons();

  static AdaptiveIcons iconsOfPlatform(TargetPlatform targetPlatform) =>
      AdaptiveIcons(targetPlatform);
}

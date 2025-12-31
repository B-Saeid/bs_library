import 'package:bs_utils/bs_utils.dart';

import 'adaptive_icons.dart';
import 'app_colors.dart';

abstract final class AppStyle {
  static final colors = AppColors.instance;
  static final icons = AdaptiveIcons();

  static AdaptiveIcons iconsOfPlatform(DevicePlatform platform) => AdaptiveIcons(platform);
}

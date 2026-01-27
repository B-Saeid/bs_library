import 'package:bs_riverpod_utils/bs_riverpod_utils.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/adaptive_button.dart';
import 'package:flutter/material.dart';

import '../../providers/setting_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return AdaptiveIconButton(
      onPressed: () => context
          .read(settingProvider.notifier)
          .setThemeMode(isLight ? ThemeMode.dark : ThemeMode.light),
      iconData: isLight ? AppStyle.icons.dark : AppStyle.icons.light,
    );
  }
}

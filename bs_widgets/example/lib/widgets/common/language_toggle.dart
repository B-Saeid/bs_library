import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/setting_provider.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AdaptiveButton(
    onPressed: () => ref
        .read(settingProvider.notifier)
        .setLocaleSetting(
          Localizations.localeOf(context).languageCode == 'en'
              ? LocaleSetting.arabic
              : LocaleSetting.english,
        ),
    icon: Icon(AppStyle.icons.globe),
    child: SupportedLocale.fromLocale(Localizations.localeOf(context)).displayName,
  );
}

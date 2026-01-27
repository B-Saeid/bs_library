import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import 'common/language_toggle.dart';
import 'common/theme_toggle.dart';

class TopBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  const TopBar({
    super.key,
    required this.title,
    required this.changePage,
  });

  final String title;
  final void Function(Widget page) changePage;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppBar(
    title: Text(title),
    actions: [
      const ThemeToggle(),
      const LanguageToggle(),
      PopupMenuButton(
        child: Icon(AppStyle.icons.dotsV),
        onSelected: (value) => changePage(examplePages[value]!),
        itemBuilder: (context) => examplePages.entries
            .map((e) => PopupMenuItem(value: e.key, child: Text(e.key)))
            .toList(),
      ),
    ],
    actionsPadding: const EdgeInsetsDirectional.only(end: 10),
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

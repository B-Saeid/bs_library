import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  const TopBar({
    super.key,
    required this.title,
    required this.changeThemeMode,
    required this.mode,
    required this.changePage,
  });

  final String title;
  final VoidCallback changeThemeMode;
  final ThemeMode mode;
  final void Function(Widget page) changePage;

  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(title),
    actions: [
      IconButton(
        onPressed: changeThemeMode,
        icon: Icon(mode == ThemeMode.system ? AppStyle.icons.light : AppStyle.icons.dark),
      ),
      PopupMenuButton(
        child: Icon(AppStyle.icons.dotsV),
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

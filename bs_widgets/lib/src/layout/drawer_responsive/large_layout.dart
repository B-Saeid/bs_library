import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../animated/custom_animated_size.dart';
import '../../misc/l10nr_text.dart';
import '../../misc/scale_controlled_text.dart';

class LargeLayout extends ConsumerWidget {
  const LargeLayout({
    super.key,
    required this.content,
    required this.title,
    this.drawer,
    required this.showEndDrawer,
    required this.useSafeArea,
    required this.hideDrawerTitle,
    required this.hideDrawerTooltip,
  });

  final Widget content;
  final Widget? drawer;
  final bool showEndDrawer;
  final StringRef title;
  final bool useSafeArea;
  final StringRef hideDrawerTitle;
  final StringRef hideDrawerTooltip;
  static ValueNotifier<bool> drawerHidden = ValueNotifier(false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = drawer != null
        ? Row(
            children: [
              _LargeLayoutDrawer(drawer!, hideDrawerTitle, hideDrawerTooltip),
              Expanded(child: _ContentWithAppBar(content, title)),
            ],
          )
        : _ContentWithAppBar(content, title);

    return Scaffold(body: useSafeArea ? SafeArea(child: child) : child);
  }
}

class _LargeLayoutDrawer extends StatelessWidget {
  const _LargeLayoutDrawer(
    this.drawer,
    this.hideDrawerTitle,
    this.hideDrawerTooltip,
  );

  final StringRef hideDrawerTitle;
  final StringRef hideDrawerTooltip;
  final Widget drawer;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: LargeLayout.drawerHidden,
    builder: (context, hidden, child) =>
        CustomAnimatedSize(child: hidden ? const SizedBox() : child!),
    child: SizedBox(
      width: 220,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          drawer,
          _HideDrawerButton(hideDrawerTitle, hideDrawerTooltip),
        ],
      ),
    ),
  );
}

class _HideDrawerButton extends ConsumerWidget {
  const _HideDrawerButton(this.hideDrawerTitle, this.hideDrawerTooltip);

  final StringRef hideDrawerTitle;
  final StringRef hideDrawerTooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
    child: ActionChip(
      label: ScaleControlledText(hideDrawerTitle(ref), maxFactor: 2),
      avatar: Icon(
        Directionality.of(context) == TextDirection.ltr
            ? AppStyle.icons.arrowLeft
            : AppStyle.icons.arrowRight,
        size: 24.scalable(ref, maxValue: 32),
      ),
      onPressed: () => LargeLayout.drawerHidden.value = true,
      tooltip: hideDrawerTooltip(ref),
      visualDensity: VisualDensity.compact,
      shape: const StadiumBorder(),
    ),
  );
}

class _ContentWithAppBar extends ConsumerWidget {
  const _ContentWithAppBar(this.content, this.title);

  final Widget content;
  final StringRef title;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: _LargeLayoutAppBar(title: title),
    body: content,
  );
}

class _LargeLayoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _LargeLayoutAppBar({required this.title});

  final StringRef title;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: LargeLayout.drawerHidden,
    builder: (context, hidden, child) => hidden
        ? AppBar(
            leading: DrawerButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
                LargeLayout.drawerHidden.value = false;
              },
            ),
            title: L10nRText(title),
          )
        : AppBar(
            // Uncomment it to prevent back button at all if drawer is persistent
            // leading: const SizedBox(),
            title: L10nRText(title),
          ),
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

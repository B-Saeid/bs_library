import 'package:bs_l10n/bs_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bs_widgets.dart';

class MobileLayout extends ConsumerOrStatelessWidget {
  const MobileLayout({
    required this.content,
    required this.title,
    this.drawer,
    required this.showEndDrawer,
    required this.useSafeArea,
    super.key,
  });

  final Widget content;
  final Widget? drawer;
  final StringRef title;
  final bool showEndDrawer;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context, WidgetRef? ref) => Scaffold(
    appBar: AppBar(title: L10nRText(title)),
    drawer: showEndDrawer ? null : drawer,
    endDrawer: showEndDrawer ? drawer : null,
    body: useSafeArea ? SafeArea(child: content) : content,
  );
}

import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod_widgets.dart';
import '../break_points.dart';
import 'large_layout.dart';
import 'mobile_layout.dart';

class DrawerResponsiveLayout extends ConsumerWidget {
  const DrawerResponsiveLayout({
    super.key,
    required this.title,
    required this.content,
    required this.hideDrawerTitle,
    required this.hideDrawerTooltip,
    this.drawer,
    this.showEndDrawer = false,
    this.useSafeArea = true,
  }) : assert(
         drawer == null ? showEndDrawer == false : true,
         'Drawer cannot be null if showEndDrawer is true',
       );

  final StringRef title;
  final Widget content;
  final Widget? drawer;
  final bool showEndDrawer;
  final bool useSafeArea;
  final StringRef hideDrawerTitle;
  final StringRef hideDrawerTooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Selector<double>(
    selector: LiveData.widthSelector,
    builder: (context, width, _) => BreakPoints.isMobile(width)
        ? MobileLayout(
            content: content,
            title: title,
            drawer: drawer,
            showEndDrawer: showEndDrawer,
            useSafeArea: useSafeArea,
          )
        : LargeLayout(
            content: content,
            title: title,
            drawer: drawer,
            showEndDrawer: showEndDrawer,
            useSafeArea: useSafeArea,
            hideDrawerTitle: hideDrawerTitle,
            hideDrawerTooltip: hideDrawerTooltip,
          ),
  );
}

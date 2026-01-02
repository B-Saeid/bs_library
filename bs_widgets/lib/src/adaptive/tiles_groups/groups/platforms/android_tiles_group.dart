import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../riverpod_widgets/consumer_or_stateless.dart';
import '../../theme/adaptive_tiles_theme.dart';
import '../../tiles/abstract_tile.dart';

class AndroidTilesGroup extends ConsumerOrStatelessWidget {
  const AndroidTilesGroup({
    required this.tiles,
    required this.margin,
    this.header,
    super.key,
  });

  final List<AbstractTile> tiles;
  final EdgeInsetsGeometry? margin;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef? ref) => Container(
    constraints: AdaptiveTilesTheme.of(context)?.themeData.constraints,
    padding: margin ?? EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: EdgeInsetsDirectional.only(
              top: 24.scalableFlexible(ref: ref, context: context),
              bottom: 10.scalableFlexible(ref: ref, context: context),
              start: 24,
              end: 24,
            ),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                // color: ref.watch(adaptiveTilesThemeProvider).themeData.titleTextColor,
                color: AdaptiveTilesTheme.of(context)!.themeData.titleTextColor,
              ),
              child: header!,
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: tiles.length,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => tiles[index],
        ),
      ],
    ),
  );
}

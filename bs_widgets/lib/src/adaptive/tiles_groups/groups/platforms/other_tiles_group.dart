import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../riverpod_widgets/consumer_or_stateless.dart';
import '../../theme/adaptive_tiles_theme.dart';
import '../../tiles/abstract_tile.dart';

class OtherTilesGroup extends ConsumerOrStatelessWidget {
  const OtherTilesGroup({
    required this.tiles,
    required this.padding,
    this.header,
    super.key,
  });

  final List<AbstractTile> tiles;
  final EdgeInsetsGeometry? padding;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef? ref) => Container(
    constraints: AdaptiveTilesTheme.of(context)?.themeData.constraints,
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null) buildHeader(context, ref),
        buildTileList(),
      ],
    ),
  );

  Padding buildHeader(BuildContext context, WidgetRef? ref) => Padding(
    padding: EdgeInsetsDirectional.only(
      bottom: 15.scalableFlexible(ref: ref, context: context),
      start: 6,
      top: 40.scalableFlexible(ref: ref, context: context),
    ),
    child: DefaultTextStyle.merge(
      style: LiveDataOrQuery.textTheme(ref: ref, context: context).titleLarge,
      child: header!,
    ),
  );

  Widget buildTileList() => ListView.separated(
    shrinkWrap: true,
    itemCount: tiles.length,
    padding: EdgeInsets.zero,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (_, index) => tiles[index],
    separatorBuilder: (_, _) => const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
  );
}

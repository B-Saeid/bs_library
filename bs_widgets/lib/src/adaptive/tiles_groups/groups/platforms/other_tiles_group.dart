import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tiles/abstract_tile.dart';

class OtherTilesGroup extends ConsumerWidget {
  const OtherTilesGroup({
    required this.tiles,
    required this.margin,
    this.header,
    super.key,
  });

  final List<AbstractTile> tiles;
  final EdgeInsetsGeometry? margin;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: margin ?? EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null) buildHeader(context, ref),
        buildTileList(),
      ],
    ),
  );

  Padding buildHeader(BuildContext context, WidgetRef ref) => Padding(
    padding: EdgeInsetsDirectional.only(
      bottom: 15.scalable(ref),
      start: 6,
      top: 40.scalable(ref),
    ),
    child: DefaultTextStyle.merge(
      style: LiveData.textTheme(ref).titleLarge,
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

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../riverpod_widgets/consumer_or_stateless.dart';
import '../../theme/adaptive_tiles_theme.dart';
import '../../tiles/abstract_tile.dart';

class AppleTilesGroup extends ConsumerOrStatelessWidget {
  const AppleTilesGroup({
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
    child: ListView(
      padding: margin ?? EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _getTilesList(context),
    ),
  );

  /// Since iOS design impose displaying the description separated under the setting tile.
  ///
  /// This logic is written to properly display ios setting tiles with
  /// descriptive ones being taken into account any where they are in the list
  ///   - alone
  ///   - first
  ///   - last
  ///   - within
  ///   YOU GET THE IDEA!
  List<Widget> _getTilesList(BuildContext context) {
    final tilesWidgetList = <Widget>[];

    var nonDescriptiveTiles = 0;
    var lastDescriptiveIndex = -1;

    for (var i = 0; i < tiles.length; i++) {
      // print('i is $i');
      if (tiles[i].description == null) {
        // print('inside tiles[i].description == null');
        nonDescriptiveTiles++;
      } else {
        // print('inside else');

        if (nonDescriptiveTiles > 0) {
          // print('inside nonDescriptiveTiles > 0');
          nonDescriptiveTiles = 0;
          // print('lastDescriptiveIndex = $lastDescriptiveIndex');
          final start = lastDescriptiveIndex == -1 ? 0 : lastDescriptiveIndex + 1;
          // print('start = $start');
          // print('end = $i');
          lastDescriptiveIndex = i;
          tilesWidgetList.add(_lastIsDescriptive(context, start, i));
        } else {
          lastDescriptiveIndex = i;
          tilesWidgetList.add(_singleDescriptive(context, i));
        }
      }
    }

    /// Add the remaining non-descriptive tiles
    if (nonDescriptiveTiles > 0) {
      // print('inside the outside nonDescriptiveTiles > 0');
      final start = lastDescriptiveIndex == -1 ? 0 : lastDescriptiveIndex + 1;
      tilesWidgetList.add(_nonDescriptive(start, tiles.length));
    }

    return tilesWidgetList;
  }

  // _CustomCupertinoListSection _singleDescriptive(WidgetRef? ref, int i) =>
  _CustomCupertinoListSection _singleDescriptive(
    BuildContext context,
    int i,
  ) => _CustomCupertinoListSection(
    header: i == 0 && header != null ? _SectionHeader(header!) : null,

    /// Since Description for iOS is not with in the tile itself it is added here
    // footer: buildDescription(ref, tiles[i].description!),
    footer: buildDescription(context, tiles[i].description!),
    tiles: [tiles[i]],
  );

  // _CustomCupertinoListSection _lastIsDescriptive(WidgetRef? ref, int start, int end) =>
  _CustomCupertinoListSection _lastIsDescriptive(
    BuildContext context,
    int start,
    int end,
  ) => _CustomCupertinoListSection(
    header: start == 0 && header != null ? _SectionHeader(header!) : null,

    /// Since Description for iOS is not with in the tile itself it is added here
    // footer: buildDescription(ref, tiles[end].description!),
    footer: buildDescription(context, tiles[end].description!),
    tiles: tiles.getRange(start, end + 1).toList(),
  );

  // Widget buildDescription(WidgetRef? ref, Widget description) => Padding(
  Widget buildDescription(BuildContext context, Widget description) => Padding(
    // padding: const EdgeInsets.only(top: 8.0),
    padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
    child: DefaultTextStyle.merge(
      style: TextStyle(
        // color: ref.watch(adaptiveTilesThemeProvider).themeData.tileDescriptionTextColor,
        color: AdaptiveTilesTheme.of(
          context,
        )!.themeData.tileDescriptionTextColor,
        fontSize: 13,
      ),
      child: description,
    ),
  );

  _CustomCupertinoListSection _nonDescriptive(int start, int end) => _CustomCupertinoListSection(
    header: start == 0 && header != null ? _SectionHeader(header!) : null,
    tiles: tiles.getRange(start, end).toList(),
  );
}

class _SectionHeader extends ConsumerOrStatelessWidget {
  const _SectionHeader(this.header);

  final Widget header;

  @override
  Widget build(BuildContext context, WidgetRef? ref) => Padding(
    padding: EdgeInsetsDirectional.only(
      bottom: 5.scalableFlexible(ref: ref, context: context),
    ),
    child: DefaultTextStyle.merge(
      style: TextStyle(
        // color: ref.watch(adaptiveTilesThemeProvider).themeData.titleTextColor,
        color: AdaptiveTilesTheme.of(context)!.themeData.titleTextColor,
        fontSize: 16,
      ),
      child: header,
    ),
  );
}

class _CustomCupertinoListSection extends ConsumerOrStatelessWidget {
  const _CustomCupertinoListSection({
    this.header,
    this.footer,
    required this.tiles,
  });

  final Widget? header;
  final Widget? footer;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context, WidgetRef? ref) => CupertinoListSection.insetGrouped(
    margin: AdaptiveTilesTheme.of(context)!.themeData.iOSTilesGroupMargin,
    header: header,
    dividerMargin: 0,
    hasLeading: false,
    additionalDividerMargin: 12,
    backgroundColor: Colors.transparent,
    footer: footer,
    children: tiles,
  );
}

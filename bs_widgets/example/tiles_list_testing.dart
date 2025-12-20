// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'adaptive_tiles_list.dart';
// import 'groups/adaptive_tiles_group.dart';
// import 'tiles/abstract_tile.dart';
// import 'tiles/adaptive_tile.dart';
//
// class AdaptiveTilesGroupsTesting extends ConsumerWidget {
//   const AdaptiveTilesGroupsTesting({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return const ColoredBox(
//       color: Colors.white12,
//       child: AdaptiveTilesList(
//         sections: [
//           AdaptiveTilesGroup(
//             // margin: GlobalConstants.screensHPadding,
//             header: Text('Group 1'),
//             tiles: [Tile(), DTile()],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Tile extends AbstractTile {
//   const Tile({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ColoredBox(
//       color: Colors.purple,
//       child: Consumer(
//         builder: (context, ref, child) {
//           return const AdaptiveTile(
//             title: Text('null'),
//             value: Text('This is a value'),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class DTile extends AbstractTile {
//   const DTile({super.key});
//
//   @override
//   Widget? get description => const Text('This is a description');
//
//   @override
//   Widget build(BuildContext context) {
//     return ColoredBox(
//       color: Colors.black38,
//       child: Consumer(
//         builder: (context, ref, child) {
//           return AdaptiveTile(
//             title: const Text('null'),
//             description: description,
//           );
//         },
//       ),
//     );
//   }
// }

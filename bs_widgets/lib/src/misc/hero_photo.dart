// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:photo_view/photo_view.dart';
//
// import '../Styles/app_style.dart';
// import 'neat_circular_indicator.dart';
//
// class HeroPhoto extends ConsumerWidget {
//   const HeroPhoto({
//     super.key,
//     required this.imageProvider,
//     this.tag,
//   });
//
//   HeroPhoto.asset({
//     super.key,
//     required String path,
//     this.tag,
//   }) : imageProvider = AssetImage(path);
//
//   HeroPhoto.memory({
//     super.key,
//     required Uint8List bytes,
//     this.tag,
//   }) : imageProvider = MemoryImage(bytes);
//
//   final Object? tag;
//   final ImageProvider imageProvider;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: PhotoView(
//         /// TODO : THIS ASSET SHOULD BE SAVED IN DATABASE and then used as base64Decode i.e. MemoryImage
//         imageProvider: imageProvider,
//         backgroundDecoration: BoxDecoration(color: AppStyle.colors.scaffoldBackground(ref)),
//         minScale: PhotoViewComputedScale.contained,
//         maxScale: PhotoViewComputedScale.covered * 3,
//         loadingBuilder: (context, event) => const Center(child: NeatCircularIndicator()),
//         heroAttributes: PhotoViewHeroAttributes(tag: tag ?? imageProvider.hashCode),
//       ),
//     );
//   }
// }

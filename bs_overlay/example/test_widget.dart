// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// import '../Common/constants/global_constants.dart';
// import '../lib/Extensions/time_package.dart';
// import '../lib/src/Buttons/buttons.dart';
// import '../lib/src/Toast/toast.dart';
// import '../lib/src/Overlay/overlay.dart';
//
// class MyOverlayTestWidget extends StatelessWidget {
//   const MyOverlayTestWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Testing Overlays')),
//       body: Center(
//         child: Padding(
//           padding: GlobalConstants.screensHPadding,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: Priority.values
//                 .map(
//                   (e) => Center(
//                     child: CustomButton(
//                       onPressed: () {
//                         switch (e) {
//                           case Priority.regular:
//                             BsOverlay.showTimed(
//                               content: const Text(
//                                 '"regular" I am a regular customer I wait on the line',
//                               ),
//                             );
//                           case Priority.ifEmpty:
//                             BsOverlay.showTimed(
//                               content: const Text(
//                                 '"ifEmpty" I have autism I only show a lone',
//                               ),
//                               priority: Priority.ifEmpty,
//                             );
//                           case Priority.noRepeat:
//                             BsOverlay.showTimed(
//                               content: Text(
//                                 '"noRepeat" I can not be repeated ${pi.toStringAsFixed(2)}',
//                               ),
//                               priority: Priority.noRepeat,
//                             );
//                           case Priority.nowNoRepeat:
//                             BsOverlay.showTimed(
//                               content: const Text(
//                                 '"nowNoRepeat" I show now and can not be repeated',
//                               ),
//                               priority: Priority.nowNoRepeat,
//                             );
//                           case Priority.now:
//                             BsOverlay.showTimed(
//                               content: const Text(
//                                 '"now" Arrogantly Showing Now and continue serve the queue',
//                               ),
//                               priority: Priority.now,
//                             );
//                           case Priority.replaceAll:
//                             BsOverlay.showTimed(
//                               priority: Priority.replaceAll,
//                               content: const Text(
//                                 '"replaceAll" The Destroyer show Me and cancel any one else',
//                               ),
//                             );
//
//                           default:
//                             final closeHandler = BsOverlay.show(
//                               showCloseIcon: true,
//                               content: const Text(
//                                 'I do not go until forced to be removed',
//                               ),
//                             );
//
//                             2.seconds.delay.then((value) {
//                               // Toast.show('hapooe');
//                               2.seconds.delay.then((value) {
//                                 closeHandler.call();
//                               });
//                             });
//                         }
//                       },
//                       child: e.name,
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }

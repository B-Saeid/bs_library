// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../Common/constants/global_constants.dart';
// import '../lib/Extensions/on_iterables.dart';
// import '../lib/src/Buttons/buttons.dart';
// import '../lib/src/toast.dart';
//
// class ToastTestWidget extends StatelessWidget {
//   const ToastTestWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Testing Toasts')),
//       body: Center(
//         child: Padding(
//           padding: GlobalConstants.screensHPadding,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: MyPriority.values
//                 .map<Widget>(
//                   (e) => Center(
//                     child: CustomButton(
//                       onPressed: () {
//                         switch (e) {
//                           case MyPriority.regular:
//                             Toast.show(
//                               '"regular" I am a regular customer I wait on the line',
//                               priority: MyPriority.regular,
//                             );
//                           case MyPriority.ifEmpty:
//                             Toast.showSuccess(
//                               '"ifEmpty" I have autism I only show a lone',
//                               priority: MyPriority.ifEmpty,
//                             );
//                           case MyPriority.noRepeat:
//                             Toast.showSuccess(
//                               '"noRepeat" I can not be repeated ${pi.toStringAsFixed(2)}',
//                               priority: MyPriority.noRepeat,
//                             );
//                           case MyPriority.nowNoRepeat:
//                             Toast.showError(
//                               '"nowNoRepeat" I show now and can not be repeated',
//                             );
//                           case MyPriority.now:
//                             Toast.showWarning(
//                               '"now" Arrogantly Showing Now and continue serve the queue',
//                               priority: MyPriority.now,
//                             );
//                           case MyPriority.replaceAll:
//                             Toast.showError(
//                               '"replaceAll" The Destroyer show Me and cancel any one else',
//                               priority: MyPriority.replaceAll,
//                             );
//                           default:
//                             throw UnimplementedError();
//                         }
//                       },
//                       child: e.name,
//                     ),
//                   ),
//                 )
//                 .append(
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: CupertinoTextField(
//                       padding: EdgeInsets.all(10),
//                       placeholder: 'Test open keyboard',
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

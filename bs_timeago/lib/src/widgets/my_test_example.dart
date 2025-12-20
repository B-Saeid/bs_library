// import 'package:flutter/material.dart';
//
// import '../../../../../../Common/widgets/language_button.dart';
// import '../../../../../../Common/widgets/my_timeago.dart';
// import '../../../../../Widgets/cupertino_card.dart';
// import '../../../../Buttons/buttons.dart';
//
// class MyTimeagoTestExample extends StatefulWidget {
//   const MyTimeagoTestExample({super.key});
//
//   @override
//   State<MyTimeagoTestExample> createState() => _MyTimeagoTestExampleState();
// }
//
// class _MyTimeagoTestExampleState extends State<MyTimeagoTestExample> {
//   DateTime time = DateTime.now();
//
//   void addOrSubtract(Duration duration) => setState(
//     () => time = duration.isNegative ? time.subtract(duration.abs()) : time.add(duration),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CupertinoCard(
//           padding: const EdgeInsets.all(20),
//           child: MyTimeago(
//             builder: (context, value) => Text(
//               value,
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             date: time,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20.0),
//           child: Directionality(
//             textDirection: TextDirection.ltr,
//             child: Column(
//               spacing: 10,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(seconds: 1)),
//                       child: const Text('+ 1 sec'),
//                     ),
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(seconds: -1)),
//                       child: const Text('- 1 sec'),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(minutes: 1)),
//                       child: const Text('+ 1 min'),
//                     ),
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(minutes: -1)),
//                       child: const Text('- 1 min'),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(hours: 1)),
//                       child: const Text('+ 1 hour'),
//                     ),
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(hours: -1)),
//                       child: const Text('- 1 hour'),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(days: 1)),
//                       child: const Text('+ 1 day'),
//                     ),
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(days: -1)),
//                       child: const Text('- 1 day'),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(days: 30)),
//                       child: const Text('+ 30 days'),
//                     ),
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(days: -30)),
//                       child: const Text('- 30 days'),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(days: 365)),
//                       child: const Text('+ 365 days'),
//                     ),
//                     CustomButton(
//                       onPressed: () => addOrSubtract(const Duration(days: -365)),
//                       child: const Text('- 365 days'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const LanguageButton(),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../Styles/app_style.dart';
// import 'buttons.dart';
//
// class ButtonsTesting extends ConsumerWidget {
//   const ButtonsTesting({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) => Scaffold(
//     appBar: AppBar(),
//     body: SafeArea(
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomButton(
//               width: double.infinity,
//
//               adaptive: false,
//               // type: CustomButtonType.outlined,
//               // width: 200,
//               // childHeight: null,
//               icon: Icon(AppStyle.icons.play),
//               childPadding: const EdgeInsets.symmetric(
//                 horizontal: 50,
//                 vertical: 10,
//               ),
//               onPressed: () {},
//               // color: AppStyle.colors.adaptiveSpecial(ref),
//               // color: Colors.lime.shade300,
//               // color: Colors.black,
//
//               // textStyle: TextStyle(fontSize: 50),
//               // color: LiveDataOrQuery.themeData(ref:ref,context:context).colorScheme.onPrimary,
//               child: 'Not Adaptive ${'L10nR.tSTART(ref)'}',
//             ),
//             CustomButton(
//               onPressed: () {},
//               type: CustomButtonType.text,
//               // density: CustomButtonDensity.compact,
//               icon: Icon(AppStyle.icons.play),
//               // childPadding: EdgeInsets.symmetric(horizontal: 50),
//               child: 'Custom Text Icon',
//             ),
//             FittedBox(
//               child: Row(
//                 children: [
//                   Column(
//                     spacing: 10,
//                     children: [
//                       CustomButton.basic(
//                         onPressed: () {},
//                         type: CustomButtonType.outlined,
//                         density: CustomButtonDensity.compact,
//                         // textStyle: LiveDataOrQuery.textTheme(ref:ref, context:context).titleLarge,
//                         child: 'Basic Outlined (Tinted)',
//                       ),
//                       CustomButton.basic(
//                         onPressed: () {},
//                         type: CustomButtonType.outlined,
//                         // density: CustomButtonDensity.compact,
//                         // textStyle: LiveDataOrQuery.textTheme(ref:ref, context:context).titleLarge,
//                         child: 'Basic Outlined (Tinted)',
//                       ),
//                       CustomButton.basic(
//                         onPressed: () {},
//                         type: CustomButtonType.outlined,
//                         density: CustomButtonDensity.lossless,
//                         // textStyle: LiveDataOrQuery.textTheme(ref:ref, context:context).titleLarge,
//                         child: 'Basic Outlined (Tinted)',
//                       ),
//                     ],
//                   ),
//                   CustomButton(
//                     type: CustomButtonType.outlined,
//                     // textStyle: LiveDataOrQuery.textTheme(ref:ref, context:context).titleLarge,
//                     textStyle: const TextStyle(color: Colors.greenAccent),
//                     onPressed: () {},
//                     child: 'Not actionable',
//                     childHeight: null,
//                     actionable: false,
//                   ),
//                 ],
//               ),
//             ),
//             CustomButton(
//               onPressed: () {},
//               // childPadding: EdgeInsets.symmetric(horizontal: 50),
//               child: 'L10nR.tSTART(ref)',
//             ),
//             CustomButton(
//               // density: CustomButtonDensity.lossless,
//               childHeight: null,
//               childPadding: const EdgeInsets.symmetric(horizontal: 50),
//               onPressed: () {},
//               fillColor: AppStyle.colors.blueLight,
//               child: 'Dark Background',
//             ),
//             CustomButton(
//               // density: CustomButtonDensity.lossless,
//               childHeight: null,
//               childPadding: const EdgeInsets.symmetric(horizontal: 50),
//               onPressed: () {},
//               fillColor: Colors.greenAccent,
//               child: 'Light Background',
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

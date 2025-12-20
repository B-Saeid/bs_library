import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/riverpod_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'enum.dart';

class MessageWrapper extends StatelessWidget {
  const MessageWrapper({
    super.key,
    required this.toastState,
    this.color,
    required this.message,
  }) : assert(
         message is String || message is ValueNotifier<String>,
         'Message must be String or ValueNotifier<String>',
       );

  final ToastState toastState;
  final Color? color;
  final Object message;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, constraints) => RefWidget(
      (ref) => Container(
        constraints: constraints,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: ShapeDecoration(
          color: color ?? toastState.color(ref),
          shape: const StadiumBorder(),
          shadows: kElevationToShadow[4],
        ),
        child: FittedBox(fit: BoxFit.scaleDown, child: buildText(ref)),
      ),
    ),
  );

  Widget buildText(WidgetRef ref) {
    final message = this.message;
    final style = LiveData.textTheme(
      ref,
    ).bodyMedium!.copyWith(color: (color ?? toastState.color(ref)).invertedBW);

    return switch (message) {
      String() => Text(message, style: style),
      ValueNotifier<String>() => ValueListenableBuilder(
        valueListenable: message,
        builder: (_, value, _) => Text(value, style: style),
      ),
      _ => throw UnimplementedError(),
    };
  }
}

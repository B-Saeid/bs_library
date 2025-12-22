import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/riverpod_widgets.dart';
import 'package:flutter/material.dart';

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
      (ref) {
        final backgroundColor = color ?? toastState.color(ref: ref, context: context);
        return Container(
          constraints: constraints,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: const StadiumBorder(),
            shadows: kElevationToShadow[4],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: buildText(
              style: LiveDataOrQuery.textTheme(ref: ref, context: context).bodyMedium!.copyWith(
                color: backgroundColor.invertedBW, // to make the text always visible
              ),
            ),
          ),
        );
      },
    ),
  );

  Widget buildText({required TextStyle style}) => switch (message) {
    final String text => Text(text, style: style),
    final ValueNotifier<String> notifier => ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, value, _) => Text(value, style: style),
    ),
    _ => throw UnimplementedError(),
  };
}

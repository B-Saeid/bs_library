import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ConsumerOrStatelessBuilder =
    Widget Function(BuildContext context, WidgetRef? ref, Widget? child);

abstract class ConsumerOrStatelessWidget extends StatefulWidget {
  const ConsumerOrStatelessWidget({super.key});

  Widget build(BuildContext context, WidgetRef? ref);

  @override
  // ignore: library_private_types_in_public_api
  _State createState() => _State();
}

class _State extends State<ConsumerOrStatelessWidget> {
  @override
  Widget build(BuildContext context) {
    try {
      ProviderScope.containerOf(context, listen: false);
      return Consumer(builder: (context, ref, child) => widget.build(context, ref));
    } catch (e) {
      return widget.build(context, null);
    }
  }
}

final class ConsumerOrStateless extends ConsumerOrStatelessWidget {
  const ConsumerOrStateless({super.key, required this.builder, this.child});

  final ConsumerOrStatelessBuilder builder;

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    return builder(context, ref, child);
  }
}

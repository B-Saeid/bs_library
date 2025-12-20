import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefWidget extends ConsumerWidget {
  const RefWidget(this.builder, {super.key});

  final Widget Function(WidgetRef ref) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) => builder(ref);
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adaptive/neat_circular_indicator.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    // this.reportError = false,
    this.showToast = false,
  }) : _sliver = false;

  /// Creates a Sliver equivalent of [AsyncValueWidget]
  const AsyncValueWidget.sliver({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    // this.reportError = true,
    this.showToast = true,
  }) : _sliver = true;

  final bool _sliver;
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget Function()? loading;
  final Widget Function(dynamic error, StackTrace stack)? error;

  // final bool reportError;
  final bool showToast;

  @override
  Widget build(BuildContext context) => value.when(
    data: data,
    loading:
        loading ??
        () => _sliver
            ? const SliverToBoxAdapter(child: NeatCircularIndicator())
            : const NeatCircularIndicator(),
    error: (e, st) {
      // if (reportError) {
      //   ErrorMonitorService.report(
      //     error: e,
      //     stack: st,
      //     reason: 'Error in AsyncValueWidget of type ${value.value.runtimeType}',
      //   );
      // }
      // if (showToast) Toast.showError(L10nR.tErrorEncountered());

      if (error != null) return error!(e, st);

      return _sliver ? const SliverToBoxAdapter() : const SizedBox();
    },
  );
}

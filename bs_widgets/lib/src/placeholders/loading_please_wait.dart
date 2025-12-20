import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adaptive/neat_circular_indicator.dart';

class LoadingPleaseWait extends ConsumerWidget {
  const LoadingPleaseWait({super.key, this.title, this.child});

  final Widget? child;
  final StringRef? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title?.call(ref) ?? 'Loading, Please Wait',
        style: LiveData.textTheme(ref).titleLarge,
      ),
      SizedBox(height: 10.scalable(ref, allowBelow: false)),
      const NeatCircularIndicator(),
      if (child != null) ...[
        SizedBox(height: 20.scalable(ref, allowBelow: false)),
        child!,
      ],
    ],
  );
}

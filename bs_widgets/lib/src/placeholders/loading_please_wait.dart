import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adaptive/adaptive_loading_indicator.dart';
import '../riverpod_widgets/consumer_or_stateless.dart';

class LoadingPleaseWait extends ConsumerOrStatelessWidget {
  const LoadingPleaseWait({super.key, this.title, this.child});

  final Widget? child;
  final StringOptionalRef? title;

  @override
  Widget build(BuildContext context, WidgetRef? ref) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title?.call(ref) ?? 'Loading, Please Wait',
        style: LiveDataOrQuery.textTheme(ref: ref, context: context).titleLarge,
      ),
      SizedBox(
        height: 10.scalableFlexible(ref: ref, context: context, allowBelow: false),
      ),
      const AdaptiveLoadingIndicator(),
      if (child != null) ...[
        SizedBox(
          height: 20.scalableFlexible(ref: ref, context: context, allowBelow: false),
        ),
        child!,
      ],
    ],
  );
}

import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralError extends ConsumerWidget {
  const GeneralError({super.key, this.child, required this.title});

  final Widget? child;
  final StringRef? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        AppStyle.icons.report,
        color: Theme.of(context).disabledColor,
        size: 50,
      ),
      SizedBox(height: 10.scalable(ref, allowBelow: false)),
      Text(title?.call(ref) ?? 'Something went wrong'),
      if (child != null) ...[
        SizedBox(height: 20.scalable(ref, allowBelow: false)),
        child!,
      ],
    ],
  );
}

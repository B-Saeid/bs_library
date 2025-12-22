import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoData extends ConsumerWidget {
  const NoData({this.title, super.key});

  final StringRef? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        AppStyle.icons.minusFilled,
        color: Theme.of(context).disabledColor,
        size: 50,
      ),
      SizedBox(
        height: 10.scalableFlexible(ref: ref, context: context, allowBelow: false),
      ),
      Text(
        title?.call(ref) ?? 'No data was found!',
        style: LiveDataOrQuery.textTheme(ref: ref, context: context).titleLarge,
      ),
    ],
  );
}

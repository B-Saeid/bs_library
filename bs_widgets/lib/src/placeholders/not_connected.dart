import 'dart:math';

import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod_widgets/consumer_or_stateless.dart';

class NotConnected extends ConsumerOrStatelessWidget {
  const NotConnected({this.title, super.key});

  final StringOptionalRef? title;

  @override
  Widget build(BuildContext context, WidgetRef? ref) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        children: [
          Icon(
            AppStyle.icons.globe,
            color: Theme.of(context).disabledColor,
            size: 50,
          ),
          Positioned.fill(
            child: Transform.rotate(
              angle: pi / 4,
              child: Divider(
                thickness: 5,
                radius: BorderRadius.circular(2.5),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 10.scalableFlexible(ref: ref, context: context, allowBelow: false),
      ),
      Text(
        title?.call(ref) ?? 'Check your internet connection.',
        style: LiveDataOrQuery.textTheme(ref: ref, context: context).titleLarge,
      ),
    ],
  );
}

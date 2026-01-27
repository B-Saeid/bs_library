import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';

import 'android_action.dart';
import 'ios_action.dart';

class AdaptiveDialogueAction extends StatelessWidget {
  const AdaptiveDialogueAction({
    super.key,
    required this.title,
    required this.onPressed,
    this.encouraged,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool? encouraged;

  @override
  Widget build(BuildContext context) => StaticData.platform.isApple
      ? IOSDialogueAction(
          title: title,
          onPressed: onPressed,
          encouraged: encouraged,
        )
      : AndroidDialogueAction(
          title: title,
          onPressed: onPressed,
          encouraged: encouraged,
        );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod_widgets/consumer_or_stateless.dart';

class IOSDialogueAction extends ConsumerOrStatelessWidget {
  const IOSDialogueAction({
    super.key,
    required this.title,
    required this.onPressed,
    this.encouraged,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool? encouraged;

  @override
  Widget build(BuildContext context, WidgetRef? ref) => CupertinoDialogAction(
    // textStyle: TextStyle(fontFamily: ref.read(stylesProvider).topLevelFamily),
    textStyle: TextStyle(
      color: onPressed == null ? Theme.of(context).disabledColor : null,
      fontFamily: Theme.of(context).textTheme.titleMedium?.fontFamily,
    ),
    onPressed: onPressed,
    isDefaultAction: encouraged == true,
    isDestructiveAction: encouraged == false,
    child: Text(title),
  );
}

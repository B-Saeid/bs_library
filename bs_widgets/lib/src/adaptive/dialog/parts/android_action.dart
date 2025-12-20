import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AndroidDialogueAction extends ConsumerWidget {
  const AndroidDialogueAction({
    super.key,
    required this.title,
    required this.onPressed,
    this.encouraged = true,
  });

  final String title;
  final VoidCallback onPressed;
  final bool encouraged;

  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
    onPressed: onPressed,
    child: Text(
      title,
      style: encouraged
          ? AppStyle.colors.positiveChoiceStyle(ref)
          : AppStyle.colors.negativeChoiceStyle(ref),
    ),
  );
}

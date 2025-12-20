import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cupertino_dialogs.dart';

/// Do not mistaken this with the original [CupertinoActionSheetAction]
///
/// This is a wrapper around it for convenience
class CupertinoSheetAction extends ConsumerWidget {
  const CupertinoSheetAction({
    required this.context,
    required this.title,
    this.style,
    this.onPressed,
    this.destructive = false,
    this.autoDismiss = true,
    super.key,
  }) : _useCustom = false;

  const CupertinoSheetAction.custom({
    required this.context,
    required this.title,
    this.style,
    this.onPressed,
    this.destructive = false,
    this.autoDismiss = true,
    super.key,
  }) : _useCustom = true;

  final bool _useCustom;
  final StringRef title;
  final TextStyle? style;
  final bool destructive;
  final VoidCallback? onPressed;
  final bool autoDismiss;
  final BuildContext context;

  BuildContext get _context => context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: omit_local_variable_types
    VoidCallback onTap = onPressed != null
        ? () {
            if (autoDismiss) Navigator.of(_context).pop();
            onPressed!();
          }
        : Navigator.of(_context).pop;
    final text = Text(
      title(ref),
      style: (style ?? LiveData.textTheme(ref).titleLarge!).copyWith(
        color: destructive ? CupertinoColors.destructiveRed.resolveFrom(context) : null,
      ),
    );
    return _useCustom
        ? CustomCupertinoActionSheetAction(
            onPressed: onTap,
            isDestructiveAction: destructive,
            child: text,
          )
        : CupertinoActionSheetAction(
            onPressed: onTap,
            isDestructiveAction: destructive,
            child: text,
          );
  }
}

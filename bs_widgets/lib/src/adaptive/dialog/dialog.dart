import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'parts/android_action.dart';
import 'parts/ios_action.dart';

export 'parts/adaptive_action.dart';
export 'parts/android_action.dart';
export 'parts/ios_action.dart';

class BsDialogue extends ConsumerWidget {
  const BsDialogue({
    super.key,
    required this.title,
    this.content,
    this.actionTitle,
    this.actionFunction,
    this.dismissTitle,
    this.dismissFunction,
    this.counterRecommended = false,
    this.androidCenterTitle = false,
    this.startCorner,
    this.endCorner,
    this.customAndroidActions,
    this.customIOSActions,
    this.customAdaptiveActions,
  }) : assert(
         title is String || title is Widget,
         'Invalid title type. Must be String or Widget.',
       ),
       assert(
         actionTitle != null ? actionFunction != null : true,
         'You must provide actionFunction when you provide actionTitle',
       );
  final Object title;
  final Object? content;
  final String? actionTitle;
  final VoidCallback? actionFunction;
  final String? dismissTitle;
  final VoidCallback? dismissFunction;
  final bool counterRecommended;
  final Widget? startCorner;
  final Widget? endCorner;
  final List<Widget>? customIOSActions;
  final List<Widget>? customAndroidActions;
  final List<Widget>? customAdaptiveActions;
  final bool androidCenterTitle;

  bool get isApple => StaticData.platform.isApple;

  bool get showAndroidActions => isApple
      ? false
      : dismissTitle != null ||
            actionTitle != null ||
            customAndroidActions != null ||
            customAdaptiveActions != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Title
    final fontFamily = Theme.of(context).textTheme.bodyMedium?.fontFamily;

    var title = this.title is String ? Text(this.title as String) : this.title as Widget;
    title = Padding(
      padding: EdgeInsets.all(
        8.0.delayedScale(ref, startFrom: 1.5, beforeStart: 0.0),
      ),
      child: isApple
          ? DefaultTextStyle.merge(
              style: TextStyle(
                // fontFamily: ref.read(stylesProvider).topLevelFamily,
                fontFamily: fontFamily,
              ),
              child: title,
            )
          : DefaultTextStyle.merge(
              textAlign: androidCenterTitle ? TextAlign.center : null,
              child: title,
            ),
    );
    title = startCorner == null && endCorner == null
        ? title
        : Row(
            children: [
              if (startCorner != null) startCorner!,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: title,
                ),
              ),
              if (endCorner != null) endCorner!,
            ],
          );

    /// Content
    var content = switch (this.content) {
      String() => Text(this.content as String),
      Widget() => this.content as Widget, // there has to be a way to omit "as Widget"
      _ => null,
    };
    if (content != null) {
      content = isApple
          ? Padding(
              padding: EdgeInsets.only(top: 15.scalable(ref)),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontFamily: fontFamily,
                  // fontFamily: ref.read(stylesProvider).topLevelFamily,
                  letterSpacing: 0.5,
                ),
                child: content,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                vertical: 25.scalable(ref, maxFactor: 2),
                horizontal: 15.scalable(ref, maxFactor: 2),
              ),
              child: DefaultTextStyle.merge(
                textAlign: TextAlign.start,
                style: const TextStyle(letterSpacing: 0.5),
                child: content,
              ),
            );
    }

    /// Actions
    void defaultDismiss(BuildContext context) => Navigator.of(context).pop();
    final List<Widget> actions; // could be empty after all, BUT not null.
    if (isApple) {
      actions =
          customIOSActions ??
          customAdaptiveActions ??
          [
            if (dismissTitle != null)
              IOSDialogueAction(
                onPressed: dismissFunction ?? () => defaultDismiss(context),
                encouraged: counterRecommended,
                title: dismissTitle!,
              ),
            if (actionTitle != null)
              IOSDialogueAction(
                onPressed: actionFunction!, // asserted in constructor
                encouraged: !counterRecommended,
                title: actionTitle!,
              ),
          ];
    } else {
      actions =
          customAndroidActions ??
          customAdaptiveActions ??
          [
            if (dismissTitle != null)
              AndroidDialogueAction(
                title: dismissTitle!,
                onPressed: dismissFunction!,
                encouraged: counterRecommended,
              ),
            if (actionTitle != null)
              AndroidDialogueAction(
                title: actionTitle!,
                onPressed: actionFunction!,
                encouraged: !counterRecommended,
              ),
          ];
    }

    return isApple
        ? CupertinoAlertDialog(
            title: title,
            content: content,
            actions: actions,
          )
        : AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: title,
            content: content,
            scrollable: true,
            actions: actions,
          );
  }
}

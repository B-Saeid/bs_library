// TODO : Remove l10n dependency by implementing the strings in FeedbackLocalization
import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:flutter/material.dart';

import '../better_feedback.dart';
import '../l18n/translation.dart';
import '../utilities/back_button_interceptor.dart';

class ConfirmDiscardScrShot extends StatefulWidget {
  const ConfirmDiscardScrShot({super.key});

  static VoidCallback? closeHandler;

  @override
  State<ConfirmDiscardScrShot> createState() => _ConfirmDiscardScrShotState();
}

class _ConfirmDiscardScrShotState extends State<ConfirmDiscardScrShot> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_closeScrShotDiscardConfirm, priority: 1);
  }

  bool _closeScrShotDiscardConfirm() {
    ConfirmDiscardScrShot.closeHandler?.call();
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_closeScrShotDiscardConfirm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(boxShadow: kElevationToShadow[4]),
    child: BsDialogue(
      /// Todo: Add translation
      // title: FeedbackLocalizations.of(context).discardScreenShot,
      title: l10nR.tDiscardScreenShot(),

      /// Todo: Add translation
      // content: FeedbackLocalizations.of(context).discardScreenShotMessage,
      content: l10nR.tDiscardScreenShotMessage(),
      actionTitle: FeedbackLocalizations.of(context).close,
      actionFunction: () {
        BetterFeedback.of(context).hide();
        ConfirmDiscardScrShot.closeHandler?.call();
      },

      /// Todo: Add translation
      // dismissTitle: FeedbackLocalizations.of(context).cancel,
      dismissTitle: l10nR.tCancel(),
      dismissFunction: ConfirmDiscardScrShot.closeHandler,
      counterRecommended: true,
    ),
  );
}

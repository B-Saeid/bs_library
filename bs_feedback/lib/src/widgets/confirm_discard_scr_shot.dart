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
      title: FeedbackLocalizations.of(context).discardScreenShotTitle,
      content: FeedbackLocalizations.of(context).discardScreenShotDescription,
      actionTitle: FeedbackLocalizations.of(context).close,
      actionFunction: () {
        BetterFeedback.of(context).hide();
        ConfirmDiscardScrShot.closeHandler?.call();
      },
      dismissTitle: FeedbackLocalizations.of(context).no,
      dismissFunction: ConfirmDiscardScrShot.closeHandler,
      counterRecommended: true,
    ),
  );
}

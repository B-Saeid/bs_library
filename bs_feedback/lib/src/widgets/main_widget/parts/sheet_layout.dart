part of '../feedback_widget.dart';

class SheetLayout extends StatelessWidget {
  const SheetLayout({
    super.key,
    required this.feedbackBuilder,
    required this.isPaintingActive,
  });

  final FeedbackBuilder? feedbackBuilder;
  final bool isPaintingActive;

  @override
  Widget build(BuildContext context) {
    final hasDrawings = InternalController.painterController.getStepCount() > 0;

    /// This is to make sure that user doesn't discard the drawing by mistake
    final canNotSubmit = hasDrawings && !isPaintingActive;

    /// Keep calling itself,  Buggy, Needs debugging ^^
    // if (canNotSubmit) {
    //   Future(() {
    //     Toast.show(
    //       /// Todo: Add translation
    //       // FeedbackLocalizations.of(context).drawingsAreHiddenShowItOrClearIt,
    //       L10nR.tYouHaveHiddenDrawingsShowOrClear(),
    //       // ignore: use_build_context_synchronously
    //       context: context,
    //     );
    //   });
    // }
    return LayoutId(
      id: _Children.sheet,
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          final current = notification.extent - notification.minExtent;
          InternalController.sheetProgress.value = current / 1;
          return false;
        },
        child: FeedbackBottomSheet(
          key: const Key('feedback_bottom_sheet'),
          onSubmit: canNotSubmit
              ? null
              : (feedback, {extras}) => _onSubmit(
                  context: context,
                  feedback: feedback,
                  extras: extras,
                ),
          sheetProgress: InternalController.sheetProgress,
          feedbackBuilder: feedbackBuilder,
        ),
      ),
    );
  }

  Future<void> _onSubmit({
    required BuildContext context,
    required String? feedback,
    required Map<String, dynamic>? extras,
  }) async {
    FeedbackWidgetState._hideKeyboard(context);

    // var confirmSubmit = true;
    // if (painterController.getStepCount() > 0) {
    //   final discard = await confirmDiscardDrawings();
    //   confirmSubmit = discard ?? false;
    // }
    //
    // if (!confirmSubmit) return;

    await sendFeedback(
      // // ignore: use_build_context_synchronously
      onFeedbackSubmitted: BetterFeedback.of(context).onFeedback!,
      controller: InternalController.screenshotController,
      feedback: feedback,
      // delay: const Duration(milliseconds: 0),
      extras: extras,
    );

    /// Previously, we close the feedback right away
    /// Now, we let the user to choose whether to hide the
    /// feedback or not as it may depend on the success
    /// of the feedback submission.
    InternalController.painterController.clear();
  }

  @visibleForTesting
  static Future<void> sendFeedback({
    required OnFeedbackCallback onFeedbackSubmitted,
    required ScreenshotController controller,
    String? feedback,
    double pixelRatio = 2.0,
    Duration delay = const Duration(milliseconds: 2000),
    Map<String, dynamic>? extras,
  }) async => await Future.delayed(
    // Wait for the keyboard to be closed, and then proceed
    // to take a screenshot
    delay,
    () async {
      // Take high resolution screenshot
      final screenshot = await controller.capture(
        pixelRatio: pixelRatio,
        delay: const Duration(milliseconds: 0),
      );

      // Give it to the developer
      // to do something with it.
      await onFeedbackSubmitted(
        UserFeedback(
          text: feedback,
          screenshot: screenshot,
          extra: extras,
        ),
      );
    },
  );
}

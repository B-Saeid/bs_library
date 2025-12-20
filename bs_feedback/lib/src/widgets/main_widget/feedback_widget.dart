// ignore_for_file: public_member_api_docs

import 'dart:math';
import 'dart:ui';

import 'package:bs_overlay/bs_overlay.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:collection/collection.dart';
// import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../better_feedback.dart';
import '../../constants/constants.dart';
import '../../controllers/internal_controller.dart';
import '../../enums/feedback_mode.dart';
import '../../l18n/translation.dart';
import '../../models/user_feedback.dart';
import '../../theme/feedback_theme.dart';
import '../../utilities/back_button_interceptor.dart';
import '../../utilities/pre_close_checks.dart';
import '../confirm_discard_scr_shot.dart';
import '../drawing_column.dart';
import '../feedback_bottom_sheet.dart';
import '../paint_on_child.dart';
import '../painter.dart';
import '../scale_and_clip.dart';
import '../scale_and_fade.dart';
import '../screenshot.dart';

part 'parts/actions_layout.dart';
part 'parts/app_layout.dart';
part 'parts/drawings_layout.dart';
part 'parts/feedback_layout_delegate.dart';
part 'parts/freeze_icon_layout.dart';
part 'parts/sheet_layout.dart';

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({
    super.key,
    required this.child,
    required this.isFeedbackVisible,
    this.feedbackBuilder,
  });

  final bool isFeedbackVisible;
  final FeedbackBuilder? feedbackBuilder;
  final Widget child;

  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}

@visibleForTesting
class FeedbackWidgetState extends State<FeedbackWidget> with TickerProviderStateMixin {
  bool get isDrawMode => InternalController.state.mode.isDraw;

  PainterController get painterController => InternalController.painterController;

  @override
  void initState() {
    super.initState();
    _initAnimations();

    /// Note: We can't use [BackButtonListener] because it needs
    /// a Router ancestor which is our main app ,that we have here as a child,
    /// So we needed [BackButtonInterceptor] logic to work around that.
    BackButtonInterceptor.add(undoDrawingsOrHideFeedback);

    PreCloseChecks.add(confirmDiscardFreezeFrame);
  }

  late final AnimationController _controller;
  late final Animation<double> _animation;

  late final AnimationController _columnController;
  late final Animation<double> _columnAnimation;

  void _initAnimations() {
    final duration = const Duration(milliseconds: 500);
    _columnController = AnimationController(
      vsync: this,
      duration: duration,
    );
    print('columnController: ${_columnController.value}');
    _columnAnimation = CurvedAnimation(
      parent: _columnController,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeOutCubic,
    );
    print('columnAnimation: ${_columnAnimation.value}');
    print('columnAnimation isDismissed: ${_columnAnimation.isDismissed}');

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    print('controller: ${_controller.value}');
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeOutCubic,
    );
    print('animation: ${_animation.value}');
    print('animation isDismissed: ${_animation.isDismissed}');
  }

  @override
  void dispose() {
    super.dispose();
    _disposeAnimation();
    BackButtonInterceptor.remove(undoDrawingsOrHideFeedback);
    PreCloseChecks.remove(confirmDiscardFreezeFrame);
  }

  void _disposeAnimation() {
    _controller.dispose();
    _columnController.dispose();
  }

  @visibleForTesting
  bool undoDrawingsOrHideFeedback() {
    if (widget.isFeedbackVisible) {
      if (isDrawMode || InternalController.state.freezeImage != null) {
        if (painterController.getStepCount() > 0) {
          painterController.undo();
        } else {
          BetterFeedback.of(context).hide();
        }
      } else {
        BetterFeedback.of(context).hide();
      }
      return true;
    }
    return false;
  }

  bool confirmDiscardFreezeFrame() {
    if (!widget.isFeedbackVisible) return false;

    if (InternalController.state.freezeImage != null) {
      ConfirmDiscardScrShot.closeHandler = BsOverlay.show(
        context: context,
        child: const ConfirmDiscardScrShot(),
      );

      return true;
    } else {
      return false;
    }
  }

  @override
  void didUpdateWidget(FeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // update feedback mode with the initial value
    /// We commented this line since it mistakenly reset the mode
    /// to widget.mode when we open the keyboard .. Don't know why
    /// but it is not hurting anything right now
    // mode = widget.mode;
    print('widget.isFeedbackVisible ${widget.isFeedbackVisible}');
    if (widget.isFeedbackVisible) {
      isDrawMode ? _columnController.forward() : _columnController.reverse();
    }

    void initSheetProgressValue() {
      final initialSheetHeight = FeedbackTheme.of(context).initialSheetHeight;
      final minSheetHeight = FeedbackTheme.of(context).minSheetHeight;
      final endValue = (initialSheetHeight - minSheetHeight) / 1;

      /// In here we put the first parameter as the [sheetProgress.value]
      /// since this is in the initial phase and  [_controller.value] will be increasing
      /// i.e. from [_controller.lowerBound] to [_controller.upperBound]
      /// so that we interpolate to reach the [endValue].
      ///
      /// of course, if we have different bounds for the [_controller] we
      /// would have [lerp] for them as well from 0 to 1 but here It is not needed.
      InternalController.sheetProgress.value = lerpDouble(
        InternalController.sheetProgress.value,
        endValue,
        _animation.value,
      )!;
    }

    /// Here we put the second parameter as the [sheetProgress.value]
    /// as it is in the final phase and [_controller.value] will be decreasing
    /// i.e. from [_controller.upperBound] to [_controller.lowerBound]
    /// so that we interpolate to reach the first parameter which is 0.
    void resetSheetProgressValue() => InternalController.sheetProgress.value = lerpDouble(
      0,
      InternalController.sheetProgress.value,
      _animation.value,
    )!;

    if (oldWidget.isFeedbackVisible != widget.isFeedbackVisible &&
        oldWidget.isFeedbackVisible == false) {
      // Feedback is now visible,
      // start animation to show it.

      /// we also want to update the sheet progress value
      /// smoothly taking advance of the animation controller
      if (FeedbackTheme.of(context).sheetIsDraggable) {
        _controller.addListener(initSheetProgressValue);
        _controller.forward().then(
          (_) => _controller.removeListener(initSheetProgressValue),
        );
      } else {
        _controller.forward();
      }
    }

    if (oldWidget.isFeedbackVisible != widget.isFeedbackVisible &&
        oldWidget.isFeedbackVisible == true) {
      // Feedback is no longer visible,
      // reverse animation to hide it.
      _hideKeyboard(context);
      _beforeClosingFeedback();
      if (FeedbackTheme.of(context).sheetIsDraggable) {
        _controller.addListener(resetSheetProgressValue);
        _controller.reverse().then(
          (_) => _controller.removeListener(resetSheetProgressValue),
        );
      } else {
        /// [sheetProgress.value] was previously set to zero directly as the user had no chance
        /// to exit the feedback until the sheet is snapped to the bottom
        /// ,where the user can tap the close icon, This is not the case now as we do have
        /// controls at the top. The user can tap on close at any point he doesn't have to
        /// drag down the sheet to reach out to the close icon as the sheet now can snap
        /// to [FeedbackTheme.of(context).initialSheetHeight] as well as [.minSheetHeight]
        /// and [.maxSheetHeight]. as before.
        // Reset the sheet progress so the fade is no longer applied.
        InternalController.sheetProgress.value = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) => Material(
    color: FeedbackTheme.of(context).background ?? Theme.of(context).dividerColor,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, screenshotChild) => AnimatedBuilder(
        animation: _columnController,
        builder: (context, child) => Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.viewPaddingOf(context).left,
            0,
            MediaQuery.viewPaddingOf(context).right,
            0,
          ),
          child: CustomMultiChildLayout(
            delegate: _FeedbackLayoutDelegate(
              displayColumn: !_columnAnimation.isDismissed,
              displayFeedback: !_animation.isDismissed,
              query: MediaQuery.of(context),
              sheetFraction: FeedbackTheme.of(context).sheetIsDraggable
                  ? (FeedbackTheme.of(context).minSheetHeight)
                  : null,
              openingProgress: _animation.value,
              drawingColumnProgress: _columnAnimation.value,
            ),

            /// The order in [children] represents the ascending Z index.
            children: [
              if (!_animation.isDismissed && _columnAnimation.value < 1)
                FreezeIconLayout(
                  drawingColumnProgress: _columnAnimation.value,
                ),

              /// This sets here all the time your app is running
              AppLayout(
                app: screenshotChild!,
                openingAnimation: _animation,
              ),
              if (!_columnAnimation.isDismissed)
                DrawingsLayout(
                  columnAnimation: _columnAnimation,
                ),
              if (!_animation.isDismissed)
                ActionsLayout(
                  columnController: _columnController,
                ),
              if (!_animation.isDismissed)
                ValueListenableBuilder(
                  valueListenable: InternalController.instance,
                  builder: (_, internalState, _) => SheetLayout(
                    feedbackBuilder: widget.feedbackBuilder,
                    isPaintingActive: _isPaintingActive(internalState),
                  ),
                ),
            ],
          ),
        ),
      ),

      /// Placing the screenshot in the child attribute so that
      /// the widget tree isn't being arbitrarily rebuilt.
      child: Screenshot(
        child: ValueListenableBuilder(
          valueListenable: InternalController.instance,
          builder: (_, internalState, child) => PaintOnChild(
            controller: painterController,
            isPaintingActive: _isPaintingActive(internalState),
            child: Stack(
              children: [
                child!,
                if (internalState.freezeImage != null)
                  Positioned.fill(
                    child: Image.memory(internalState.freezeImage!),
                  ),
              ],
            ),
          ),
          child: widget.child,
        ),
      ),
    ),
  );

  bool _isPaintingActive(InternalState internalState) =>
      widget.isFeedbackVisible && (internalState.freezeImage != null || internalState.mode.isDraw);

  /// Helpers
  static void _hideKeyboard(BuildContext context) =>
      /// A provoking q: is there a better way to hide the keyboard ?
      /// as this creates a new [FocusNode] and ,as far as I can tell, it is not disposed
      /// ain't that a memory leak?
      FocusScope.of(context).requestFocus(FocusNode());

  void _beforeClosingFeedback() {
    InternalController.instance.update(
      freezeImage: null,
      freezeIcon: AppStyle.icons.camera,
      closing: true,
    );

    if (isDrawMode) _columnController.reverse();

    Future.delayed(
      const Duration(seconds: 1),
      () => InternalController.instance.updateClosing(false),
    );
  }
}

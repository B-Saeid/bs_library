// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:flutter/material.dart';

import '../better_feedback.dart';
import '../builders/string_feedback.dart';
import '../theme/feedback_theme.dart';
import '../utilities/back_button_interceptor.dart';

/// Shows the text input in which the user can describe his feedback.
class FeedbackBottomSheet extends StatelessWidget {
  const FeedbackBottomSheet({
    super.key,
    required this.feedbackBuilder,
    required this.onSubmit,
    required this.sheetProgress,
  });

  final FeedbackBuilder? feedbackBuilder;
  final OnSubmit? onSubmit;
  final ValueNotifier<double> sheetProgress;

  @override
  Widget build(BuildContext context) {
    final theme = FeedbackTheme.of(context);
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final topPadding = MediaQuery.viewPaddingOf(context).top;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return theme.sheetIsDraggable
        ? DraggableScrollableActuator(
            child: _DraggableFeedbackSheet(
              feedbackBuilder: feedbackBuilder ?? StringFeedback.builder,
              onSubmit: onSubmit,
              sheetProgress: sheetProgress,
            ),
          )
        : ConstrainedBox(
            constraints: BoxConstraints.loose(
              Size.fromHeight(
                (screenHeight - topPadding - keyboardHeight) * (keyboardHeight > 0 ? 0.9 : 0.6),
              ),
            ),
            child: Material(
              color: theme.feedbackSheetColor ?? Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: _buildChild(context),
            ),
          );
  }

  Widget _buildChild(BuildContext context) =>
      feedbackBuilder?.call(context, onSubmit) ?? StringFeedback.builder(context, onSubmit);
}

class _DraggableFeedbackSheet extends StatefulWidget {
  const _DraggableFeedbackSheet({
    required this.feedbackBuilder,
    required this.onSubmit,
    required this.sheetProgress,
  });

  final FeedbackBuilder feedbackBuilder;
  final OnSubmit? onSubmit;
  final ValueNotifier<double> sheetProgress;

  @override
  State<_DraggableFeedbackSheet> createState() => _DraggableFeedbackSheetState();
}

class _DraggableFeedbackSheetState extends State<_DraggableFeedbackSheet> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_sheetMinimize, priority: 3);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_sheetMinimize);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackTheme = FeedbackTheme.of(context);
    final query = MediaQuery.of(context);
    // We need to recalculate the the height fractions to account for the safe area
    // at the top and the keyboard (if present).
    final keyboardHeight = query.viewInsets.bottom;
    final safeScrHeight = query.size.height - query.viewPadding.top;
    // final keyboardFactor = screenHeight / (screenHeight - keyboardHeight);
    final keyboardFraction = keyboardHeight / safeScrHeight;
    final maxHeight = min(
      1.0,
      feedbackTheme.maxSheetHeight + keyboardFraction,
    );

    final initialHeight = min(
      maxHeight,
      feedbackTheme.initialSheetHeight + keyboardFraction,
    );

    /// We do this especially for the [minHeight], as it is not convenient to have the
    /// [DraggableScrollableSheet] minimized when the keyboard is present. So besides it
    /// being added to [keyboardFraction] it should also be elevated up a bit
    /// when the keyboard is present which is done by multiplying it by [keyboardFactor].
    ///
    /// Now we have [minHeight] always <= [initialHeight] i.e. no errors
    /// and >= [initialHeightFactored] ,i.e. not minimized, when the keyboard is present.
    final keyboardFactor = safeScrHeight / (safeScrHeight - keyboardHeight);
    final minHeightFactored = feedbackTheme.minSheetHeight * keyboardFactor;
    final initialHeightFactored = feedbackTheme.initialSheetHeight * keyboardFactor;
    final minHeight = min(
      initialHeight,
      min(
        initialHeightFactored,
        minHeightFactored + keyboardFraction,
      ),
    );
    return SizedBox(
      height: safeScrHeight - keyboardHeight,
      child: DraggableScrollableSheet(
        controller: BetterFeedback.of(context).sheetController,
        snap: true,
        snapSizes: [
          initialHeight,
        ],
        // expand: false,
        minChildSize: minHeight,
        initialChildSize: initialHeight,
        maxChildSize: maxHeight,
        builder: (context, scrollController) => ValueListenableBuilder(
          valueListenable: widget.sheetProgress,
          builder: (context, _, child) => ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15 * (1 - widget.sheetProgress.value)),
            ),
            child: child,
          ),
          child: Material(
            color: FeedbackTheme.of(context).feedbackSheetColor ?? Theme.of(context).canvasColor,
            // A `ListView` makes the content here disappear.
            child: DefaultTextEditingShortcuts(
              child: widget.feedbackBuilder(
                context,
                widget.onSubmit,
                scrollController: scrollController,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _sheetMinimize() {
    final initialSheetHeight = FeedbackTheme.of(context).initialSheetHeight;
    final minSheetHeight = FeedbackTheme.of(context).minSheetHeight;
    final endValue = (initialSheetHeight - minSheetHeight) / 1;

    if (widget.sheetProgress.value > endValue) {
      BetterFeedback.of(context).sheetController.animateTo(
        endValue,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
      );
      // widget.sheetProgress.value = endValue;
      return true;
    }
    return false;
  }
}

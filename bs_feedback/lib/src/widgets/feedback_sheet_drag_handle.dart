import 'package:flutter/material.dart';

import '../theme/feedback_theme.dart';

/// A drag handle to be placed at the top of a draggable feedback sheet.
///
/// This is a purely visual element that communicates to users that the sheet
/// can be dragged to expand it.
///
/// It should be placed in a stack over the sheet's scrollable element so that
/// users can click and drag on it-the drag handle ignores pointers so the drag
/// will pass through to the scrollable beneath.
class FeedbackSheetDragHandle extends StatelessWidget {
  /// Create a drag handle.
  const FeedbackSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final feedbackTheme = FeedbackTheme.of(context);
    return IgnorePointer(
      child: Container(
        height: 4 + 16 * 2,
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        color: feedbackTheme.feedbackSheetColor ?? Theme.of(context).canvasColor,
        child: Container(
          height: 4,
          width: 32,
          decoration: BoxDecoration(
            color: feedbackTheme.dragHandleColor ?? Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}

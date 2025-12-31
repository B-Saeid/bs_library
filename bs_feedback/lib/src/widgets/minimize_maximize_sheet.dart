import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/adaptive_button.dart';
import 'package:flutter/material.dart';

import '../better_feedback.dart';
import '../controllers/internal_controller.dart';
import '../theme/feedback_theme.dart';

class MinimizeMaximizeSheet extends StatefulWidget {
  const MinimizeMaximizeSheet({super.key});

  @override
  State<MinimizeMaximizeSheet> createState() => _MinimizeMaximizeSheetState();
}

class _MinimizeMaximizeSheetState extends State<MinimizeMaximizeSheet> {
  var _isMin = false;
  var _isMax = false;

  @override
  void initState() {
    super.initState();
    InternalController.sheetProgress.addListener(_sheetProgressListener);
  }

  @override
  void dispose() {
    InternalController.sheetProgress.removeListener(_sheetProgressListener);
    super.dispose();
  }

  void _sheetProgressListener() {
    final min = FeedbackTheme.of(context).minSheetHeight;
    final progress = InternalController.sheetProgress.value + min;
    final initial = FeedbackTheme.of(context).initialSheetHeight;
    final max = FeedbackTheme.of(context).maxSheetHeight;
    if (progress == initial) {
      setState(() {
        _isMax = false;
        _isMin = false;
      });
    } else if (progress == max) {
      setState(() {
        _isMax = true;
        _isMin = false;
      });
    } else if (progress == min) {
      setState(() {
        _isMax = false;
        _isMin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedbackTheme = FeedbackTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: feedbackTheme.feedbackSheetColor ?? Theme.of(context).canvasColor,
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          AdaptiveIconButton(
            type: AdaptiveIconButtonType.filled,
            iconData: AppStyle.icons.arrowUp,
            onPressed: _isMax ? null : maximize,
          ),
          AdaptiveIconButton(
            type: AdaptiveIconButtonType.filled,
            iconData: AppStyle.icons.arrowDown,
            onPressed: _isMin ? null : minimize,
          ),
        ],
      ),
    );
  }

  void minimize() {
    var theme = FeedbackTheme.of(context);
    final initialSheetHeight = theme.initialSheetHeight;
    final minSheetHeight = theme.minSheetHeight;

    BetterFeedback.of(context).sheetController.animateTo(
      _isMax ? initialSheetHeight : minSheetHeight,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutCubic,
    );
  }

  void maximize() {
    var theme = FeedbackTheme.of(context);
    final initialSheetHeight = theme.initialSheetHeight;
    final maxSheetHeight = theme.maxSheetHeight;

    BetterFeedback.of(context).sheetController.animateTo(
      _isMin ? initialSheetHeight : maxSheetHeight,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutCubic,
    );
  }
}

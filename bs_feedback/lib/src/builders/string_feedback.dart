import 'dart:math';

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:flutter/material.dart';

import '../better_feedback.dart';
import '../l18n/translation.dart';
import '../theme/feedback_theme.dart';
import '../widgets/feedback_sheet_drag_handle.dart';
import '../widgets/minimize_maximize_sheet.dart';

/// A form that prompts the user for feedback with a single text field.
/// This is the default feedback widget used by [BetterFeedback].
class StringFeedback extends StatefulWidget {
  /// Create a [StringFeedback].
  /// This is the default feedback bottom sheet, which is presented to the user.
  const StringFeedback({
    super.key,
    required this.onSubmit,
    this.scrollController,
  });

  /// Should be called when the user taps the submit button.
  final OnSubmit? onSubmit;

  /// A scroll controller that expands the sheet when it's attached to a
  /// scrollable widget and that widget is scrolled.
  ///
  /// Non null if the sheet is draggable.
  /// See: [FeedbackThemeData.sheetIsDraggable].
  final ScrollController? scrollController;

  static Widget builder(
    BuildContext context,
    OnSubmit? onSubmit, {
    ScrollController? scrollController,
  }) => StringFeedback(
    onSubmit: onSubmit,
    scrollController: scrollController,
  );

  @override
  State<StringFeedback> createState() => _StringFeedbackState();
}

class _StringFeedbackState extends State<StringFeedback> {
  late TextEditingController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FeedbackTheme.of(context);
    if ((widget.scrollController != null)) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          max(16, MediaQuery.viewPaddingOf(context).left),
          0,
          max(16, MediaQuery.viewPaddingOf(context).right),
          0,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              controller: widget.scrollController,
              children: [
                Visibility.maintain(
                  visible: false,
                  child: StaticData.platform.isMobile
                      ? const FeedbackSheetDragHandle()
                      : const MinimizeMaximizeSheet(),
                ),
                _InputField(theme: theme, controller: controller),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: StaticData.platform.isMobile
                  ? const FeedbackSheetDragHandle()
                  : const MinimizeMaximizeSheet(),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                /// This is to enable the sheet to be draggable from the horizontal area
                /// surrounded by the submit button and also to make it feel as it is
                /// scrolled under avoiding the inconvenient overlapping.
                IgnorePointer(
                  child: ColoredBox(
                    color: theme.feedbackSheetColor ?? Theme.of(context).canvasColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility.maintain(
                          visible: false,
                          child: _buildButton(context),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildButton(context),
              ],
            ),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _InputField(theme: theme, controller: controller),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                _SubmitButton(
                  onSubmit: widget.onSubmit,
                  controller: controller,
                ),
                const Spacer(),
              ],
            ),
            SizedBox(
              height: max(
                20,
                MediaQuery.of(context).padding.bottom,
              ),
            ),
          ],
        ),
      );
    }
  }

  Padding _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: max(20, MediaQuery.of(context).viewPadding.bottom),
      ),
      child: _SubmitButton(
        onSubmit: widget.onSubmit,
        controller: controller,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.onSubmit,
    required this.controller,
  });

  final OnSubmit? onSubmit;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => AdaptiveButton(
    key: const Key('submit_feedback_button'),
    onPressed: onSubmit == null ? null : () => onSubmit!(controller.text),
    child: Text(
      FeedbackLocalizations.of(context).submitButtonText,
      style: TextStyle(
        color: FeedbackTheme.of(context).activeFeedbackModeColor,
      ),
    ),
  );
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.theme,
    required this.controller,
  });

  final FeedbackThemeData theme;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextField(
    style: theme.inputStyle,
    key: const Key('text_input_field'),
    maxLines: theme.maxFeedbackLines,
    controller: controller,
    decoration:
        theme.inputDecoration ??
        InputDecoration(
          border: const OutlineInputBorder(),
          hintText: FeedbackLocalizations.of(context).inputHintText,
          hintStyle: theme.inputHintStyle,
          suffixIcon: IconButton(
            icon: Icon(AppStyle.icons.clear),
            onPressed: controller.clear,
          ),
        ),
    textInputAction: TextInputAction.done,
    onChanged: (value) {
      print(value);
    },
  );
}

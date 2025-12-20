part of '../feedback_widget.dart';

class ActionsLayout extends StatelessWidget {
  const ActionsLayout({
    super.key,
    required this.columnController,
  });

  final AnimationController columnController;

  /// Actions Segmented Button
  double get _groupValue => _Actions.groupValue(InternalController.state.mode);

  @override
  Widget build(BuildContext context) => LayoutId(
    id: _Children.actions,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: FeedbackC.defaultPadding),
      child: Directionality(
        /// This is to make [draw] action always on the right
        textDirection: TextDirection.ltr,
        child: ValueListenableBuilder(
          valueListenable: InternalController.instance,
          builder: (_, internalState, _) => AdaptiveSegmentedActions<double>(
            actions: _Actions.values
                .map(
                  (action) => SegmentedAction(
                    label: Text(action.text(context)),
                    icon: Icon(action.iconData),
                    value: action.orderKey,
                  ),
                )
                .toList(),
            onSelectionChanged: (value) => _onActionSelected(context, value),
            groupValue: internalState.closing ? null : _groupValue,
          ),
        ),
      ),
    ),
  );

  bool get isDrawMode => InternalController.state.mode.isDraw;

  Future<void> _onActionSelected(BuildContext context, double? value) async {
    final action = _Actions.fromOrderKey(value);
    switch (action) {
      case _Actions.navigate:
        if (isDrawMode) InternalController.instance.updateMode(FeedbackMode.navigate);
        columnController.reverse();
        FeedbackWidgetState._hideKeyboard(context);
      case _Actions.draw:
        if (!isDrawMode) InternalController.instance.updateMode(FeedbackMode.draw);
        columnController.forward();
        FeedbackWidgetState._hideKeyboard(context);
      case _Actions.close:
        final holdYourHorses = PreCloseChecks.runChecks();
        // 'holdYourHorses = $holdYourHorses'.tLog();
        if (!holdYourHorses) BetterFeedback.of(context).hide();
      case null:
        break;
    }
  }
}

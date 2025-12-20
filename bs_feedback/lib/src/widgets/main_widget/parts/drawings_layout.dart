part of '../feedback_widget.dart';

class DrawingsLayout extends StatelessWidget {
  const DrawingsLayout({
    super.key,
    required this.columnAnimation,
  });

  final Animation<double> columnAnimation;

  @override
  Widget build(BuildContext context) => LayoutId(
    id: _Children.drawings,
    child: ScaleAndFade(
      progress: InternalController.sheetProgress,
      minScale: .7,
      child: Padding(
        padding: const EdgeInsets.only(right: FeedbackC.defaultPadding),
        child: ScaleTransition(
          scale: columnAnimation,
          child: ListenableBuilder(
            listenable: InternalController.painterController,
            builder: (context, _) => DrawingColumn(
              activeColor: InternalController.painterController.drawColor,
              colors: FeedbackC.drawColors,
              onColorChanged: (color) {
                InternalController.painterController.drawColor = color;
                FeedbackWidgetState._hideKeyboard(context);
              },
              onUndo: InternalController.painterController.getStepCount() > 0
                  ? () {
                      InternalController.painterController.undo();
                      FeedbackWidgetState._hideKeyboard(context);
                    }
                  : null,
              onClearDrawing: InternalController.painterController.getStepCount() > 0
                  ? () {
                      InternalController.painterController.clear();
                      FeedbackWidgetState._hideKeyboard(context);
                    }
                  : null,
            ),
          ),
        ),
      ),
    ),
  );
}

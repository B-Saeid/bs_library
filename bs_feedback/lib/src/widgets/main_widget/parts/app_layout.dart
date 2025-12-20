part of '../feedback_widget.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    required this.openingAnimation,
    required this.app,
  });

  final Animation<double> openingAnimation;
  final Widget app;

  @override
  Widget build(BuildContext context) => LayoutId(
    id: _Children.app,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: FeedbackC.defaultPadding),
      child: ScaleAndFade(
        progress: InternalController.sheetProgress,
        minScale: .7,
        // If opacity reaches zero, flutter will stop
        // drawing the child widget which breaks the
        // screenshot.
        minOpacity: .01,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = MediaQuery.of(context).size;
            return OverflowBox(
              // Allow the screenshot to overflow to the full
              // screen size and then scale it down to meet
              // it's parent's constraints.
              maxWidth: size.width,
              maxHeight: size.height,
              child: ScaleAndClip(
                progress: openingAnimation.value,
                // Scale down to fit the constraints.
                // `_FeedbackLayoutDelegate` ensures that the
                // constraints are the same aspect ratio as
                // the query size.
                scaleFactor: constraints.maxWidth / size.width,
                child: app,
                // child: LayoutBuilder(
                //   builder: (_, __) => screenshotChild!,
                // ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

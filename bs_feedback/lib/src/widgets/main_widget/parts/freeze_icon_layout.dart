part of '../feedback_widget.dart';

class FreezeIconLayout extends StatelessWidget {
  const FreezeIconLayout({
    super.key,
    required this.drawingColumnProgress,
  });

  final double drawingColumnProgress;

  @override
  Widget build(BuildContext context) => LayoutId(
    id: _Children.freezeIcon,
    child: ScaleAndFade(
      progress: InternalController.sheetProgress,
      child: Transform.scale(
        scale: 1 - drawingColumnProgress,
        child: ValueListenableBuilder(
          valueListenable: InternalController.instance,

          /// The worst thing in here is that whenever a change happens
          /// even if it is not related to the freeze icon, the widget
          /// rebuilds. We could use riverpod or provider packages to take advantage
          /// of the selection upon which change triggers the rebuild, but we wanted to
          /// make the feedback component independent of those packages.
          builder: (context, internalState, _) => Stack(
            alignment: Alignment.center,
            children: [
              Visibility.maintain(
                visible: internalState.freezeIcon != null,
                child: AdaptiveIconButton(
                  type: AdaptiveIconButtonType.tinted,
                  onPressed: () => internalState.freezeIcon != null ? _toggleFreeze(context) : null,
                  child: Icon(internalState.freezeIcon),
                ),
              ),
              if (internalState.freezeIcon == null) const AdaptiveLoadingIndicator(),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _toggleFreeze([BuildContext? context]) async {
    final icon = InternalController.state.freezeIcon;
    InternalController.instance.updateFreezeIcon(null);

    if (icon == AppStyle.icons.camera) {
      /// Take ScreenShot
      final image = await InternalController.screenshotController.capture(
        delay: Duration.zero,
        pixelRatio: 5,
      );

      /// This solves a bug when we close the feedback right after
      /// we tap on the freeze icon i.e. the screenshot has not been taken yet
      /// then the freeze frame is set, leaving the user with a DEAD app,
      /// as they don't know that the screenshot is holding the app freezed.
      ///
      /// So we return if the context is not mounted
      /// i.e. the feedback is not visible.
      ///
      /// This can also happens when rapidly change to draw mode
      /// after tapping the icon.
      if ((context?.mounted ?? false) == false) {
        InternalController.instance.updateFreezeIcon(icon);
        return;
      }

      InternalController.instance.update(
        freezeImage: image,
        freezeIcon: AppStyle.icons.play,
      );

      BackButtonInterceptor.add(_resetFreezeFrame, priority: 4);
    } else {
      _resetFreezeFrame();
    }
  }

  bool _resetFreezeFrame() {
    InternalController.instance.update(
      freezeImage: null,
      freezeIcon: AppStyle.icons.camera,
    );

    BackButtonInterceptor.remove(_resetFreezeFrame);
    return true;
  }
}

import 'dart:typed_data';

import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../enums/feedback_mode.dart';
import '../widgets/painter.dart';
import '../widgets/screenshot.dart';

class InternalController extends ValueNotifier<InternalState> {
  InternalController._() : super(InternalState._(freezeIcon: AppStyle.icons.camera));

  static final InternalController instance = InternalController._();

  static InternalState get state => instance.value;

  // T O D O: DONE! replace `sheetProgress` with a direct reference to
  //   `DraggableScrollableController` when the latter gets into production.
  //   See: https://github.com/flutter/flutter/pull/135366.
  // ignore: avoid_public_notifier_properties
  static final ValueNotifier<double> sheetProgress = ValueNotifier(0.0);

  // @visibleForTesting
  static final PainterController painterController = _createPainter();

  static final ScreenshotController screenshotController = ScreenshotController();

  static PainterController _createPainter() {
    final controller = PainterController();

    /// Todo: Later on Have a UI to set this thickness
    controller.thickness = 5.0;
    controller.drawColor = FeedbackC.drawColors[0];
    return controller;
  }

  void updateMode(FeedbackMode mode) => value = InternalState._(
    mode: mode,
    freezeIcon: value.freezeIcon,
    freezeImage: value.freezeImage,
    closing: value.closing,
  );

  void updateClosing(bool closing) => value = InternalState._(
    closing: closing,
    freezeIcon: value.freezeIcon,
    freezeImage: value.freezeImage,
    mode: value.mode,
  );

  void updateFreezeIcon(IconData? freezeIcon) => value = InternalState._(
    freezeIcon: freezeIcon,
    freezeImage: value.freezeImage,
    mode: value.mode,
    closing: value.closing,
  );

  void update({
    FeedbackMode? mode,
    bool? closing,
    required IconData? freezeIcon,
    required Uint8List? freezeImage,
  }) => value = InternalState._(
    mode: mode ?? value.mode,
    closing: closing ?? value.closing,
    freezeIcon: freezeIcon,
    freezeImage: freezeImage,
  );
}

class InternalState {
  InternalState._({
    this.freezeIcon,
    this.mode = FeedbackMode.navigate,
    this.closing = false,
    this.freezeImage,
  });

  final FeedbackMode mode;

  final bool closing;

  final IconData? freezeIcon;

  final Uint8List? freezeImage;

  @override
  bool operator ==(covariant InternalState other) =>
      identical(this, other) ||
      (runtimeType == other.runtimeType &&
          mode == other.mode &&
          closing == other.closing &&
          freezeImage == other.freezeImage &&
          freezeIcon == other.freezeIcon);

  @override
  int get hashCode => Object.hashAll([mode, closing, freezeImage, freezeIcon]);

  @override
  String toString() =>
      '''
    InternalState(
      mode: $mode,
      closing: $closing,
      freezeImage: ${freezeImage?.isEmpty ?? true ? 'null' : 'Image exists'},
      freezeIcon: $freezeIcon,
    ),
  ''';
}

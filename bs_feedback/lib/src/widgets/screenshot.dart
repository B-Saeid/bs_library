// ignore_for_file: public_member_api_docs
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../controllers/internal_controller.dart';

class ScreenshotController {
  final GlobalKey _containerKey = GlobalKey();

  Future<Uint8List> capture({
    double pixelRatio = 1,
    Duration delay = const Duration(milliseconds: 20),
  }) async {
    //Delay is required. See Issue https://github.com/flutter/flutter/issues/22308
    // read it: It also hints:
    /// If the button would be outside the RenderRepaintBoundary the delay shouldn't be necessary.
    /// I guess that why the maintainer passed const Duration(milliseconds: 0) in the call.
    final renderObject = _containerKey.currentContext?.findRenderObject();

    if (renderObject is! RenderRepaintBoundary) {
      FlutterError.reportError(_noRenderObject());
      throw Exception('Could not take screenshot');
    } else {
      final image = await renderObject.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      print('image size = ${(bytes.lengthInBytes / 1024).toStringAsFixed(2)} KB');
      return bytes;
    }
  }

  FlutterErrorDetails _noRenderObject() => FlutterErrorDetails(
    exception: Exception(
      '_containerKey.currentContext is null. '
      'Thus we can\'t create a screenshot',
    ),
    library: 'feedback',
    context: ErrorDescription(
      'Tried to find a context to use it to create a screenshot',
    ),
  );
}

class Screenshot extends StatelessWidget {
  const Screenshot({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    key: InternalController.screenshotController._containerKey,
    child: child,
  );
}

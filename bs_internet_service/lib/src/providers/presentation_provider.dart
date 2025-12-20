import 'package:bs_toast/bs_toast.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'presentation_provider.g.dart';

@Riverpod(keepAlive: true)
InternetPresentationBase internetPresentation(Ref ref) => const _DefaultPresentation();

abstract class InternetPresentationBase {
  const InternetPresentationBase();

  String get connectedString => 'Connected to Internet';

  /// Will be called when connected to internet for the first time
  void Function(Ref, BuildContext?) get onConnected => (ref, context) {};

  String get disconnectedString => 'Internet Disconnected';

  /// Will be called when the internet connection is lost
  void Function(Ref, BuildContext?) get onDisconnected => (ref, context) {
    Toast.showError(disconnectedString, context: context);
  };

  /// Will be called when the internet connection is reconnected AFTER a disconnection.
  void Function(Ref, BuildContext?) get onReconnected => (ref, context) {
    Toast.showSuccess(connectedString, context: context);
  };
}

class _DefaultPresentation extends InternetPresentationBase {
  const _DefaultPresentation();
}

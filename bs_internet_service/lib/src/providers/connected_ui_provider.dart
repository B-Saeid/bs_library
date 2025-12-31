import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../service.dart';
import 'presentation_provider.dart';

part 'connected_ui_provider.g.dart';

/// A Provider that returns a boolean value based on the internet connection
/// There is a global Singleton-Configured Presentation Logic that will be
/// called per listener e.g. a Widget that cares for internet connection.
///
///
/// Q: Why we pass an optional BuildContext?
///
/// A: For showing connection-indicating overlays.
///
/// Since we use a [globalNavigatorKey] ,that is set in our router
/// in [RoutesBase], we have a couple of use cases:
///   I.  Under [RoutesBase.router] i.e. the normal app.
///   II. Above [RoutesBase.router] e.g. a wrapping feedback flow.
///
/// Either ways, overlays are presented by [BsOverlay], that uses
/// [RoutesBase.globalNavigatorKey] by default, if no context is passed,
/// which is fine for case I.
///
/// But in case II, In order for overlays to be properly shown
/// above the entire app, [BuildContext] from such app-wrapping
/// flows is necessary to be passed because otherwise the overlays
/// will be shown inside the app and not above it, which is not intended.
@riverpod
class IsConnectedWithUI extends _$IsConnectedWithUI {
  @override
  // ignore: avoid_build_context_in_providers
  bool? build([BuildContext? context]) {
    ref.onAddListener(() => Internet.addListener(_updateSelf));

    ref.onRemoveListener(() => Internet.removeListener(_updateSelf));

    // ignore: use_build_context_synchronously
    if (ref.isFirstBuild && ref.mounted) Future(() => _presentationLogic(ref, context));

    return Internet.connected;
  }

  static bool _previouslyDisconnected = false;

  static void _presentationLogic(Ref ref, [BuildContext? context]) {
    if (Internet.connected ?? true) {
      ref.read(internetPresentationProvider).onConnected(ref, context);

      if (_previouslyDisconnected) {
        ref.read(internetPresentationProvider).onReconnected(ref, context);
        _previouslyDisconnected = false;
      }
    } else {
      _previouslyDisconnected = true;
      ref.read(internetPresentationProvider).onDisconnected(ref, context);
    }
  }

  void _updateSelf() {
    state = Internet.connected;
    if (ref.mounted) _presentationLogic(ref, context);
  }

  @override
  set state(bool? newValue) {
    if (state == newValue) return;
    super.state = newValue;
  }
}

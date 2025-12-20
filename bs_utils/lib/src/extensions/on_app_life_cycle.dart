import 'dart:ui';

extension AppLifecycleExtension on AppLifecycleState {
  bool get isResumed => this == AppLifecycleState.resumed;

  bool get isPaused => this == AppLifecycleState.paused;

  bool get isDetached => this == AppLifecycleState.detached;

  bool get isHidden => this == AppLifecycleState.hidden;

  bool get isInactive => this == AppLifecycleState.inactive;
}

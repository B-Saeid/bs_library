import 'package:flutter/material.dart';

/// Internal class that holds each [OverlayEntry]
/// information and identifier.
class Entry {
  Entry({
    required this.id,
    required this.uuid,
    required this.entry,
    this.duration,
    this.onDismiss,
  });

  final int id;
  final String uuid;
  final OverlayEntry entry;
  final Duration? duration;
  final ValueSetter<bool>? onDismiss;

  Future<void> Function()? animatedHide;

  @override
  bool operator ==(covariant Entry other) => identical(this, other) || other.uuid == uuid;

  @override
  int get hashCode => uuid.hashCode;
}

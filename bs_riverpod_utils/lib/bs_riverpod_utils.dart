import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// Convenience extension that allows non-watching operations
/// on providers using context
extension Context on BuildContext {
  T read<T>(ProviderListenable<T> p) => ProviderScope.containerOf(this, listen: false).read(p);

  void invalidate<T>(ProviderBase<T> p) =>
      ProviderScope.containerOf(this, listen: false).invalidate(p);

  T refresh<T>(ProviderBase<T> p) => ProviderScope.containerOf(this, listen: false).refresh(p);
}

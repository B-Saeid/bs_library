import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../service.dart';

part 'connected_provider.g.dart';

@Riverpod(keepAlive: true)
class IsConnected extends _$IsConnected {
  @override
  bool? build() {
    ref.onAddListener(() {
      if (!_listenerAdded) {
        _listenerAdded = true;
        Internet.addListener(_updateSelf);
      }
    });

    ref.onCancel(() {
      Internet.removeListener(_updateSelf);
      _listenerAdded = false;
    });

    return Internet.connected;
  }

  static bool _listenerAdded = false;

  void _updateSelf() => state = Internet.connected;

  @override
  set state(bool? newValue) {
    if (state == newValue) return;
    super.state = newValue;
  }
}
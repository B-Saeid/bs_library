import 'dart:async';

import 'package:bs_internet_checker/bs_internet_checker.dart';
import 'package:flutter/material.dart';

abstract final class Internet {
  static final _instance = BsInternetChecker();

  static void updateCheckerConfig({
    Duration? checkTimeout,
    Duration? checkInterval,
    List<AddressCheckOption>? addresses,
    bool? emitWhenSlowConnection,
    Duration? slowConnectionThreshold,
    bool? requireAllAddressesToRespond,
    bool? forceCheckOnWeb,
  }) => _instance.updateConfig(
    checkTimeout: checkTimeout,
    checkInterval: checkInterval,
    addresses: addresses,
    emitWhenSlowConnection: emitWhenSlowConnection,
    slowConnectionThreshold: slowConnectionThreshold,
    requireAllAddressesToRespond: requireAllAddressesToRespond,
    forceCheckOnWeb: forceCheckOnWeb,
  );

  static BsInternetStatus? _status;

  /// Will always return `null` or [BsInternetStatus.connected] **on web**
  /// {@macro web_no_op_note}
  static BsInternetStatus? get status => _status;

  static bool? _connected;

  static bool? get connected => _connected;

  /// This is no-op **on web** and always return true
  /// unless you previously run: `updateCheckerConfig(forceCheckOnWeb: true)`
  static Future<bool> check() async {
    final status = await _instance.checkConnectivity();
    _updateState(status);
    return _connected!;
  }

  /// returns `BsInternetStatus` which can be used to detect slow connections.
  ///
  /// This is no-op **on web** and always return [BsInternetStatus.connected]
  /// {@macro web_no_op_note}
  ///
  static Future<BsInternetStatus> checkVerbose() async {
    final status = await _instance.checkConnectivity();
    _updateState(status);
    return status;
  }

  /// Forces checking for connectivity on web.
  ///
  /// {@template web_check_doc}
  /// This method sets config's `forceCheckOnWeb` to true,
  /// if you want to revert back to false once reconnected
  /// pass `resetWhenReconnected` with true.
  ///
  /// Also note that Reconnection is detected if connection is restored
  /// when monitoring is underway i.e. - at least 1 listener was attached -
  /// or when you normally call this method again and it returns true
  /// after previous disconnection.
  ///
  ///
  /// You can further control [resetForceCheckOnWebWhenReconnected]
  /// to reset it on your behalf in any case.
  /// {@endtemplate}
  static Future<bool> webCheck({bool? resetWhenReconnected}) async {
    updateCheckerConfig(forceCheckOnWeb: true);
    if (resetWhenReconnected != null) resetForceCheckOnWebWhenReconnected = resetWhenReconnected;

    final status = await _instance.checkConnectivity();
    _updateState(status);
    return _connected!;
  }

  /// Forces checking for connectivity on web.
  ///
  /// returns `BsInternetStatus` which can be used to detect slow connections.
  ///
  /// {@macro web_check_doc}
  static Future<BsInternetStatus> webCheckVerbose({bool? resetWhenReconnected}) async {
    updateCheckerConfig(forceCheckOnWeb: true);
    if (resetWhenReconnected != null) resetForceCheckOnWebWhenReconnected = resetWhenReconnected;

    final status = await _instance.checkConnectivity();
    _updateState(status);
    return status;
  }

  static StreamSubscription<BsInternetStatus>? _listener;

  /// When a listener is attached a check is performed immediately
  /// and the status (InternetConnectionStatus) is emitted.
  ///
  /// After that a timer starts which performs checks
  /// with the specified interval in `BsInternetChecker` config.
  ///
  /// This is no-op **on web**
  ///
  /// {@template web_no_op_note}
  /// unless you previously:
  ///
  ///  + ran `updateCheckerConfig(forceCheckOnWeb: true)`
  ///  + called [webCheckVerbose] or [webCheck] while
  ///    ignoring `resetWhenReconnected` or explicitly pass it with false
  /// {@endtemplate}
  static void monitorConnection() => _listener ??= _instance.onStatusChange.listen(_updateState);

  static bool _previouslyDisconnected = false;
  static bool resetForceCheckOnWebWhenReconnected = false;

  static void _connectionLogic() {
    if (Internet.connected ?? true) {
      // onConnected

      if (_previouslyDisconnected) {
        // onReconnected
        _previouslyDisconnected = false;

        if (resetForceCheckOnWebWhenReconnected) {
          resetForceCheckOnWebWhenReconnected = false;
          updateCheckerConfig(forceCheckOnWeb: false);
        }
      }
    } else {
      // onDisconnected
      _previouslyDisconnected = true;
    }
  }

  static void _updateState(BsInternetStatus status) {
    _status = status;
    _connected = _status != BsInternetStatus.disconnected;

    _statusNotifier.value = _status;
    _connectedNotifier.value = _connected;
    _connectionLogic();
  }

  static final ValueNotifier<BsInternetStatus?> _statusNotifier = ValueNotifier(_status);
  static final ValueNotifier<bool?> _connectedNotifier = ValueNotifier(_connected);

  static int _count = 0;

  /// No triggers will be called **on web**
  /// {@macro web_no_op_note}
  static void addListener(
    VoidCallback listener, {
    bool onSlowConnection = false,
  }) {
    final valueNotifier = onSlowConnection ? Internet._statusNotifier : Internet._connectedNotifier;

    valueNotifier.addListener(listener);

    Internet.monitorConnection();
    _count++;
  }

  bool onSlowConnection = false;

  static void removeListener(
    VoidCallback listener, {
    bool fromSlowConnection = false,
  }) {
    final valueNotifier = fromSlowConnection
        ? Internet._statusNotifier
        : Internet._connectedNotifier;

    valueNotifier.removeListener(listener);
    _count--;

    if (_count == 0) _dispose();
  }

  static Future<void> _dispose() async {
    await _listener?.cancel();
    _listener = null;
  }
}

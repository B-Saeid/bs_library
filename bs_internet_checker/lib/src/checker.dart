import 'dart:async';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import 'address_check_option.dart';
import 'address_check_result.dart';
import 'config.dart';
import 'status.dart';

/// A utility class that checks the status of the internet connection.
///
/// The `InternetConnectionChecker` class provides a way to monitor the internet
/// connection status of a device. It can emit statuses like connected,
/// disconnected, and slow connection based on predefined criteria.
/// The class is designed as a singleton to ensure consistent
/// monitoring across the app.
final class BsInternetChecker {
  /// MyInternetChecker is singleton class.
  ///
  /// You can configure it by passing [BsInternetCheckerConfig] instance when
  /// you first call the factory or using [BsInternetChecker.setConfig] anytime
  /// afterwards.
  ///
  /// Changes will take effect immediately and new configuration will be used
  /// in any following checks or stream emits.
  ///
  factory BsInternetChecker({BsInternetCheckerConfig? config}) {
    _config = config ?? BsInternetCheckerConfig();
    return _instance;
  }

  BsInternetChecker._() {
    _statusController = StreamController<BsInternetStatus>.broadcast()
      ..onListen = _startMonitoring
      ..onCancel = _stopMonitoring;
  }

  static final BsInternetChecker _instance = BsInternetChecker._();

  /// Singleton instance of `InternetConnectionChecker`.
  /// Access the singleton instance of `InternetConnectionChecker`.
  BsInternetChecker get instance => _instance;

  static late BsInternetCheckerConfig _config;

  void setConfig(BsInternetCheckerConfig config) => _config = config;

  void updateConfig({
    Duration? checkTimeout,
    Duration? checkInterval,
    List<AddressCheckOption>? addresses,
    bool? emitWhenSlowConnection,
    Duration? slowConnectionThreshold,
    bool? requireAllAddressesToRespond,
    bool? forceCheckOnWeb,
  }) => _config = _config.copyWith(
    checkTimeout: checkTimeout,
    checkInterval: checkInterval,
    addresses: addresses,
    emitWhenSlowConnection: emitWhenSlowConnection,
    slowConnectionThreshold: slowConnectionThreshold,
    requireAllAddressesToRespond: requireAllAddressesToRespond,
    forceCheckOnWeb: forceCheckOnWeb,
  );

  static final http.Client _httpClient = http.Client();
  static final Connectivity _connectivity = Connectivity();

  static Timer? _timerHandle;

  /// An internal flag to indicate if no connectivity device is available.
  // static bool _connectivityGone = false;

  /// Feel free to use `BehaviorSubject` from rx
  /// if you need to get rid of this variable.
  static BsInternetStatus? _lastStatus;

  late final StreamController<BsInternetStatus> _statusController;

  /// A stream of `InternetConnectionStatus` that emits the
  /// current connection status.
  Stream<BsInternetStatus> get onStatusChange => _statusController.stream;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Internal method to start monitoring the connectivity changes.
  void _startMonitoring() {
    _connectivitySubscription ??= _connectivityMonitoring();

    _maybeEmitStatusUpdate(); // Initial status update
  }

  /// IT TURNS OUT that [_connectivity.onConnectivityChanged] was
  /// the reason behind us thinking that internet_connectivity_checker
  /// package is messy, and it was it that initially emits [ConnectivityResult.none]
  /// and right after a few microseconds it emits the actual [ConnectivityResult].
  ///
  /// So we used `skip(1)` here to workaround this issue.
  ///
  /// Final statement: `Connectivity` seems to be unreliable in emitting statuses
  /// either emits on time but incorrect data or emits the actual connection at
  /// some other ALIEN time!! but sometimes it gets it right, So I will use it
  /// as an auxiliary notifier to ensure my connection is instantly updated if required.
  StreamSubscription<List<ConnectivityResult>> _connectivityMonitoring() => _connectivity
      .onConnectivityChanged
      .skip(1)
      .listen(
        (_) => _maybeEmitStatusUpdate(),
      );

  // _connectivity.onConnectivityChanged.skip(1).listen((list) async {
  //   'connectivity: $list'.tLog;
  //
  //   if (list.contains(ConnectivityResult.none)) {
  //     // _connectivityGone = true;
  //     _emitStatus(MyInternetStatus.disconnected);
  //   } else {
  //     final internetSources = ConnectivityResult.values.whereNot(
  //       /// `ConnectivityResult.none` is not considered since we are in ELSE
  //       /// so connectivityList will NOT contain it.
  //       (element) => element == ConnectivityResult.bluetooth,
  //     );
  //     final listContainsInternetSource = list.any(internetSources.contains);
  //
  //     if (listContainsInternetSource /* && _connectivityGone*/ ) {
  //       // _connectivityGone = false;
  //       await _maybeEmitStatusUpdate();
  //     }
  //   }
  // });

  /// Stops monitoring the connectivity changes and
  /// cancels any scheduled checks.
  void _stopMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _timerHandle?.cancel();
    _timerHandle = null;
    _lastStatus = null;
  }

  /// Indicates whether there are any active listeners to the
  /// connection status stream.
  bool get hasListeners => _statusController.hasListener;

  /// Checks if all or any addresses are reachable based on the configuration.
  Future<BsInternetStatus> checkConnectivity() async {
    /// This is added since we encountered numerous CORS errors when checking
    /// on web especially for browsers that somehow blocks third party cookies
    /// or have some strict policies imposed like mine ^^.
    if (kIsWeb && !_config.forceCheckOnWeb) return BsInternetStatus.connected;
    try {
      return _config.requireAllAddressesToRespond
          ? _checkConnectivityAll()
          : _checkConnectivityAny();
    } catch (e) {
      return BsInternetStatus.disconnected;
    }
  }

  Future<BsInternetStatus> _checkConnectivityAll() async {
    /// This approach affects performance as it initializes all connections at once.
    /// the issue gets clearer if we have a lot of addresses to check.
    // final List<AddressCheckResult> results = await Future.wait(futures);

    /// This is a more performant approach, since it goes one by one.
    final results = <AddressCheckResult>[];
    await Future.forEach(
      _config.addresses,
      (address) async {
        final result = await isHostReachable(address);
        results.add(result);
      },
    );

    var wasAnyOneSlow = false;

    final allResponded = results.every((result) {
      if (!result.isFast) wasAnyOneSlow = true;
      return result.isSuccess;
    });

    if (allResponded) {
      return wasAnyOneSlow ? BsInternetStatus.slow : BsInternetStatus.connected;
    } else {
      return BsInternetStatus.disconnected;
    }
  }

  Future<BsInternetStatus> _checkConnectivityAny() async {
    /// Ensure at least one successful result, even if others fail.
    ///
    /// We use .shuffled() to avoid over using the first address
    /// in checks especially if we have a short [_config.interval]
    for (final address in _config.addresses.shuffled()) {
      final result = await isHostReachable(address);

      /// Return true ONCE we get a successful result.
      if (result.isSuccess) {
        return result.isFast ? BsInternetStatus.connected : BsInternetStatus.slow;
        // break; // break is not needed the return statement does it as well.
      }
    }

    /// Out of loop means all addresses failed.
    return BsInternetStatus.disconnected;
  }

  /// Checks if there is an active internet connection
  /// regardless of whether it is slow or fast.
  ///
  /// This method checks connectivity by making requests
  /// to the configured addresses.
  /// If `requireAllAddressesToRespond` is enabled, it validates all addresses.
  Future<bool> get hasConnection async {
    final status = await checkConnectivity();

    /// Call _emitStatus immediately after checking.
    ///
    /// of course some checks are done inside it beforehand.
    _emitStatus(status);

    return status != BsInternetStatus.disconnected;
  }

  /// Checks if a specific host is reachable.
  ///
  /// This method sends a request to the given [option] and
  /// determines if the host is reachable.
  ///
  /// It also checks if the response time exceeds
  /// the configured threshold.
  Future<AddressCheckResult> isHostReachable(AddressCheckOption option) async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await _httpClient.head(option.uri).timeout(option.timeout);
      // headers: {'mode': 'no-cors'},
      // print('URL = ${option.uri}');
      // print('response = $response');
      // print('statusCode = ${response.statusCode}');
      // print('[100 - 600] = ${response.statusCode >= 100 && response.statusCode < 600}');
      stopwatch.stop();

      final isFast = stopwatch.elapsed < _config.slowConnectionThreshold;
      // print('isFast = $isFast');

      /*
      This condition considers any valid HTTP response
      (including informational, redirection, client error,
      and server error status codes) as an indication that
      the internet is available.

      Even if the server returns an error (e.g., 404 Not Found,
      500 Internal Server Error), it proves that the internet connection
      is active because the device successfully communicated with the server.
      */

      return AddressCheckResult(
        option,
        isFast: isFast,
        isSuccess: response.statusCode >= 100 && response.statusCode < 600,
      );
    } catch (e) {
      // print('error = $e');
      return AddressCheckResult(
        option,
        isSuccess: false,
        isFast: false,
      );
    }
  }

  /// Internal method to emit the connection status if it has changed.
  void _emitStatus(BsInternetStatus newStatus) {
    final shouldUpdate = _config.emitWhenSlowConnection
        ? _lastStatus != newStatus
        : _lastStatus != newStatus && newStatus != BsInternetStatus.slow;

    if (shouldUpdate && _statusController.hasListener) _statusController.add(newStatus);

    _lastStatus = newStatus;
  }

  /// Schedules the next status update check.
  Future<void> _maybeEmitStatusUpdate() async {
    /// Pause any scheduling if any
    _timerHandle?.cancel();

    // if (!_connectivityGone) {
    final status = await checkConnectivity();

    _emitStatus(status);
    // }
    _scheduleNextStatusCheck();
  }

  /// Schedules the next status check based on the configured interval.
  void _scheduleNextStatusCheck() {
    if (!_statusController.hasListener) return;

    _timerHandle?.cancel();
    _timerHandle = Timer(_config.checkInterval, _maybeEmitStatusUpdate);
  }

  /// Disposes of the singleton instance and cleans up resources.
  ///
  /// This method stops monitoring the connectivity changes, cancels any
  /// scheduled status updates, and closes the status stream.
  void dispose() {
    _stopMonitoring(); // Stops monitoring and cancels the timer
    _statusController.close(); // Closes the stream controller
  }
}

import 'address_check_option.dart';
import 'constants.dart';

class BsInternetCheckerConfig {
  BsInternetCheckerConfig({
    this.checkTimeout = BsInternetCheckerConstants.TIMEOUT,
    this.checkInterval = BsInternetCheckerConstants.INTERVAL,
    List<AddressCheckOption>? addresses,
    this.emitWhenSlowConnection = false,
    this.slowConnectionThreshold = BsInternetCheckerConstants.SLOW_CONNECTION_THRESHOLD,
    this.requireAllAddressesToRespond = false,
    this.forceCheckOnWeb = false,
  }) {
    _addresses = _handleAddresses(addresses, checkTimeout);
  }

  List<AddressCheckOption> _handleAddresses(
    List<AddressCheckOption>? addresses,
    Duration? checkTimeout,
  ) {
    assert(
      addresses == null || addresses.isNotEmpty,
      'The "addresses" parameter cannot be an empty list.'
      ' Provide at least one address or leave it null to use the default addresses.',
    );

    final list = addresses ?? BsInternetCheckerConstants.DEFAULT_ADDRESSES;

    /// This is to ensure `checkTimeout` is synced.
    return list
        .map(
          (address) => AddressCheckOption(
            uri: address.uri,
            timeout: checkTimeout ?? BsInternetCheckerConstants.TIMEOUT,
          ),
        )
        .toList();
  }

  /// The timeout duration for connectivity checks.
  final Duration checkTimeout;

  /// The interval between consecutive connectivity checks.
  final Duration checkInterval;

  late final List<AddressCheckOption> _addresses;

  /// The addresses to check for internet connectivity.
  List<AddressCheckOption> get addresses => _addresses;

  /// Whether to emit slow connection in [BsInternetChecker.onStatusChange] stream.
  final bool emitWhenSlowConnection;

  /// The duration threshold that when response takes longer than it,
  /// the connection is considered slow.
  final Duration slowConnectionThreshold;

  /// Whether to check all addresses for internet connectivity.
  final bool requireAllAddressesToRespond;

  /// By default no checks happen when running on web
  /// this flag when set true can override this behaviour.
  final bool forceCheckOnWeb;

  BsInternetCheckerConfig copyWith({
    Duration? checkTimeout,
    Duration? checkInterval,
    List<AddressCheckOption>? addresses,
    bool? emitWhenSlowConnection,
    Duration? slowConnectionThreshold,
    bool? requireAllAddressesToRespond,
    bool? forceCheckOnWeb,
  }) {
    final list = _handleAddresses(addresses, checkTimeout ?? this.checkTimeout);
    return BsInternetCheckerConfig(
      checkInterval: checkInterval ?? this.checkInterval,
      checkTimeout: checkTimeout ?? this.checkTimeout,
      addresses: list,
      emitWhenSlowConnection: emitWhenSlowConnection ?? this.emitWhenSlowConnection,
      slowConnectionThreshold: slowConnectionThreshold ?? this.slowConnectionThreshold,
      requireAllAddressesToRespond:
          requireAllAddressesToRespond ?? this.requireAllAddressesToRespond,
      forceCheckOnWeb: forceCheckOnWeb ?? this.forceCheckOnWeb,
    );
  }
}

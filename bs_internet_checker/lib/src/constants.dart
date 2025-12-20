// ignore_for_file: constant_identifier_names

// You can use [InternetConnectionCheckerConstants] like this:
// ```dart
// final DEFAULT_TIMEOUT = Constants.DEFAULT_TIMEOUT;
// ```
import 'address_check_option.dart';

///
class BsInternetCheckerConstants {
  /// Default timeout duration (5 seconds) for checking connectivity.
  ///
  /// **PER ADDRESS**.
  static const Duration TIMEOUT = Duration(seconds: 3);

  /// Default interval (10 seconds) between consecutive connectivity checks.
  static const Duration INTERVAL = Duration(seconds: 5);

  /// Default threshold duration to consider a connection as "slow".
  static const Duration SLOW_CONNECTION_THRESHOLD = Duration(seconds: 1);

  /// URLs used for connectivity checks.

  // static const String URL_1 = 'https://api.ipify.org'; // is quite slow
  static const String URL_1 = 'https://1.1.1.1';
  static const String URL_2 = 'https://clients3.google.com/generate_204';
  static const String URL_3 = 'https://jsonplaceholder.typicode.com/albums/1';
  static const String URL_4 = 'https://fakestoreapi.com/products/1';
  static const String URL_5 = 'https://detectportal.firefox.com/success.txt';
  static const String URL_6 = 'https://www.google.com/generate_204';
  static const String URL_7 = 'https://www.gstatic.com/generate_204';
  static const String URL_8 = 'https://connectivitycheck.gstatic.com/generate_204';
  static const String URL_9 = 'https://api.ipify.org?format=json';
  static const String URL_10 = 'https://ipinfo.io/json';
  static const String URL_11 = 'https://cloudflare.com/cdn-cgi/trace';
  static const String URL_12 = 'https://connectivitycheck.opendns.com';
  static const String URL_13 = 'https://httpbin.org/get';

  // static const String URL_14 = 'https://example.com'; // { "mode": "no-cors"}
  // static const String URL_15 = 'https://www.google.com/favicon.ico'; // { "mode": "no-cors"}
  // static const String URL_16 = 'https://www.cloudflare.com'; // { "mode": "no-cors"}

  // https://clients3.google.com/generate_204	Lightweight, used by Android
  // Cloudflare	https://1.1.1.1	Fast and reliable
  // Apple	https://captive.apple.com	Used by iOS/macOS
  // Mozilla	http://detectportal.firefox.com/success.txt

  // https://api.ipify.org/
  // https://ifconfig.me

  /// Default list of addresses to check connectivity against.
  // ignore: non_constant_identifier_names
  static final List<AddressCheckOption> DEFAULT_ADDRESSES = List<AddressCheckOption>.unmodifiable(
    <AddressCheckOption>[
      AddressCheckOption(uri: Uri.parse(URL_1)),
      AddressCheckOption(uri: Uri.parse(URL_2)),
      AddressCheckOption(uri: Uri.parse(URL_3)),
      AddressCheckOption(uri: Uri.parse(URL_4)),
      AddressCheckOption(uri: Uri.parse(URL_5)),
      AddressCheckOption(uri: Uri.parse(URL_6)),
      AddressCheckOption(uri: Uri.parse(URL_7)),
      AddressCheckOption(uri: Uri.parse(URL_8)),
      AddressCheckOption(uri: Uri.parse(URL_9)),
      AddressCheckOption(uri: Uri.parse(URL_10)),
      AddressCheckOption(uri: Uri.parse(URL_11)),
      AddressCheckOption(uri: Uri.parse(URL_12)),
      AddressCheckOption(uri: Uri.parse(URL_13)),
    ],
  );
}

// May be Later ... it does not work
import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'extensions/time/on_duration.dart';

abstract final class MethodsUtils {
  // static var _retryFallBack = 0;
  // static const _retryIncrement = 2;

  static FutureOr<T?> tryThis<T>(
    FutureOr<T> Function() function, {
    void Function(dynamic error, StackTrace stackTrace)? onError,
    bool logError = kDebugMode,
  }) async {
    try {
      return await function();
    } catch (error, stackTrace) {
      onError?.call(error, stackTrace);
      if (logError) {
        log(
          'Error occurred while trying $function',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return null;
    }
  }

  /// Used to only call the `function` if the `condition` is true
  /// along with some retry control.
  ///
  /// `retryEvery` is the time to wait before trying again,
  /// default is `1` second.
  ///
  /// `retryAttempts` is the number of times to try,
  /// default is `-1` which means infinite.
  ///
  /// `orElse` is callback that is executed when `condition`
  /// is not met after `retryAttempts`, it is useless when
  /// `retryAttempts` is `-1`. If omitted `null` will be returned.
  static FutureOr<T?> tryIf<T>(
    FutureOr<T> Function() function, {
    required FutureOr<bool> Function() condition,
    Duration retryEvery = const Duration(seconds: 1),
    int retryAttempts = -1,
    FutureOr<T?>? Function()? orElse,
  }) async {
    assert(
      !retryEvery.isNegative,
      '`retryEvery` duration must not be negative',
    );
    assert(
      retryAttempts == -1 || retryAttempts > 0,
      '`retryAttempts` if not -1 must be greater than 0',
    );

    if (retryAttempts == -1) {
      while (true) {
        if (!await condition()) {
          // print('entering the while condition: ${!await condition()}');
          // print('Before waiting');
          await retryEvery.delay;
        } else {
          // print('Condition Met. Breaking and calling the function...');
          break;
        }
      }
      return await tryThis(function);
    } else if (retryAttempts == 1) {
      return await condition() ? await tryThis(function) : orElse?.call();
    } else {
      if (await condition()) {
        // print('Condition Met. Breaking... and calling the function');
        return await tryThis(function);
      } else {
        var attempts = 1; // starts from 1 as the first attempt is already done
        while (attempts < retryAttempts) {
          await retryEvery.delay;
          // print('attempts: $attempts');
          attempts++;
          // print('now attempts: $attempts');
          if (await condition()) {
            // print(
            //   'Condition Met. After $attempts attempts. Breaking... and calling the function',
            // );
            return await tryThis(function);
          }
        }
        // print(
        //   'Calling `orElse` as attempts are over and condition is still false',
        // );
        return orElse?.call();
      }
    }
  }

  static Future<bool> waitUntil(
    FutureOr<bool> Function() condition, {
    Duration retryEvery = const Duration(seconds: 1),
    int retryAttempts = -1,
  }) async {
    assert(
      !retryEvery.isNegative,
      '`retryEvery` duration must not be negative',
    );
    assert(
      retryAttempts == -1 || retryAttempts > 0,
      '`retryAttempts` if not -1 must be greater than 0',
    );

    if (retryAttempts == -1) {
      while (true) {
        if (!await condition()) {
          // print(
          //   'condition: false, waiting ${retryEvery.inMilliseconds} ms ...',
          // );
          await retryEvery.delay;
        } else {
          // print('Condition Met. Breaking...');
          break;
        }
      }
      return true;
    } else if (retryAttempts == 1) {
      return await condition();
    } else {
      if (await condition()) {
        // print('Condition Met. Breaking...');
        return true;
      } else {
        var attempts = 1; // starts from 1 as the first attempt is already done
        while (attempts < retryAttempts) {
          await retryEvery.delay;
          // print('attempts: $attempts');
          attempts++;
          // print('now attempts: $attempts');
          if (await condition()) {
            // print('Condition Met. After $attempts attempts. Breaking...');
            return true;
          }
        }
        // // print('Calling `orElse` as attempts are over and condition is still false');
        // return orElse?.call();
        return false;
      }
    }
  }

  // static Future<bool> retryOnHandshake(VoidCallback methodCallback, {int retryAttempts = 1}) async {
  //   try {
  //     methodCallback();
  //     return true;
  //   } on HandshakeException catch (e, s) {
  // //     print('HandshakeException Occurred in $s');
  //
  //     if (_retryFallBack < _retryIncrement * retryAttempts) {
  //       _retryFallBack += _retryIncrement;
  // //       print('retrying after a $_retryFallBack s ....... ');
  //       await _retryFallBack.seconds.delay;
  //       return retryOnHandshake(methodCallback, retryAttempts: retryAttempts);
  //     }
  // //     print('retrying is OVER and _retryFallBack = $_retryFallBack s');
  //     return false;
  //   } catch (error, stackTrace) {
  // //     print('Error occurred in tryThis call ${error.toString()} with stackTrace $stackTrace');
  //     return false;
  //   }
  // }
}

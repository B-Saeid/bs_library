// ignore_for_file: public_member_api_docs

import 'dart:collection';
import 'dart:developer';

import 'package:flutter/widgets.dart';

abstract final class PreCloseChecks {
  static final SplayTreeMap<double, ValueGetter<bool>> _prioritizedCallbacks = SplayTreeMap();

  /// adds a callback to be called when prior to closing the feedback
  /// Make sure to remove the callback using [remove] when
  /// it is no longer needed to avoid abnormal closing behaviour.
  ///
  /// If priority is not omitted, its value must be >= 0
  ///
  /// 0 is considered the highest priority.
  ///
  /// Defaults to infinity i.e. the lowest priority
  ///
  static void add(ValueGetter<bool> callback, {int? priority}) {
    assert(priority == null || priority >= 0, 'Priority ,if not omitted, must be >= 0');

    // Convert to double so that we have a valid maximum value to sort null
    // priorities last.
    log(
      'Add $callback with priority $priority',
      name: 'PreCloseCallbacks',
    );
    final doublePriority = priority?.toDouble() ?? double.infinity;
    final insideCallback = _prioritizedCallbacks[doublePriority];
    if (insideCallback != null) {
      log(
        'WARNING: You tried to add $callback WITH priority of $priority'
        '\nAND\n'
        '$insideCallback already exists with the same priority',
        name: 'PreCloseCallbacks',
        level: 1500,
        // stackTrace: StackTrace.current,
      );
      // throw Exception(
      //   'a callback ref $insideCallback already exists'
      //   ' with the same priority of $priority',
      // );
      return;
    }
    _prioritizedCallbacks[doublePriority] = callback;
  }

  /// removes a callback from being called when the back button is pressed
  static void remove(ValueGetter<bool> callback) {
    // log(
    //   'remove $callback',
    //   name: 'PreCloseCallbacks',
    // );

    /// These two lines are smart.
    // _prioritizedCallbacks.values.any((callbackList) => callbackList.remove(callback));
    // _prioritizedCallbacks.removeWhere((key, value) => value.isEmpty);

    // print('_prioritizedCallbacks length = ${_prioritizedCallbacks.length}');
    _prioritizedCallbacks.removeWhere((_, insideCallBack) {
      if (insideCallBack == callback) print('removed callback is $insideCallBack');
      return callback == insideCallBack;
    });
    // print('_prioritizedCallbacks length = ${_prioritizedCallbacks.length}');
  }

  static Iterable<ValueGetter<bool>> get _callbacks => _prioritizedCallbacks.values;

  /// Returns true if any of the callbacks handled the call,
  /// otherwise returns false, i.e. you can close the feedback.
  static bool runChecks() {
    // log(
    //   '_callbacks = $_callbacks',
    //   name: 'PreCloseChecks',
    // );
    // log(
    //   '_callbacks length = ${_callbacks.length}',
    //   name: 'PreCloseChecks',
    // );
    if (_callbacks.isEmpty) return false;

    return _callbacks.any((callback) {
      final result = callback();
      // log(
      //   'Running callback $callback returned $result',
      //   name: 'PreCloseChecks',
      // );
      return result;
    });
  }
}

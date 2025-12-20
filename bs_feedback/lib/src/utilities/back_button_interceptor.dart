// ignore_for_file: public_member_api_docs

import 'dart:collection';
import 'dart:developer';

import 'package:flutter/widgets.dart';

class BackButtonInterceptor with WidgetsBindingObserver {
  BackButtonInterceptor._();

  @visibleForTesting
  static final BackButtonInterceptor instance = BackButtonInterceptor._();

  /// I'm wondering why the maintainer chose to use [SplayTreeMap] which seems to be
  /// very or quite advanced, I think a [set] or a [List] of [BoolCallback]s
  /// would do the job without any complexity that's at the end my opinion.
  ///
  /// Regarding the double [priority], after reading the documentation of [SplayTreeMap],
  /// it seems the ordering is done implicitly by the [SplayTreeMap]
  /// Most likely on every member method invocation like `add`, `remove`.
  ///
  /// Yes, I saw the priority of the bottom [sheetProgress] being given a value of zero, and
  /// that means it will be on the very top, presumably as there no documentation regarding the
  /// range, obviously The user would not see such documentation, it is meant to be for
  /// contributors, but I do not think the maintainer thought of much programmers
  /// getting into interested to contribute to his really hard-worked, thoughtful package
  /// I would like to give credit where it's due.
  ///
  /// Note: it may also possible to have a priority with [-ve] values and it will be above it.
  ///
  /// This is OK because you would need ,if the user tap the back button, the app to first
  /// invoke the callback of minimizing the bottom sheet if it is expanded and then
  /// it would invoke the other less prioritized callbacks when the back button is tapped again.
  /// I do think that there is something less complicated than [SplayTreeMap] to use
  /// in order to achieve such functionality without [SplayTreeMap] as it seems like
  /// an overkill and it also sounds like an alien to dart programmers, however it's
  /// a data structure, It's familiar to academic software engineers and experienced programmers.
  ///
  /// Bottom line, I think there is a much simpler solution.
  ///
  /// ### `static final Map<double, BoolCallback> _prioritizedCallbacks = {};`
  ///
  /// Using the normal map made us thankfully approve the usage of [SplayTreeMap]
  /// as it automatically sorts out the values based on the keys using the [compare] function.
  /// This is done automatically without you having to worry about it when invoking a callBack
  /// from the callback list in [didPopRoute] below. If you used a normal map, you would need to
  /// see your keys for the priority and check the higher one and then you would call its callback
  /// ,however the [SplayTreeMap] does it for you but it felt like a overwhelming word,
  /// but at the end, it just needed a little bit of a digging in order to fully understand
  /// what it actually does and appreciate its power.
  static final SplayTreeMap<double, ValueGetter<bool>> _prioritizedCallbacks = SplayTreeMap();

  /// adds a callback to be called when the back button is pressed
  /// Make sure to remove the callback using [remove]
  /// when it is no longer needed to avoid improper back button handling.
  ///
  /// If priority is not omitted, its value must be >= 0
  ///
  /// 0 is considered the highest priority.
  ///
  /// Defaults to infinity i.e. the lowest priority
  ///
  static void add(ValueGetter<bool> callback, {int? priority}) {
    assert(priority == null || priority >= 0, 'Priority ,if not omitted, must be >= 0');
    if (_prioritizedCallbacks.isEmpty) _mount();

    // Convert to double so that we have a valid maximum value to sort null
    // priorities last.
    print('add $callback priority $priority');
    final doublePriority = priority?.toDouble() ?? double.infinity;
    final insideCallback = _prioritizedCallbacks[doublePriority];
    if (insideCallback != null) {
      log(
        'WARNING: You tried to add $callback WITH priority of $priority'
        '\nAND\n'
        '$insideCallback already exists with the same priority',
        name: 'BackButtonInterceptor',
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
    // print('remove $callback');

    /// These two lines are smart.
    // _prioritizedCallbacks.values.any((callbackList) => callbackList.remove(callback));
    // _prioritizedCallbacks.removeWhere((key, value) => value.isEmpty);

    // print('_prioritizedCallbacks length = ${_prioritizedCallbacks.length}');
    _prioritizedCallbacks.removeWhere((_, insideCallBack) {
      if (insideCallBack == callback) print('removed callback is $insideCallBack');
      return callback == insideCallBack;
    });
    // print('_prioritizedCallbacks length = ${_prioritizedCallbacks.length}');
    if (_prioritizedCallbacks.isEmpty) _unMount();
  }

  static void _mount() => _binding.addObserver(instance);

  static void _unMount() {
    _prioritizedCallbacks.clear();
    _binding.removeObserver(instance);
  }

  Iterable<ValueGetter<bool>> get _callbacks => _prioritizedCallbacks.values;

  @override
  Future<bool> didPopRoute() async {
    // print('_callbacks = $_callbacks');
    // print('_callbacks length = ${_callbacks.length}');
    if (_callbacks.isEmpty) return await super.didPopRoute();

    return _callbacks.any((callback) => callback());
  }

  // WidgetsBinding? was needed because `WidgetsBinding.instance` is nullable up to 2.10
  // and non-nullable after 2.10.
  static WidgetsBinding get _binding => WidgetsBinding.instance;
}

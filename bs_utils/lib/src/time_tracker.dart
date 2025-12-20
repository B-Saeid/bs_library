import 'package:flutter/foundation.dart';
import 'package:timing/timing.dart';

import 'extensions/time/on_duration.dart';

abstract final class Tracker {
  static Duration trackSync(dynamic Function() callback, {String? name}) {
    final tracker = SyncTimeTracker();
    tracker.track(callback);
    final statement = '${name ?? callback}\n -- took: ${tracker.duration.sMsUsFormatted}';
    debugPrint(statement);
    return tracker.duration;
  }

  static Future<Duration> trackAsync(
    AsyncCallback callback, {
    String? name,
  }) async {
    final tracker = AsyncTimeTracker();
    await tracker.track(callback);
    final statement = '${name ?? callback}-- took: ${tracker.duration.sMsUsFormatted}';
    debugPrint(statement);
    return tracker.duration;
  }

  static void compareSync(
    AsyncCallback first,
    AsyncCallback second, {
    String? firstName,
    String? secondName,
  }) => _checkDiff(
    trackSync(first, name: firstName),
    trackSync(second, name: secondName),
  );

  static Future<void> compareAsync(
    AsyncCallback first,
    AsyncCallback second, {
    String? firstName,
    String? secondName,
  }) async => _checkDiff(
    await trackAsync(first, name: firstName),
    await trackAsync(second, name: secondName),
  );

  static Future<void> compare({
    required AsyncCallback asyncCallback,
    String? asyncName,
    required dynamic Function() syncCallback,
    String? syncName,
  }) async => _checkDiff(
    trackSync(syncCallback, name: syncName),
    await trackAsync(asyncCallback, name: asyncName),
    firstIsTheSync: true,
  );

  static void _checkDiff(
    Duration first,
    Duration second, {
    bool firstIsTheSync = false,
  }) {
    if (first == second) return debugPrint('Equal');

    final diff = first - second;
    final smaller = diff.isNegative ? first : second;
    final bigger = smaller == first ? second : first;
    final percentage = (smaller.inMicroseconds / bigger.inMicroseconds) * 100;

    debugPrint(
      '${smaller == first
          ? firstIsTheSync
                ? 'Sync'
                : 'First'
          : firstIsTheSync
          ? 'Async'
          : 'Second'} Wins,'
      ' Diff ${diff.abs().sMsUsFormatted},'
      ' ${percentage.round()}%',
    );
  }
}

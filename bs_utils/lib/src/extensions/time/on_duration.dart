import 'dart:math';

import 'on_num.dart';

extension DurationTimeExtension on Duration {
  static const int daysPerWeek = 7;
  static const int nanosecondsPerMicrosecond = 1000;

  /// Returns the representation in weeks
  int get inWeeks => (inDays / daysPerWeek).ceil();

  /// Adds the Duration to the current DateTime and returns a DateTime in the future
  // DateTime get fromNow => clock.now() + this;

  /// Subtracts the Duration from the current DateTime and returns a DateTime in the past
  // DateTime get ago => clock.now() - this;

  /// Returns a Future.delayed from this
  Future<void> get delay => Future.delayed(this);

  /// Returns this [Duration] clamped to be in the range [min]-[max].
  ///
  /// The comparison is done using [compareTo].
  ///
  /// The arguments [min] and [max] must form a valid range where
  /// `min.compareTo(max) <= 0`.
  ///
  /// Example:
  /// ```dart
  /// var result = Duration(days: 10, hours: 12).clamp(
  ///   min: Duration(days: 5),
  ///   max: Duration(days: 10),
  /// ); // Duration(days: 10)
  /// result = Duration(hours: 18).clamp(
  ///   min: Duration(days: 5),
  ///   max: Duration(days: 10),
  /// ); // Duration(days: 5)
  /// result = Duration(days: 0).clamp(
  ///   min: Duration(days: -5),
  ///   max: Duration(days: 5),
  /// ); // Duration(days: 0)
  /// ```
  Duration clamp({Duration? min, Duration? max}) {
    assert(
      ((min != null) && (max != null)) ? min.compareTo(max) <= 0 : true,
      'Duration min has to be shorter than max\n(min: $min - max: $max)',
    );
    if ((min != null) && compareTo(min).isNegative) {
      return min;
    } else if ((max != null) && max.compareTo(this).isNegative) {
      return max;
    }
    return this;
  }

  (int, int, int) get nHHnMMnSS {
    // final minutesPart = (inMinutes - (inHours * 60));
    // final secondsPart = inSeconds - (minutesPart * 60) - (inHours * 3600);
    // return (inHours, minutesPart, secondsPart);
    return (inHours, inMinutes.remainder(60), inSeconds.remainder(60));
  }

  /// Returns a record of (seconds, milliseconds, microseconds)
  /// Example:
  ///  - `Duration(seconds: 90, milliseconds: 26240)` -> `(90, 26, 240)`
  ///  - `Duration(seconds: 1, microseconds: 15000)` -> `(1, 15, 0)`
  (int, int, int) get nSSnMSnUS => (
    inSeconds,
    inMilliseconds.remainder(1000),
    inMicroseconds.remainder(1000),
  );

  /// Returns a record of ("seconds", "milliseconds", "microseconds")
  /// Example:
  ///  - `Duration(seconds: 90, milliseconds: 26240)` -> `('90', '26', '240')`
  ///  - `Duration(seconds: 1, microseconds: 15000)` -> `('01', '15', '00')`
  (String, String, String) get sMsUsString => (
    inSeconds.padLeftSingles,
    inMilliseconds.remainder(1000).padLeftSingles,
    inMicroseconds.remainder(1000).padLeftSingles,
  );

  (String, String, String) get nMMnSSnFF {
    // final minutesPart = (inMinutes - (inHours * 60));
    // final secondsPart = inSeconds - (minutesPart * 60) - (inHours * 3600);
    // return (minutesPart.padLeftSingles, secondsPart.padLeftSingles, moment());
    return (
      inMinutes.padLeftSingles,
      inSeconds.remainder(60).padLeftSingles,
      moment.padLeftSingles,
    );
  }

  String get hhColonMMColonSS => toString().split('.').first.padLeft(8, '0');

  String get mmColonSS => toString().split('.').first.padLeft(8, '0');

  /// Examples:
  ///
  /// `Duration(hours: 2, seconds: 120)` -> ` 0`
  /// `Duration(seconds: 90, milliseconds: 640)` ->  `64`
  /// `Duration(seconds: 15, milliseconds: 789)` ->  `79`
  ///
  int get moment {
    /// The idea of remainder is to remove all integer multiplications
    /// of the number passed to it.
    ///
    /// In this case our goal is to get the moment part of the duration,
    /// which is two digits after the second.
    ///
    /// The nearest part is milliseconds, in order to obtain it from [inMilliseconds]
    /// we need to remove the higher units multiplications from it, which is the second.
    ///
    /// So we use [remainder] to remove the integer multiplications of 1000,
    /// the result is surly less than 1000 which is the pure milliseconds.
    ///
    /// Duration(hour: 2, seconds: 120) -> pure milliseconds = 0 -> momentsDouble = 0.0
    /// Duration(seconds: 90, milliseconds: 640) -> pure milliseconds = 640 -> momentsDouble = 64.0
    /// Duration(seconds: 15, milliseconds: 789) -> pure milliseconds = 789 -> momentsDouble = 78.9
    final momentsDouble = inMilliseconds.remainder(1000) / 10;

    /// Note: If it returns 100 it means that the pure milliseconds
    /// is ranging from 995 to 999, which can be considered as a second.
    // return momentsDouble.round();
    return min(99, momentsDouble.round());
  }

  /// Returns a dynamic string as:
  ///  - HH:MM:SS if the hours is greater than 0
  ///  - MM:SS if the hours is 0
  String get dynamicColonSeparated {
    /// d = const Duration(hours: 1, minutes: 10, microseconds: 500);
    /// print(d.toString()); // 1:10:00.000500

    // final components = toString().split('.').?first.split(':');
    // final hours = int.parse(components[0]);
    // final minutes = int.parse(components[1]);
    // final seconds = int.parse(components[2]);
    //
    // /// Pads this string on the left if it is shorter than width.
    // // ignore: prefer_interpolation_to_compose_strings
    // final string = (hours == 0 ? '' : hours.padLeftSingles + ':') +
    //     // ignore: prefer_interpolation_to_compose_strings
    //     (minutes.padLeftSingles + ':' + seconds.padLeftSingles);
    //
    // return string;

    final (h, m, s) = nHHnMMnSS;

    final buffer = StringBuffer();

    if (h > 0) buffer.write('${h.padLeftSingles}:');
    buffer.write('${m.padLeftSingles}:');
    buffer.write(s.padLeftSingles);

    return buffer.toString();
  }

  /// Does not include zero values.
  /// Examples:
  ///   - `Duration(seconds: 16, milliseconds: 200, microseconds: 430)` => `16 s 200 ms 430 µs`
  ///   - `Duration(seconds: 3, microseconds: 440, milliseconds: 16)` => `3 s 440 ms 16 µs`
  ///   - `Duration(seconds: 3, microseconds: 500)` => `3 s 500 µs`
  ///   - `Duration(seconds: 1, microseconds: 14)` => `1 s 14 µs`
  String get sMsUsFormatted {
    final (s, ms, us) = nSSnMSnUS;

    final buffer = StringBuffer();

    if (s > 0) buffer.write('$s s, ');
    if (ms > 0) buffer.write('$ms ms, ');
    if (us > 0) buffer.write('$us µs');

    return buffer.toString();
  }

  Duration operator /(int num) => Duration(microseconds: (inMicroseconds / num).round());

  Duration operator *(int num) => Duration(microseconds: inMicroseconds * num);
}

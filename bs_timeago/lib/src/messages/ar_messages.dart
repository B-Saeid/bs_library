import '../core.dart';

/// Return (So Called) Arabic Numbered String
/// 1 -> ١
/// 12 -> ١٢
///
String _arabicNumber(int number) {
  final string = number.toString();

  if (string.length == 1) return _soCalledArabicNumberString(string);

  final buffer = StringBuffer();
  for (var i = 0; i < string.length; i++) {
    final digitString = string.substring(i, i + 1);
    buffer.write(_soCalledArabicNumberString(digitString));
  }
  return buffer.toString();
}

String _soCalledArabicNumberString(String arabicNumber) => switch (arabicNumber) {
  '0' => '٠',
  '1' => '١',
  '2' => '٢',
  '3' => '٣',
  '4' => '٤',
  '5' => '٥',
  '6' => '٦',
  '7' => '٧',
  '8' => '٨',
  '9' => '٩',
  _ => throw ArgumentError(
    'Invalid Number, must be between 0 to 9, got $arabicNumber',
  ),
};

/// Arabic Messages
class ArMessages implements LookupMessages {
  @override
  String prefixAgo() => 'منذ';

  @override
  String prefixFromNow() => 'بعد';

  @override
  String suffixAgo() => '';

  @override
  String suffixFromNow() => '';

  @override
  String lessThanOneMinute(int seconds) {
    if (seconds == 0) {
      return 'لحظة';
    } else if (seconds == 1) {
      return 'ثانية واحدة';
    } else if (seconds == 2) {
      return 'ثانيتين';
    } else if (seconds > 2 && seconds < 11) {
      return '${_arabicNumber(seconds)} ثواني';
    } else {
      return '${_arabicNumber(seconds)} ثانية';
    }
  }

  @override
  String aboutAMinute(int minutes) => 'دقيقة تقريباً';

  @override
  String minutes(int minutes) {
    if (minutes == 2) {
      return 'دقيقتين';
    } else if (minutes > 2 && minutes < 11) {
      return '${_arabicNumber(minutes)} دقائق';
    } else {
      return '${_arabicNumber(minutes)} دقيقة';
    }
  }

  @override
  String aboutAnHour(int minutes) => 'ساعة تقريباً';

  @override
  String hours(int hours) {
    if (hours == 2) {
      return 'ساعتين';
    } else if (hours > 2 && hours < 11) {
      return '${_arabicNumber(hours)} ساعات';
    } else {
      return '${_arabicNumber(hours)} ساعة';
    }
  }

  @override
  String aDay(int hours) => 'يوم';

  @override
  String days(int days) {
    if (days == 2) {
      return 'يومين';
    } else if (days > 2 && days < 11) {
      return '${_arabicNumber(days)} أيام';
    } else {
      return '${_arabicNumber(days)} يوم';
    }
  }

  @override
  String aboutAMonth(int days) => 'شهر تقريباً';

  @override
  String months(int months) {
    if (months == 2) {
      return 'شهرين';
    } else if (months > 2 && months < 11) {
      return '${_arabicNumber(months)} أشهر';
    } else if (months > 10) {
      return '${_arabicNumber(months)} شهر';
    }
    return '${_arabicNumber(months)} شهور';
  }

  @override
  String aboutAYear(int year) => 'سنة تقريباً';

  @override
  String years(int years) {
    if (years == 2) {
      return 'سنتين';
    } else if (years > 2 && years < 11) {
      return '${_arabicNumber(years)} سنوات';
    } else {
      return '${_arabicNumber(years)} سنة';
    }
  }

  @override
  String wordSeparator() => ' ';
}

/// Arabic short Messages
class ArShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => '';

  @override
  String suffixFromNow() => '';

  @override
  String lessThanOneMinute(int seconds) => '$seconds ث';

  @override
  String aboutAMinute(int minutes) => '~١ د';

  @override
  String minutes(int minutes) => '$minutes د';

  @override
  String aboutAnHour(int minutes) => '~١ س';

  @override
  String hours(int hours) => '$hours س';

  @override
  String aDay(int hours) => '~١ ي';

  @override
  String days(int days) => '$days ي';

  @override
  String aboutAMonth(int days) => '~١ ش';

  @override
  String months(int months) => '$months ش';

  @override
  String aboutAYear(int year) => '~١ س';

  @override
  String years(int years) => '$years س';

  @override
  String wordSeparator() => ' ';
}

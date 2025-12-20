import 'package:bs_utils/bs_utils.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_setting.dart';
import 'supported_locale.dart';

L10nR l10nR = L10nR.instance;

class L10nR {
  L10nR._();

  static final instance = L10nR._();

  late SupportedLocale Function([WidgetRef? ref]) _currentLocale;

  SupportedLocale Function([WidgetRef? ref]) get currentLocale => _currentLocale;

  /// This method must be called prior to using this class.
  ///
  /// ex: `l10nR.setCurrentLocaleCallback(callback);`
  ///
  /// ```dart
  /// SupportedLocale callback([WidgetRef? ref]) {
  ///   SupportedLocale? locale;
  ///   final context = RoutesBase.activeContext;
  ///   if (ref != null) {
  ///     final settingsLocale = ref.watch(settingProvider.select((p) => p.locale));
  ///     locale = SupportedLocale.fromLocale(settingsLocale!);
  ///   } else if (context != null) {
  ///     final settingsLocale = context.read(settingProvider).locale;
  ///     locale = SupportedLocale.fromLocale(settingsLocale!);
  ///   }
  ///   return locale ?? SupportedLocale.ar; // or the other fallback value in `SupportedLocale`
  /// }
  /// ```
  ///
  /// The above example will watch for changes to app locale settings
  /// and update lively IF ref is passed. Otherwise it will get the current
  /// locale setting and return the proper string value without watching for
  /// changes, this can be used when no critical update is required like showing
  /// toasts and dialogs and other circumstances when it is never possible for
  /// the locale to change meanwhile.
  void setCurrentLocaleCallback(SupportedLocale Function([WidgetRef? ref]) currentLocale) =>
      _currentLocale = currentLocale;

  //  String numString(Object number) {
  //   assert(number is String || number is int || number is double);
  //   final result = Intl.message(number.toString());
  //   print('result $result');
  //   return result;
  // }

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
    _ => throw ArgumentError('Invalid Number, must be between 0 to 9, got $arabicNumber'),
  };

  /// Return (So Called) Arabic Numbered String in case App Locale is Arabic
  /// otherwise return normal String
  ///
  /// Ex: L10nR.tNumString('ABC 123') => 'ABC ١٢٣'
  /// Ex: L10nR.tNumString('Beep بييب') => 'Beep بييب'
  String tNumString(Object numbers, [WidgetRef? ref]) {
    assert(numbers is String || numbers is num);
    final supportedLocale = _currentLocale(ref);
    final string = numbers.toString();
    if (!supportedLocale.isArabic) return string;

    String soCalledArabicNumberedString;

    soCalledArabicNumberedString = string.replaceAllMapped(RegExp(r'(\d+)'), (match) {
      // print('match.groupCount ${match.groupCount}');
      // print('match.group ${match.group(0)}');
      // print('match.start ${match.start}');
      // print('match.end ${match.end}');
      // print('match.input ${match.input}');
      // print('match.pattern ${match.pattern}');
      final matchedString = match.group(0)!;
      final buffer = StringBuffer();
      for (final number in matchedString.characters) {
        buffer.write(_soCalledArabicNumberString(number));
      }
      return buffer.toString();
    });
    return soCalledArabicNumberedString;
  }

  String _numberToWord(String number, [WidgetRef? ref]) => switch (number) {
    '0' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'zero',
      SupportedLocale.ar => 'صفر',
    },
    '1' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'one',
      SupportedLocale.ar => 'واحد',
    },
    '2' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'two',
      SupportedLocale.ar => 'اثنان',
    },
    '3' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'three',
      SupportedLocale.ar => 'ثلاثة',
    },
    '4' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'four',
      SupportedLocale.ar => 'اربعة',
    },
    '5' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'five',
      SupportedLocale.ar => 'خمسة',
    },
    '6' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'six',
      SupportedLocale.ar => 'ستة',
    },
    '7' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'seven',
      SupportedLocale.ar => 'سبعة',
    },
    '8' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'eight',
      SupportedLocale.ar => 'ثمانية',
    },
    '9' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'nine',
      SupportedLocale.ar => 'تسعة',
    },
    '10' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'ten',
      SupportedLocale.ar => 'عشرة',
    },
    '11' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'eleven',
      SupportedLocale.ar => 'احدى عشرة',
    },
    '12' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twelve',
      SupportedLocale.ar => 'اثنا عشرة',
    },
    '13' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirteen',
      SupportedLocale.ar => 'ثلاثة عشرة',
    },
    '14' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fourteen',
      SupportedLocale.ar => 'اربعة عشرة',
    },
    '15' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifteen',
      SupportedLocale.ar => 'خمسة عشرة',
    },
    '16' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'sixteen',
      SupportedLocale.ar => 'ستة عشرة',
    },
    '17' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'seventeen',
      SupportedLocale.ar => 'سبعة عشرة',
    },
    '18' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'eighteen',
      SupportedLocale.ar => 'ثمانية عشرة',
    },
    '19' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'nineteen',
      SupportedLocale.ar => 'تسعة عشرة',
    },
    '20' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty',
      SupportedLocale.ar => 'عشرون',
    },
    '21' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty one',
      SupportedLocale.ar => 'واحد وعشرون',
    },
    '22' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty two',
      SupportedLocale.ar => 'اثنان وعشرون',
    },
    '23' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty three',
      SupportedLocale.ar => 'ثلاثة وعشرون',
    },
    '24' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty four',
      SupportedLocale.ar => 'اربعة وعشرون',
    },
    '25' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty five',
      SupportedLocale.ar => 'خمسة وعشرون',
    },
    '26' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty six',
      SupportedLocale.ar => 'ستة وعشرون',
    },
    '27' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty seven',
      SupportedLocale.ar => 'سبعة وعشرون',
    },
    '28' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty eight',
      SupportedLocale.ar => 'ثمانية وعشرون',
    },
    '29' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'twenty nine',
      SupportedLocale.ar => 'تسعة وعشرون',
    },
    '30' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty',
      SupportedLocale.ar => 'ثلاثون',
    },
    '31' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty one',
      SupportedLocale.ar => 'واحد وثلاثون',
    },
    '32' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty two',
      SupportedLocale.ar => 'اثنان وثلاثون',
    },
    '33' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty three',
      SupportedLocale.ar => 'ثلاثة وثلاثون',
    },
    '34' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty four',
      SupportedLocale.ar => 'اربعة وثلاثون',
    },
    '35' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty five',
      SupportedLocale.ar => 'خمسة وثلاثون',
    },
    '36' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty six',
      SupportedLocale.ar => 'ستة وثلاثون',
    },
    '37' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty seven',
      SupportedLocale.ar => 'سبعة وثلاثون',
    },
    '38' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty eight',
      SupportedLocale.ar => 'ثمانية وثلاثون',
    },
    '39' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'thirty nine',
      SupportedLocale.ar => 'تسعة وثلاثون',
    },
    '40' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty',
      SupportedLocale.ar => 'أربعون',
    },
    '41' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty one',
      SupportedLocale.ar => 'واحد وأربعون',
    },
    '42' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty two',
      SupportedLocale.ar => 'اثنان وأربعون',
    },
    '43' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty three',
      SupportedLocale.ar => 'ثلاثة وأربعون',
    },
    '44' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty four',
      SupportedLocale.ar => 'اربعة وأربعون',
    },
    '45' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty five',
      SupportedLocale.ar => 'خمسة وأربعون',
    },
    '46' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty six',
      SupportedLocale.ar => 'ستة وأربعون',
    },
    '47' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty seven',
      SupportedLocale.ar => 'سبعة وأربعون',
    },
    '48' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty eight',
      SupportedLocale.ar => 'ثمانية وأربعون',
    },
    '49' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'forty nine',
      SupportedLocale.ar => 'تسعة وأربعون',
    },
    '50' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty',
      SupportedLocale.ar => 'خمسون',
    },
    '51' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty one',
      SupportedLocale.ar => 'واحد وخمسون',
    },
    '52' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty two',
      SupportedLocale.ar => 'اثنان وخمسون',
    },
    '53' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty three',
      SupportedLocale.ar => 'ثلاثة وخمسون',
    },
    '54' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty four',
      SupportedLocale.ar => 'اربعة وخمسون',
    },
    '55' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty five',
      SupportedLocale.ar => 'خمسة وخمسون',
    },
    '56' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty six',
      SupportedLocale.ar => 'ستة وخمسون',
    },
    '57' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty seven',
      SupportedLocale.ar => 'سبعة وخمسون',
    },
    '58' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty eight',
      SupportedLocale.ar => 'ثمانية وخمسون',
    },
    '59' => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'fifty nine',
      SupportedLocale.ar => 'تسعة وخمسون',
    },
    _ => throw ArgumentError('Invalid Number, must be between 0 to 59, got $number'),
  };

  /// Coverts numbers to words
  /// Only Integers between 1 to 59 others are not converted
  /// ex: 20 => 'twenty'
  /// ex: Added 10 Seconds => 'Added ten Seconds'
  String tNumberToWords(Object numbers, [WidgetRef? ref]) {
    assert(numbers is String || numbers is num);
    final string = numbers.toString();

    return string.replaceAllMapped(RegExp(r'(\d+)'), (match) {
      final number = match.group(0)!;
      final buffer = StringBuffer();

      final intNumber = int.tryParse(number);

      /// Lovely Dart:
      /// This line doesn't compile error: "receiver can be null".
      // if (intNumber.inRange(IntRange(1, 59)) && intNumber != null) {
      /// However this line is ok, hence how `&&` efficiently works in dart.
      if (intNumber != null && intNumber.inRange(IntRange(1, 59))) {
        // Only Integers between 1 to 59
        buffer.write(_numberToWord(number, ref));
      } else {
        buffer.write(number);
      }
      return buffer.toString();
    });
  }

  String tHomePageTitle([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Home',
    SupportedLocale.ar => 'الرئيسية',
  };

  String tSettings([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Settings',
    SupportedLocale.ar => 'الضبط',
  };

  String tVoiceActions([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Voice Actions',
    SupportedLocale.ar => 'الأوامر الصوتية',
  };

  String tGENERAL([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'GENERAL',
    SupportedLocale.ar => 'عام',
  };

  String tLanguage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Language',
    SupportedLocale.ar => 'اللغة',
  };

  String tChangeLanguage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Change Language',
    SupportedLocale.ar => 'تغيير اللغة',
  };

  String tRestIsCountingDown([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Rest is counting down',
    SupportedLocale.ar => 'وقت الراحة قيد العد',
  };

  String tTimerIsPaused([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Timer is paused',
    SupportedLocale.ar => 'المؤقت معلق',
  };

  String tTimerHasNotStartedYet([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Timer has not started yet',
    SupportedLocale.ar => 'المؤقت لم يبدأ بعد',
  };

  String tSpokenContentLanguage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Spoken Content Language',
    SupportedLocale.ar => 'لغة المحتوى المنطوق',
  };

  String tChangeSpokenContentLanguage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Change Spoken Content Language',
    SupportedLocale.ar => 'تغيير لغة المحتوى المنطوق',
  };

  String tCountBeforeStart([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Count Before Start',
    SupportedLocale.ar => 'العد قبل البدء',
  };

  String tSayReadyBeforeGo([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Say "Ready" Before Rest Is Over',
    SupportedLocale.ar => 'النطق ب "استعد" قبل انتهاء الراحة',
  };

  String tEnableSpokenContent([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Enable Spoken Content',
    SupportedLocale.ar => 'تمكين الكلام المنطوق',
  };

  String tSpeakCountBeforeStart([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Speak Count Before Start',
    SupportedLocale.ar => 'النطق بالعد قبل البدء',
  };

  String tSpeakRestTime([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Speak Rest Time',
    SupportedLocale.ar => 'النطق بوقت الراحة',
  };

  String tSayGoWhenRestIsOver([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Say "${tGO(ref)}" When Rest Is Over',
    SupportedLocale.ar => 'النطق ب "${tGO(ref)}" عند انتهاء الراحة',
  };

  String tHalfTotalTimeReminder([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Half Total Time Reminder',
    SupportedLocale.ar => 'تذكير بمنتصف الوقت الكلي',
  };

  String tNearEndReminder([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Near End Reminder',
    SupportedLocale.ar => 'تذكير باقتراب النهاية',
  };

  String tSpokenActions([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Spoken Actions',
    SupportedLocale.ar => 'الأوامر المنطوقة',
  };

  String tEnableFeature([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Enable Feature',
    SupportedLocale.ar => 'تمكين الخاصية',
  };

  String tActionsList([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Actions List',
    SupportedLocale.ar => 'قائمة الأوامر',
  };

  String tRestTriggerByMicrophone([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Rest Trigger by Microphone',
    SupportedLocale.ar => 'تفعيل الراحة بالميكروفون',
  };

  String tTriggerMode([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Trigger Mode:',
    SupportedLocale.ar => 'وضع التفعيل:',
  };

  String tTriggerModeDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Select what happens when voice raise is detected.',
    SupportedLocale.ar => 'اختر ما يحدث عند استشعار رفع الصوت.',
  };

  String tVoiceInput([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Voice Input:',
    SupportedLocale.ar => 'دخل الصوت:',
  };

  String tChooseVoiceInput([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Choose Voice Input:',
    SupportedLocale.ar => 'اختر دخل الصوت:',
  };

  String tVoiceInputsAreUpToDate([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Voice Inputs are up to date.',
    SupportedLocale.ar => 'أجهزة الإدخال محدثة',
  };

  String tUpdatedVoiceInputDevices([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Updated Voice Input Devices',
    SupportedLocale.ar => 'تم تحديث أجهزة الإدخال الصوتية',
  };

  String tRestToDefaultSettings([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Reset to Default Settings',
    SupportedLocale.ar => 'اعادة تعيين الإعدادات الافتراضية',
  };

  String tRestBoardingTour([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Reset Boarding Tour',
    SupportedLocale.ar => 'إعادة الشاشة الافتتحاية',
  };

  String tSuccess([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Success',
    SupportedLocale.ar => 'تم بنجاح',
  };

  String tBoardingResetMessage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'You will now be navigated back to boarding screen.',
    SupportedLocale.ar => 'سيتم الآن إرجاعك إلى الشاشة الافتتاحية.',
  };

  String tNext([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Next',
    SupportedLocale.ar => 'التالي',
  };

  String tSkip([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Skip',
    SupportedLocale.ar => 'تخطي',
  };

  String tGotIt([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'GOT IT',
    SupportedLocale.ar => 'أعي ذلك',
  };

  String tGetStarted([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'GET STARTED',
    SupportedLocale.ar => 'إبدأ الآن',
  };

  String tByContinuingYouAcceptOur([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'By continuing, you accept our',
    SupportedLocale.ar => 'بالمتابعة، فأنت تقبل',
  };

  String tYouCanShowBoardingAgain([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'You can show the boarding tour again by resetting it in:\n\n'
          '${tSettings(ref)} > ${tRESET(ref)} > ${tRestBoardingTour(ref)}.',
    SupportedLocale.ar =>
      'يمكنك إظهار الشاشة الافتتحاية مرة أخرى من خلال الذهاب إلى:\n\n'
          '${tSettings(ref)} > ${tRESET(ref)} > ${tRestBoardingTour(ref)}.',
  };

  String tRestOnlyTriggerDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Only use the mic to start the rest count down '
          'if a voice raise is detected according to trigger sensitivity.',
    SupportedLocale.ar =>
      'استخدم الميكروفون فقط لبدء العد التنازلي للراحة '
          'عند استشعار ارتفاع في الصوت وفقًا لحساسية التفعيل.',
  };

  String tTriggerSensitivity([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Trigger Sensitivity',
    SupportedLocale.ar => 'حساسية التفعيل',
  };

  String t100MayNotBeReached([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'NOTE: 100% may never be reached',
    SupportedLocale.ar => 'ملاحظة: ١٠٠% قد لا يتم الوصول إليها',
  };

  String tChangeThemeMode([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Change Theme Mode',
    SupportedLocale.ar => 'تغيير وضع السمة',
  };

  String tThemeMode([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Theme Mode',
    SupportedLocale.ar => 'وضع السمة',
  };

  String tDeviceLanguageColon([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Device Language: ',
    SupportedLocale.ar => 'لغة الجهاز: ',
  };

  String tAppLanguage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'App Language',
    SupportedLocale.ar => 'لغة التطبيق',
  };

  String get tColonSpace => ': ';

  String tAuto([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Auto',
    SupportedLocale.ar => 'تلقائي',
  };

  String tLight([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Light',
    SupportedLocale.ar => 'مضيء',
  };

  String tDark([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Dark',
    SupportedLocale.ar => 'داكن',
  };

  String localeSettingDisplayName(LocaleSetting setting, [WidgetRef? ref]) => switch (setting) {
    LocaleSetting.auto => switch (_currentLocale(ref)) {
      SupportedLocale.en => 'Device Language',
      SupportedLocale.ar => 'لغة الجهاز',
    },
    _ => SupportedLocale.fromLocale(setting.locale!).displayName,
  };

  String tTimerAndSpokenContentCAPS([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'TIMER AND SPOKEN CONTENT',
    SupportedLocale.ar => 'المؤقت و الكلام المنطوق',
  };

  String tVoiceActionsCAPS([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'VOICE ACTIONS',
    SupportedLocale.ar => 'الأوامر الصوتية',
  };

  String tVoiceTriggerCAPS([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'VOICE TRIGGER',
    SupportedLocale.ar => 'التفعيل الصوتي',
  };

  String tVoiceActionsIsEnabled([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Voice Actions Is Enabled',
    SupportedLocale.ar => 'الأوامر الصوتية ممكّنة',
  };

  String tVoiceActionsIsDisabled([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Voice Actions Is Disabled',
    SupportedLocale.ar => 'الأوامر الصوتية معطلة',
  };

  String tBeta([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Beta',
    SupportedLocale.ar => 'تجريبي',
  };

  String tCannotBeEnabledWithRestOnly([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    // SupportedLocale.en => 'Switch OFF ${tRestTriggerByMicrophone(ref)} to enable Voice Actions',
    SupportedLocale.en => 'Cannot be enabled when ${tRestTriggerByMicrophone(ref)} is ON',
    SupportedLocale.ar =>
      'لا يمكن تمكين الأوامر الصوتية عند تفعيل ${tRestTriggerByMicrophone(ref)}',
  };

  String tCannotAccessMicrophone([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    // SupportedLocale.en => 'Switch OFF ${tRestTriggerByMicrophone(ref)} to enable Voice Actions',
    SupportedLocale.en => 'Cannot access microphone',
    SupportedLocale.ar => 'لا يمكن الوصول للميكروفون',
  };

  String tMicIsNotResponsiveRefreshing([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Mic is not responsive, refreshing ...',
    SupportedLocale.ar => 'الميكروفون لا يستجيب، إعادة المحاولة...',
  };

  String tMicChangedMonitoringRestarted([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Mic changed, monitoring restarted',
    SupportedLocale.ar => 'تغير الميكروفون، إعادة المتابعة',
  };

  String tNotAvailableWhileRecognizing([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Live Amplitude Meter Not available while recognizing speech',
    SupportedLocale.ar => 'موشر درجة الصوت غير متاح أثناء التعرف على الكلام المنطوق',
  };

  String tNotAvailableWhileMonitoring([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Live Amplitude Meter is not available while voice monitoring',
    SupportedLocale.ar => 'موشر درجة الصوت غير متاح أثناء المتابعة',
  };

  String tEitherRestTriggerOrVoiceActions([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Either ${tRestTriggerByMicrophone(ref)} '
          'or ${tVoiceActions()} must be ON.',
    SupportedLocale.ar => 'قم ب ${tRestTriggerByMicrophone(ref)} أو تمكين خاصية ${tVoiceActions()}',
  };

  String tThree([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Three',
    SupportedLocale.ar => 'ثلاثة',
  };

  String tTwo([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Two',
    SupportedLocale.ar => 'اثنين',
  };

  String tOne([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'One',
    SupportedLocale.ar => 'واحد',
  };

  String tGO([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'GO',
    SupportedLocale.ar => 'انطلق',
  };

  /// Toasts
  String tThemeChangeCoolDown([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Theme change cooling down',
    SupportedLocale.ar => 'تغيير سمة الجهاز قيد الانتظار',
  };

  String tLongTapToFollowDeviceTheme([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Long Tap to follow Device theme',
    SupportedLocale.ar => 'اضغط لفترة طويلة لمتابعة سمة الجهاز',
  };

  String tNowYouFollowDeviceTheme([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Now you follow Device theme',
    SupportedLocale.ar => 'أنت الآن تتبع سمة الجهاز',
  };

  String localeToolTip([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Language Menu',
    SupportedLocale.ar => 'قائمة اللغة',
  };

  String online([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Online',
    SupportedLocale.ar => 'متصل',
  };

  String lastSeenRecently([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Last Seen Recently',
    SupportedLocale.ar => 'آخر ظهور كان قريبا',
  };

  String waitingForNetwork([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Waiting for network...',
    SupportedLocale.ar => 'في انتظار الشبكة...',
  };

  String tToastInternetConnected([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Connected to Internet',
    SupportedLocale.ar => 'متصل بالإنترنت',
  };

  String tToastInternetDisconnected([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Internet connection is lost',
    SupportedLocale.ar => 'انقطع الاتصال بالإنترنت',
  };

  String tToastNoInternetConnection([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'No Internet Connection',
    SupportedLocale.ar => 'لا يوجد اتصال بالإنترنت',
  };

  String tCheckInternetConnection([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Check your internet connection.',
    SupportedLocale.ar => 'تحقق من الاتصال بالإنترنت.',
  };

  String tToastEmailNotValid([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Email is not Valid',
    SupportedLocale.ar => 'البريد الإلكتروني غير صالح',
  };

  String tToastEmailUsed([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Email is already in use',
    SupportedLocale.ar => 'البريد الإلكتروني مستخدم من قبل',
  };

  String tToastPhoneUsed([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Phone number is already used',
    SupportedLocale.ar => 'رقم الهاتف مستخدم من قبل',
  };

  String tNotFound([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Not found',
    SupportedLocale.ar => 'غير موجود',
  };

  String tLoginMethods([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Login Methods',
    SupportedLocale.ar => 'طرق تسجيل الدخول',
  };

  String tAlreadyExists([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Already Exists',
    SupportedLocale.ar => 'موجود بالفعل',
  };

  String tNoAccountCreatedWith(
    String email,
    String thirdPartyName, [
    WidgetRef? ref,
  ]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'There is no account connected to your $thirdPartyName account: $email',
    SupportedLocale.ar => 'لم يتم إنشاء حساب باستخدام حساب $thirdPartyName ذا $tLabelEmail: $email',
  };

  String tLoginMethodsDialogueContent(
    String email,
    List<String> methods,
    String? thirdPartyName, [
    WidgetRef? ref,
  ]) {
    var listString = '';
    if (methods.length == 1) {
      listString = methods.first;
    } else {
      listString += '\n';
      for (final method in methods) {
        listString += '\n - $method';
      }
    }
    return switch (_currentLocale(ref)) {
      SupportedLocale.en =>
        'You can login to your account $email via $listString'
            '${thirdPartyName != null ? '\n\nAdd $thirdPartyName as a login method ?' : ''}',
      SupportedLocale.ar =>
        'يمكنك تسجيل الدخول لحسابك $email عن طريق $listString'
            '${thirdPartyName != null ? '\n\nأضف $thirdPartyName كطريقة أخرى لتسجيل الدخول ؟' : ''}',
    };
  }

  String tKeepDefault([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Keep Default',
    SupportedLocale.ar => 'إبقاء الأصل',
  };

  String tHide([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Hide',
    SupportedLocale.ar => 'إخفاء',
  };

  String tHideMenu([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Hide Menu',
    SupportedLocale.ar => 'إخفاء القائمة',
  };

  String tTapOnIcon(String name, [WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Tap on $name Icon',
    SupportedLocale.ar => 'قم بالنقر على علامة $name',
  };

  String tToastResetEmailSent([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Password reset email has been sent',
    SupportedLocale.ar => 'تم إرسال بريد إلكتروني لإعادة تعيين كلمة المرور',
  };

  String tToastPleaseCheckYouInbox([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Please check your inbox',
    SupportedLocale.ar => 'برجاء مراجعة صندوق الرسائل',
  };

  //  String get tToastUserNotFoundSignUp => switch(currentLocale {SupportedLocale.en=>tToastUserNotFoundSignUp,SupportedLocale.ar => throw UnimplementedError(),};
  String tToastIncorrectEmailOrPassword([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Incorrect email or password',
    SupportedLocale.ar => 'البريد أو كلمة المرور غير صحيحة',
  };

  String tToastIncorrectPassword([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Incorrect password',
    SupportedLocale.ar => 'كلمة المرور غير صحيحة',
  };

  String tToastRedirecting([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Redirecting ...',
    SupportedLocale.ar => 'تتم إعادة التوجيه ...',
  };

  String tToastWeakPassword([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Password is too weak',
    SupportedLocale.ar => 'كلمة المرورو ضعيفة',
  };

  String tTooManyAttemptsWithTry([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Too many attempts - Try again later',
    SupportedLocale.ar => 'قد قمت بالعديد من المحاولات، حاول لاحقًا',
  };

  String tToastCouldNotSendOTP([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Could Not Send OTP Code',
    SupportedLocale.ar => 'لم نتمكن من إرسال رمز التحقق',
  };

  String tToastCouldNotResendOTP([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Could not resend OTP code',
    SupportedLocale.ar => 'لم نتمكن من إعادة إرسال رمز التحقق',
  };

  //  String get tToastDeviceNotAuthorized => switch (currentLocale) {
  //       SupportedLocale.en => 'App not authorized',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };

  //  String get tToastCodeSentCheckInbox => switch (currentLocale) {
  //       SupportedLocale.en => 'Code is Sent - Check Inbox',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };

  //  String get tToastInvalidOTP => switch (currentLocale) {
  //       SupportedLocale.en => 'Code is not correct',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };
  //
  //  String get tToastEmailUpdateRecentLogin => switch (currentLocale) {
  //       SupportedLocale.en => 'Email update requires recent login',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };
  //
  //  String get tToastEmailIsUsed => switch (currentLocale) {
  //       SupportedLocale.en => 'E-mail is used by another Account',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };
  //
  //  String get tToastPhoneIsUsed => switch (currentLocale) {
  //       SupportedLocale.en => 'Phone is used by another Account',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };
  //
  //  String get tToastDefaultErrorWithTry => switch (currentLocale) {
  //       SupportedLocale.en => 'Something went wrong - Try again later',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };

  String tToastDefaultError([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Something went wrong',
    SupportedLocale.ar => 'نأسف حدث خطأ',
  };

  //  String get tToastRecoveryEmailSent => switch (currentLocale) {
  //       SupportedLocale.en => 'Check your inbox',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };

  //  String get tToastNotFoundEmailRecovery => switch (currentLocale) {
  //       SupportedLocale.en => 'Email does not exist',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };

  //  String get tToastSigningCancelled => switch (currentLocale) {
  //       SupportedLocale.en => 'Signing Cancelled',
  //       SupportedLocale.ar => throw UnimplementedError(),
  //     };

  String tToastCancelled([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Cancelled',
    SupportedLocale.ar => 'تم الإنهاء',
  };

  String tToastGettingLocation([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Getting current Location',
    SupportedLocale.ar => 'جاري تحديد الموقع',
  };

  String tToastYouAreSignedOut([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'You are signed out',
    SupportedLocale.ar => 'لقد تم تسجيل خروجك',
  };

  String tToastLoginAgain([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Login Again',
    SupportedLocale.ar => 'سجل دخول مرة أخرى',
  };

  String tToastNothingUpdated([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Nothing is updated',
    SupportedLocale.ar => 'لم يتم التحديث',
  };

  String tToastNameUpdated([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Name updated successfully',
    SupportedLocale.ar => 'تم تحديث الإسم بنجاح',
  };

  String tToastEmailUpdated([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Email updated successfully',
    SupportedLocale.ar => 'تم تحديث البريد الإلكتروني بنجاح',
  };

  String tToastBirthdayUpdated([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Birthday updated successfully',
    SupportedLocale.ar => 'تم تحديث تاريخ الميلاد بنجاح',
  };

  String tToastPhoneUpdated([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Phone updated successfully',
    SupportedLocale.ar => 'تم تحديث رقم الهاتف بنجاح',
  };

  String tToastCameraNotAllowed([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Camera permission not allowed',
    SupportedLocale.ar => 'إذن الكاميرا غير مسموح به',
  };

  String tToastGettingRoute([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Finding optimal route',
    SupportedLocale.ar => 'جاري تحديد أفضل مسار',
  };

  String tToastRouteSetSuccess([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Route is set successfully',
    SupportedLocale.ar => 'تم تحديد المسار بنجاح',
  };

  String tToastTryAgainLater([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Try again later',
    SupportedLocale.ar => 'حاول مرة أخرى لاحقا',
  };

  String tToastSelectVehicleType([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Select Vehicle Type',
    SupportedLocale.ar => 'حدد نوع المركبة',
  };

  String tToastUploadAllRequiredImages([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Upload All Required Images',
    SupportedLocale.ar => 'برجاء رفع كل الصور المطلوبة',
  };

  String tVehicleRegister([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Vehicle Register',
    SupportedLocale.ar => 'تسجيل المركبة',
  };

  String tToastRegisteredSuccessfully([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Registered Successfully',
    SupportedLocale.ar => 'تم التسجبل بنجاح',
  };

  String tToastTripIsPublished([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Your Trip is successfully published',
    SupportedLocale.ar => 'تم نشر رحلتك بنجاح',
  };

  String tToastTripIsDeleted([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Trip is deleted successfully',
    SupportedLocale.ar => 'تم حذف الرحلة بنجاح',
  };

  String tToastNoRoute([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'No route can be found',
    SupportedLocale.ar => 'لا يمكن تحدبد المسار',
  };

  String tToastSigningOut([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Signing Out',
    SupportedLocale.ar => 'جاري تسجيل الخروج',
  };

  String tToastTapIsEnough([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Tap is just enough',
    SupportedLocale.ar => 'اللمسة القصبرة تكفي',
  };

  String tToastRecordAtLeastHalfSecond([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Record at least half a second',
    SupportedLocale.ar => 'سجل نصف ثانية على الأقل',
  };

  /// On Screen Text Widgets
  // Top Level Screen
  //    String get tSetTime => switch (_currentLocale) {
  //         SupportedLocale.en => 'Set Time',
  //         SupportedLocale.ar => 'اضبط الوقت',
  //       };
  //
  //    String get tTimezone => switch (_currentLocale) {
  //         SupportedLocale.en => 'Timezone',
  //         SupportedLocale.ar => 'المنطقة الزمنية',
  //       };
  //
  //    String get tDevice => switch (_currentLocale) {
  //         SupportedLocale.en => 'Device',
  //         SupportedLocale.ar => 'الجهاز',
  //       };
  //
  //    String tSetTimeStatement(bool isNegative) => switch (_currentLocale) {
  //         SupportedLocale.en => 'You device clock is '
  //             '${isNegative ? 'preceding' : 'ahead of'} timezone clock.',
  //         SupportedLocale.ar => 'ساعة الجهاز '
  //             '${isNegative ? 'متأخرة عن' : 'متقدمة عن'} المنطقة الزمنية.',
  //       };
  //
  //    String get tHour => switch (_currentLocale) {
  //         SupportedLocale.ar => 'ساعة',
  //         SupportedLocale.en => 'Hour',
  //       };
  //
  //    String get tMinute => switch (_currentLocale) {
  //         SupportedLocale.ar => 'دقيقة',
  //         SupportedLocale.en => 'Mintue',
  //       };
  //
  //    String get tSecond => switch (_currentLocale) {
  //         SupportedLocale.ar => 'ثانية',
  //         SupportedLocale.en => 'Second',
  //       };

  //  String tRestTime(int minutes, int seconds) => ''
  //     '${minutes != 0 ? _minString(minutes) : ''}'
  //     '${seconds != 0 ? _secString(seconds) : ''}';

  // Consider to Try It with Intl.message
  String minString(int minutes, [WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => switch (minutes) {
      1 => ' دقيقة',
      2 => ' دقيقتان',
      > 2 && < 11 => '${tNumString(minutes, ref)} دقائق',
      _ => '${tNumString(minutes, ref)} دقيقة',
    },
    SupportedLocale.en => switch (minutes) {
      1 => ' one minute',
      _ => ' $minutes minutes',
    },
  };

  String secString(int seconds, [WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => switch (seconds) {
      1 => ' ثانية',
      2 => ' ثانِيتان',
      > 2 && < 11 => '${tNumString(seconds, ref)} ثواني',
      _ => '${tNumString(seconds, ref)} ثانيةْ',
    },
    SupportedLocale.en => switch (seconds) {
      1 => ' one second',
      _ => ' $seconds seconds',
    },
  };

  //    String get tLongTime => switch (_currentLocale) {
  //         SupportedLocale.ar => 'مدة طويلة',
  //         SupportedLocale.en => 'Long Time',
  //       };
  //
  //    String tSetTimeDifferenceString(Duration difference) {
  //     final differenceAbs = difference.abs();
  //
  //     final (hourPart, minutePart, secondPart) = differenceAbs.nHHnMMnSS;
  //     final hourExists = hourPart > 0;
  //     final minuteExists = minutePart > 0;
  //     final secondExists = secondPart > 0;
  //
  //     String displayString;
  //     final isRightToLight = _currentLocale == SupportedLocale.ar;
  //
  //     /// Solo Parts
  //     if (!hourExists && !minuteExists && secondExists) {
  //       displayString = isRightToLight
  //           ? '${minutePart.lhs0IfSingle}  $tSecond'
  //           : '$tSecond ${minutePart.lhs0IfSingle}';
  //     } else if (!hourExists && minuteExists && !secondExists) {
  //       displayString =
  //           isRightToLight ? '${minutePart.lhs0IfSingle} $tMinute' : '$tMinute ${minutePart.lhs0IfSingle}';
  //     } else if (hourExists && !minuteExists && !secondExists) {
  //       displayString =
  //           isRightToLight ? '${hourPart.lhs0IfSingle} $tHour' : '$tHour ${hourPart.lhs0IfSingle}';
  //     }
  //
  //     /// Couple Parts
  //     else if (hourExists && minuteExists && !secondExists) {
  //       displayString = isRightToLight
  //           ? '${hourPart.lhs0IfSingle}:${minutePart.lhs0IfSingle} $tHour'
  //           : '$tHour ${hourPart.lhs0IfSingle}:${minutePart.lhs0IfSingle}';
  //     } else if (!hourExists && minuteExists && secondExists) {
  //       displayString = isRightToLight
  //           ? '${minutePart.lhs0IfSingle}:${secondPart.lhs0IfSingle} $tMinute'
  //           : '$tMinute ${minutePart.lhs0IfSingle}:${secondPart.lhs0IfSingle}';
  //     }
  //
  //     /// All Parts
  //     else if (hourExists && secondExists) {
  //       displayString = isRightToLight
  //           ? '${hourPart.lhs0IfSingle}:${minutePart.lhs0IfSingle}:${secondPart.lhs0IfSingle} $tHour'
  //           : '$tHour ${hourPart.lhs0IfSingle}:${minutePart.lhs0IfSingle}:${secondPart.lhs0IfSingle}';
  //     }
  //
  //     /// This is for the compiler not to yell at us
  //     else {
  //       displayString = '';
  //     }
  //     if (differenceAbs.inHours > 99) return tLongTime;
  //
  //     return switch (_currentLocale) {
  //       SupportedLocale.en => displayString,
  //       SupportedLocale.ar => displayString,
  //     };
  //   }
  //
  //    String get tSetTimeDialogueMessage {
  //     return switch (_currentLocale) {
  //       SupportedLocale.en => 'Please set the time properly before continuing to use the app.'
  //           ' This can be due to one of the following:\n\n'
  //           '- Timezone not set correctly.\n'
  //           '- Unstable internet connection.\n'
  //           '- Daylight saving changes.',
  //       SupportedLocale.ar => 'برجاء ضبط الوقت قبل الاستمرار في استخدام التطبيق.'
  //           ' يمكن أن يكون هذا التنبيه بسبب من الأسباب التالية:\n\n'
  //           '- المنطقة الزمنية غير صحيحة.\n'
  //           '- الاتصال بالانترنت غير مستقر.\n'
  //           '- تغييرات التوقيت الصيفي.',
  //     };
  //   }
  //
  String tNote([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => 'تنويه',
    SupportedLocale.en => 'Note',
  };

  String tGoogleMicRequiredMessage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Speech Recognition on Android is powered by Google. '
          'In order to use this feature, It is required that '
          'Google App has permission to access microphone.',
    SupportedLocale.ar =>
      ' يعمل التعرف على الصوت في أجهزة Android بواسطة Google. '
          'لاستخدام هذه الخاصية، يجب السماح لتطبيق Google بالوصول للميكروفون.',
  };

  String tNotAvailable([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => 'غير متاح',
    SupportedLocale.en => 'Not Available',
  };

  String tErrorEncountered([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => 'حدث خطأ',
    SupportedLocale.en => 'Error Encountered',
  };

  String tInternetRequired([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => 'يتطلب اتصال بالانترنت',
    SupportedLocale.en => 'Internet Required',
  };

  String tSpeechActivationError([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Error encountered while activating Speech Recognition on your device.',
    SupportedLocale.ar => 'حدث خطأ في تفعيل التعرف على الصوت في جهازك.',
  };

  String tInternetRequiredForSpeech([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Speech Recognition often requires internet connection in order to work, '
          'please check your internet connection.',
    SupportedLocale.ar =>
      'التعرف على الصوت الكلام المنطوق يتطلب أحيانا الاتصال بالانترنت، '
          'يرجى التحقق من الاتصال بالانترنت.',
  };

  String tSpokenContentNotAvailable([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Spoken Content is not available in ${SupportedLocale.en.displayName}.'
          '\n\nMake sure to install the ${SupportedLocale.en.displayName} '
          'voice data in Text to Speech Settings in your device.',
    SupportedLocale.ar =>
      'الكلام المنطوق غير متوفر باللغة ${SupportedLocale.ar.displayName}.'
          '\n\nيرجى التأكد من تثبيث حزمة اللغة ${SupportedLocale.ar.displayName}'
          ' في إعدادات تحويل النص إلى صوت في جهازك.',
  };

  String tSpokenContentError([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'An Error is encountered with Spoken Content.',
    // '\n\nMake sure to install the ${SupportedLocale.en.displayName} '
    // 'voice data in Text to Speech Settings in your device.',
    SupportedLocale.ar => 'حدث خطأ في الكلام المنطوق.',
    // '\n\nيرجى التأكد من تثبيث حزمة اللغة ${SupportedLocale.ar.displayName}'
    // ' في إعدادات تحويل النص إلى صوت في جهازك.',
  };

  String tConfirmAbort([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Confirm Abort',
    SupportedLocale.ar => 'تأكيد الإنهاء',
  };

  String tConfirmAbortMessage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Are you sure you want to abort the training ?',
    SupportedLocale.ar => 'هل تريد تأكيد إنهاء التمرين ؟',
  };

  String tStats([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Stats',
    SupportedLocale.ar => 'الاحصائيات',
  };

  String tTraining([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Training',
    SupportedLocale.ar => 'التمرين',
  };

  String tTrainingAdjective([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Training',
    SupportedLocale.ar => 'تمرين',
  };

  String tTrainingNumberedAdjective(int number, [WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => number > 1 ? '$number Trainings' : 'One Training',
    SupportedLocale.ar => switch (number) {
      1 => 'تمرين',
      2 => 'تمرينان',
      > 2 && < 11 => '${tNumString(number, ref)} تمارين',
      _ => '${tNumString(number, ref)} تمرين',
    },
  };

  String tDayNumberedAdjective(int number, [WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => number > 1 ? '$number Days' : 'One Day',
    SupportedLocale.ar => switch (number) {
      1 => 'يوم',
      2 => 'يومان',
      > 2 && < 11 => '${tNumString(number, ref)} أيام',
      _ => '${tNumString(number, ref)} يومًا',
    },
  };

  String tToday([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Today',
    SupportedLocale.ar => 'اليوم',
  };

  String tOverall([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Overall',
    SupportedLocale.ar => 'إجمالي',
  };

  //  String tnThTraining(int n,[WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //       SupportedLocale.en => '${n.ordinal}Training',
  //       SupportedLocale.ar => 'التمرين ???' ,
  //     };

  String tDetails([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Details',
    SupportedLocale.ar => 'التفاصيل',
  };

  String tDiscardStats([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Discard current stats',
    SupportedLocale.ar => 'تجاهل الاحصائيات الحالية',
  };

  String tSaveTraining([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Save Training',
    SupportedLocale.ar => 'حفظ التمرين',
  };

  String tCouldNotUnderstandMeaning([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Could not understand meaning',
    SupportedLocale.ar => 'لم يتم التعرف على العبارة',
  };

  String tNotAKnownCommand([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Not a known command',
    SupportedLocale.ar => 'أمر غير معروف',
  };

  String tNoSpeechDetected([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'No speech detected',
    SupportedLocale.ar => 'لم يتم اكتشاف أي كلمة',
  };

  String tLadderDismissed([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Ladder Dismissed',
    SupportedLocale.ar => 'تجاهل السلم',
  };

  String tLadderDismissedMessage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Ladder is dismissed, since no rest '
          'had been taken during workout.',
    SupportedLocale.ar =>
      'تم تجاهل السلم، لعدم  وجود '
          'أي راحة خلال التمرين.',
  };

  String tGreatJob([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Great Job! 💪👌',
    SupportedLocale.ar => 'نجاح عظيم! 💪👌',
  };

  String tLadderStats([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Ladder Stats 📊',
    SupportedLocale.ar => 'إحصائيات السلم 📊',
  };

  String tYouHaveStartedANewStreak([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    // SupportedLocale.en => 'You have started a new streak! Keep going.',
    SupportedLocale.en => 'You have started a new streak!',
    // SupportedLocale.ar => 'لقد بدءت سلسلة جديدة! استمر في التقدم.',
    SupportedLocale.ar => 'لقد بدءت سلسلة جديدة!',
  };

  //  String tMovingUpOnStreak(int day, [WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //       SupportedLocale.en => 'You are moving up on your current streak!'
  //           ' Day $day,  Keep going.',
  //       SupportedLocale.ar => 'لقد أحرزت تقدم في السلسلة الحالية!'
  //           'اليوم $day استمر في التقدم.',
  //     };
  String tMovingUpOnStreak([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    // SupportedLocale.en => 'You are moving up on your current streak! Keep going.',
    SupportedLocale.en => 'You are moving up on your current streak!',
    // SupportedLocale.ar => 'لقد أحرزت تقدم في السلسلة الحالية! استمر في التقدم.',
    SupportedLocale.ar => 'لقد أحرزت تقدم في السلسلة الحالية!',
  };

  //
  //    String get _autoSettingRelaunchRequired => switch (_currentLocale) {
  //         SupportedLocale.ar =>
  //           'سيتم تزامن اللغة مع الجهاز عند إعادة تشغيل التطبيق.$_youCanCancelByTappingTheCurrent',
  //         SupportedLocale.en =>
  //           'The language will be synced with the device when you restart the app.$_youCanCancelByTappingTheCurrent',
  //       };
  //
  //    String get _youCanCancelByTappingTheCurrent => switch (_currentLocale) {
  //         SupportedLocale.en => '\n\nYou can cancel that change by tapping the current selected language.',
  //         SupportedLocale.ar => '\n\nيمكن إلغاء هذا التغيير بالنقر على اللغة المختارة الحالية.',
  //       };
  //
  //    String langSettingRelaunchRequired(LocaleSetting setting) => switch (setting) {
  //         /// As We only show a dialogue when A DIFFERENT language is selected
  //         /// and FOR NOW They are ONLY TWO .. when more are added every LocaleSetting
  //         /// will return localized String except for the language itself
  //         /// You get the idea!
  //         LocaleSetting.arabic => 'The language will switch to Arabic when '
  //             'you restart the app.$_youCanCancelByTappingTheCurrent',
  //         LocaleSetting.english => 'ستتحول اللغة إلى الإنجليزية '
  //             'عند إعادة تشغيل التطبيق.$_youCanCancelByTappingTheCurrent',
  //
  //         /// In this case we do not know what is the current LocaleSetting
  //         /// so we provide strings for all supportedLocales
  //         LocaleSetting.auto => _autoSettingRelaunchRequired,
  //       };
  //
  //    String get tPendingRestart => switch (_currentLocale) {
  //         SupportedLocale.en => 'Pending Restart',
  //         SupportedLocale.ar => 'في انتظار إعادة التشغيل',
  //       };
  //
  //    String get markAsReadTitle => switch (_currentLocale) {
  //         SupportedLocale.ar => 'ضع علامة مقروءة',
  //         SupportedLocale.en => 'Mark As Read',
  //       };
  //
  //    String get fiveMinETATitle => switch (_currentLocale) {
  //         SupportedLocale.ar => '5 دقائق كن مستعدا',
  //         SupportedLocale.en => '5 min Be Ready',
  //       };
  //
  //    String get tenToFifteenMinETATitle => switch (_currentLocale) {
  //         SupportedLocale.ar => 'حوالي 15 دقيقة',
  //         SupportedLocale.en => 'About 15 min',
  //       };
  //
  //    String get showBookingOnMapTitle => switch (_currentLocale) {
  //         SupportedLocale.ar => 'عرض على الخريطة',
  //         SupportedLocale.en => 'Show On Map',
  //       };
  //
  //    String get acceptBookingTitle => switch (_currentLocale) {
  //         SupportedLocale.ar => 'قبول',
  //         SupportedLocale.en => 'Accept',
  //       };
  //
  //    String get rejectBookingTitle => switch (_currentLocale) {
  //         SupportedLocale.ar => 'دفض',
  //         SupportedLocale.en => 'Reject',
  //       };
  //
  //    String get dismissBookingTitle => switch (_currentLocale) {
  //         SupportedLocale.ar => 'تجاهل',
  //         SupportedLocale.en => 'Dismiss',
  //       };
  //
  //    String get fiveSeconds => switch (_currentLocale) {
  //         SupportedLocale.ar => '5 ثواني',
  //         SupportedLocale.en => '5 Seconds',
  //       };
  //
  //    String get tenSeconds => switch (_currentLocale) {
  //         SupportedLocale.ar => '10 ثواني',
  //         SupportedLocale.en => '10 Seconds',
  //       };
  //
  //    String get fifteenSeconds => switch (_currentLocale) {
  //         SupportedLocale.ar => '15 ثانية',
  //         SupportedLocale.en => '15 Seconds',
  //       };
  //
  //    String get thirtySeconds => switch (_currentLocale) {
  //         SupportedLocale.ar => '30 ثانية',
  //         SupportedLocale.en => '30 Seconds',
  //       };
  //
  //    String get minute => switch (_currentLocale) {
  //         SupportedLocale.ar => 'دقيقة',
  //         SupportedLocale.en => '1 Minute',
  //       };
  //
  //    String get twoMinutes => switch (_currentLocale) {
  //         SupportedLocale.ar => 'دقيقتان',
  //         SupportedLocale.en => '2 Minutes',
  //       };
  //
  //    String get fiveMinutes => switch (_currentLocale) {
  //         SupportedLocale.ar => '5 دقائق',
  //         SupportedLocale.en => '5 Minutes',
  //       };
  //
  //    String newMessageNPrepend(int numberOfMessages, bool htmlFormat) {
  //     switch (_currentLocale) {
  //       case SupportedLocale.en:
  //         return htmlFormat
  //             ? "<b>$numberOfMessages</b> New Message${numberOfMessages > 1 ? 's' : ''} "
  //             : "$numberOfMessages New Message${numberOfMessages > 1 ? 's' : ''} ";
  //       case SupportedLocale.ar:
  //         if (numberOfMessages == 1) {
  //           return 'رسالة جديدة';
  //         } else if (numberOfMessages == 2) {
  //           return 'رسالتان جديدتان';
  //         } else if (numberOfMessages < 10) {
  //           return htmlFormat
  //               ? '<b>$numberOfMessages</b>' ' رسائل جديدة'
  //               : ' رسائل جديدة$numberOfMessages';
  //         } else {
  //           return htmlFormat
  //               ? '<b>$numberOfMessages</b>' ' رسالة جديدة'
  //               : ' رسائل جديدة$numberOfMessages';
  //         }
  //     }
  //   }
  //
  //    String get bookingNToSubtitle => switch (_currentLocale) {
  //         SupportedLocale.ar => 'إلي:',
  //         SupportedLocale.en => 'To:',
  //       };
  //
  //    String get passwordLengthVal => switch (_currentLocale) {
  //         SupportedLocale.ar => 'يجب أن تكون كلمة المرور أطول من 8 أحرف',
  //         SupportedLocale.en => 'Password must be longer than 8 characters',
  //       };
  //
  //    String get passwordUppercaseVal => switch (_currentLocale) {
  //         SupportedLocale.ar => 'يجب أن تحتوي كلمة المرور على أحرف كبيرة',
  //         SupportedLocale.en => 'Password must contain an uppercase letter',
  //       };
  //
  //    String get passwordLowercaseVal => switch (_currentLocale) {
  //         SupportedLocale.ar => 'يجب أن تحتوي كلمة المرور على أحرف صغيرة',
  //         SupportedLocale.en => 'Password must contain a lowercase letter',
  //       };
  //
  //    String get passwordDigitVal => switch (_currentLocale) {
  //         SupportedLocale.ar => 'يجب أن تحتوي كلمة المرور على رقم',
  //         SupportedLocale.en => 'Password must contain a number',
  //       };
  //
  //    String get passwordSpecialCharacterVal => switch (_currentLocale) {
  //         SupportedLocale.ar => 'يجب أن تحتوي كلمة المرور على حرف خاص مثل @ # % & * !',
  //         SupportedLocale.en => 'Password must contain a special character e.g. @ # % & * !',
  //       };
  //
  //    String get tSetTimeIOSSettingsGuide => switch (_currentLocale) {
  //         SupportedLocale.en => 'Please Go To: \n\nSettings > General > Date & Time\n',
  //         SupportedLocale.ar => 'فضلا الانتقال إلى: \n\nالضبط > عام > الوقت والتاريخ\n',
  //       };
  //
  //    String get tExit => switch (_currentLocale) {
  //         SupportedLocale.en => 'Exit',
  //         SupportedLocale.ar => 'غلق',
  //       };
  //
  /// On Boarding
  String tBWelcomeTitle([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Welcome Champ! 💪',
    SupportedLocale.ar => 'مرحباً بالبطل! 💪',
  };

  String tBWelcomeDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'You have got the simplest and most elegant '
          'LADDERS workout timer app out there.',
    SupportedLocale.ar =>
      'أمامك أفضل تطبيق للتمرين '
          'بنظام السلالم الأكثر بساطة على الإطلاق.',
  };

  String tBLADDERSWorkout([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'LADDERS Workout',
    SupportedLocale.ar => 'تمرين السلالم',
  };

  String tBLADDERSWorkoutDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    // SupportedLocale.en => 'In LADDERS Workout you TRAIN as much as you REST.',
    // SupportedLocale.en => 'It is all about workouts perfection,'
    SupportedLocale.en =>
      'A workout that aims to perfection in every rep,'
          ' so you TRAIN as much as you REST without reaching fatigue.',
    // SupportedLocale.ar => 'نوع  يتعلق الأمر بإتقان التدريبات،'
    SupportedLocale.ar =>
      'تمرين يهدف إلى الإتقان في كل عدة،'
          ' لذا فإنك تتدرب بقدر ما تستريح دون الوصول إلى مرحلة الإجهاد.',
  };

  String tBClimbingLADDERS([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Climbing LADDERS',
    SupportedLocale.ar => 'تسلق السلالم',
  };

  String tBClimbingLADDERSDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Start by minimum #reps or holding period, and '
          'go up step by step until half way to fatigue then go back down'
          ' while resting equally to training in every step.',
    SupportedLocale.ar =>
      'إبدأ بأقل عدد من التكرارات أو فترة ثبات, '
          'ثم اصعد خطوة بخطوة حتى الوصول إلى قدر متوسط من التعب'
          ' ثم اهبط بالتدريج مع راحة مساوية للتمرين في كل خطوة.',
  };

  String tBRepeatTillEnd([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Repeat Till End',
    SupportedLocale.ar => 'كرر حتى النهاية',
  };

  String tBRepeatTillEndDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Set total time [ex: 7.5 min] and keep climbing'
          ' ladders until end, and here are some tips:'
          '\n\n- Ladders heights can differ during workout.'
          '\n- Keep it step by step up and down until timer finishes.',
    SupportedLocale.ar =>
      'اضبط الوقت الإجمالي [مثال: 7.5 دقيقة] واستمر'
          ' في تسلق السلالم حتى النهاية، وإليك بعض النصائح:'
          '\n\n- قد يختلف ارتفاع السلالم أثناء التمرين.'
          '\n- استمر في الصعود والنزول خطوة بخطوة حتى ينتهي المؤقت.',
  };

  String tBHowItWorks([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'How It Works',
    SupportedLocale.ar => 'طريقة العمل',
  };

  String tBHowItWorksDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'When Total Time starts a sub timer counts up as you TRAIN,'
          ' once you trigger REST, It reverts and counts down'
          ' the REST period, when it finishes it counts back up'
          ' notifying you to go again, and so on until Total Time ends.',
    SupportedLocale.ar =>
      'عندما يبدأ الوقت الكلي، يقوم مؤقت فرعي بالعد تصاعديا'
          ' في حالة التمرين و بمجرد تفعيل الراحة، ينعكس و يقوم بالعد تنازليا لفترة الراحة،'
          ' وعندما ينتهي، يُعْلمك لتبدأ التمرين و يقوم بالعد تصاعديا مرة أخرى،'
          ' وهكذا حتى ينتهي الوقت الكلي.',
  };

  //
  //    String get tOnBoardingDescription1 => switch (_currentLocale) {
  //         SupportedLocale.en => 'Set where you go to search the road for drivers going your way.',
  //         SupportedLocale.ar => throw UnimplementedError(),
  //       };
  //
  //    String get tOnBoardingTitle2 => switch (_currentLocale) {
  //         SupportedLocale.en => 'Choose From Rides',
  //         SupportedLocale.ar => 'اختر من الرحلات',
  //       };
  //
  //    String get tOnBoardingDescription2 => switch (_currentLocale) {
  //         SupportedLocale.en => 'Pick from found rides the one that suits you',
  //         SupportedLocale.ar => 'اختر من الرحلات الموجودة ما يناسبك',
  //       };
  //
  //    String get tOnBoardingTitle3 => switch (_currentLocale) {
  //         SupportedLocale.en => 'Nominal Fares',
  //         SupportedLocale.ar => 'أجر رمزية',
  //       };
  //
  //    String get tOnBoardingDescription3 => switch (_currentLocale) {
  //         SupportedLocale.en =>
  //           'Enjoy sedan comfort while paying very cheap fares when travelling between cities',
  //         SupportedLocale.ar => 'استمع براحة السيارة الخاصة في رحلاتك مقابل أجر رخيصة للفاية',
  //       };
  //
  //    String get tContinue => switch (_currentLocale) {
  //         SupportedLocale.en => 'Continue',
  //         SupportedLocale.ar => 'متابعة',
  //       };
  //
  //    String get tDetermineGender => switch (_currentLocale) {
  //         SupportedLocale.en => 'Determine Gender',
  //         SupportedLocale.ar => 'حدد النوع',
  //       };
  //
  // //  Login Screen
  // //    String get tDoNotHaveAccount => switch (currentLocale) {
  // //         SupportedLocale.en => 'New to ${GlobalConstants.appName} ?',
  // //         SupportedLocale.ar => ' ؟${GlobalConstants.appName}مستخدم جديد لدى ',
  // //       };
  //
  //    String get tCreateAccountCAPS => switch (_currentLocale) {
  //         SupportedLocale.en => 'CREATE ACCOUNT',
  //         SupportedLocale.ar => 'إنشاء حساب',
  //       };
  //
  //    String get tPrivacyTermsNoticeP1 => switch (_currentLocale) {
  //         SupportedLocale.en => 'By Continuing you agree to our ',
  //         SupportedLocale.ar => 'باستمرارك أنت توافق على ',
  //       };
  //
  //    String get tSpaceAndSpace => switch (_currentLocale) {
  //         SupportedLocale.en => ' and ',
  //         SupportedLocale.ar => ' و ',
  //       };
  //
  //    const tDot = '.';
  //
  //    String get tGender => switch (_currentLocale) {
  //         SupportedLocale.en => 'Gender',
  //         SupportedLocale.ar => 'النوع',
  //       };
  //
  //    String get tMale => switch (_currentLocale) {
  //         SupportedLocale.en => 'Male',
  //         SupportedLocale.ar => 'ذكـر',
  //       };
  //
  //    String get tFemale => switch (_currentLocale) {
  //         SupportedLocale.en => 'Female',
  //         SupportedLocale.ar => 'أنـثـى',
  //       };
  //
  // //  Sending Password Reset Email Screen
  // //  String get tForgotPasswordSelectTitle => switch(currentLocale {SupportedLocale.en=>tForgotPasswordSelectTitle,SupportedLocale.ar => throw UnimplementedError(),};
  // //  String get tForgotPasswordSelectSubTitle => switch(currentLocale {SupportedLocale.en=>tForgotPasswordSelectSubTitle,SupportedLocale.ar => throw UnimplementedError(),};
  //    String get tResetViaEmail => switch (_currentLocale) {
  //         SupportedLocale.en => 'Reset via E-mail',
  //         SupportedLocale.ar => 'إسترجاع بواسطة البريد الإلكتروني',
  //       };
  //
  //    String get tResetViaPhone => switch (_currentLocale) {
  //         SupportedLocale.en => 'Reset via Phone Number',
  //         SupportedLocale.ar => 'إسترجاع بواسطة رقم الهاتف',
  //       };
  //
  //    String get tResetViaEmailSubtitle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Please enter the email address linked to your account. '
  //             'You will receive a verification link, by tapping it you will be redirected '
  //             'to the app in order to reset your password.',
  //         SupportedLocale.ar => 'برجاء إدخال البريد الإلكتروني المربوط بحسابك. '
  //             'سوف يصلك رابط تحقق من خلال النقر عليه سيتم إعادة توجيهك '
  //             'إلى التطبيق من أجل إعادة تعيين كلمة المرور الخاصة بك.',
  //       };
  //
  //    String get tResetViaPhoneSubtitle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Please enter the phone number linked to your account.',
  //         SupportedLocale.ar => 'برجاء إدخال رقم الهاتف المربوط بحسابك. '
  //       };
  //
  //   ///  Confirm Password Reset Screen
  //   ///
  //    String get tSendingPasswordResetLink => switch (_currentLocale) {
  //         SupportedLocale.en => 'Sending password reset link ...',
  //         SupportedLocale.ar => 'جاري إرسال رابط الاسترجاع ...',
  //       };
  //
  //    String get tPasswordResetLinkSent => switch (_currentLocale) {
  //         SupportedLocale.en => 'Password reset link has been sent to your email. '
  //             'Please check your inbox to reset your password.\n\n'
  //             'NOTE: You need to open the link using this device.',
  //         //  as for security reasons email verification is not done using web browsers
  //         SupportedLocale.ar => 'تم إرسال رابط الاسترجاع إلى البريد الخاص بكم. '
  //             'برجاء مراجعة صندوق الرسائل.\n\n'
  //             'تنويه: لابد من فتح الرابط باستخدام هذا الجهاز.',
  //       };
  //
  //    String get tVerifyingResetCode => switch (_currentLocale) {
  //         SupportedLocale.en => 'Verifying reset link ...',
  //         SupportedLocale.ar => 'مراحعة رابط الاسترجاع ...',
  //       };
  //
  //    String get tPasswordResetExpired => switch (_currentLocale) {
  //         SupportedLocale.en => 'Password reset link is expired. Tap the button to resend a new one.',
  //         SupportedLocale.ar => 'انتهت صلاحية رابط الاسترجاع. اضغط على الزر لإعادة إرسال رابط جديد.',
  //       };
  //
  //    String get tEnterYourNewPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Enter your new password',
  //         SupportedLocale.ar => 'أدخل كلمة المرور الجدبدة',
  //       };
  //
  //    String get tResettingPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Resetting password ...',
  //         SupportedLocale.ar => 'إعادة ضبط كلمة المرور ...',
  //       };
  //
  //    String get tPasswordResetSuccessfully => switch (_currentLocale) {
  //         SupportedLocale.en => 'Password reset successfully',
  //         SupportedLocale.ar => 'تم إعادة ضبط كلمة المرور بنجاح',
  //       };
  //
  //    String get tLoginWithYourNewPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Login with your new password',
  //         SupportedLocale.ar => 'سجل دخول بكلمة المرور الجديدة',
  //       };
  //
  //    String get tCouldNotResetYourPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Could not reset your password',
  //         SupportedLocale.ar => 'لم نتمكن من إعادة ضبط كلمة المرور',
  //       };
  //
  //    String get tResendResetLink => switch (_currentLocale) {
  //         SupportedLocale.en => 'Resend Reset link',
  //         SupportedLocale.ar => 'أعد إرسال رابط الاسترجاع',
  //       };
  //
  //    String get tResetPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Reset Password',
  //         SupportedLocale.ar => 'إعادة ضبط كلمة المرور',
  //       };
  //
  //    String get tMultipleWrongAttempts => switch (_currentLocale) {
  //         SupportedLocale.en => 'Multiple Wrong Attempts',
  //         SupportedLocale.ar => 'العديد من المحاولات الخاطئة',
  //       };
  //
  //    String get tTooManyWrongsAttemptsDialogueMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Access to this account has been '
  //             'temporarily disabled due to many failed login attempts.',
  //         SupportedLocale.ar => 'تم تعطيل الدخول إلى هذا الحساب بشكل مؤقت بسبب كثرة محاولات'
  //             ' تسجيل الدخول الخاظئة.'
  //       };
  //
  //    String get tCancelVerification => switch (_currentLocale) {
  //         SupportedLocale.en => 'Cancel Verification',
  //         SupportedLocale.ar => 'إنهاء التحقق',
  //       };
  //
  //    String get tCancelRegistering => switch (_currentLocale) {
  //         SupportedLocale.en => 'Cancel Registering',
  //         SupportedLocale.ar => 'إنهاء التسجيل',
  //       };
  //
  //    String get tSkip => switch (_currentLocale) {
  //         SupportedLocale.en => 'Skip',
  //         SupportedLocale.ar => 'تخطي',
  //       };
  //
  //    String get tConfirmSkip => switch (_currentLocale) {
  //         SupportedLocale.en => 'Confirm Skip',
  //         SupportedLocale.ar => 'تأكيد التخطي',
  //       };
  //
  //    String get tVerificationMethod => switch (_currentLocale) {
  //         SupportedLocale.en => 'Verification Method',
  //         SupportedLocale.ar => 'طريقة التحقق',
  //       };
  //
  //    String get accountCreatedSuccessfully => switch (_currentLocale) {
  //         SupportedLocale.en => 'Account Created Successfully',
  //         SupportedLocale.ar => 'تم إنشاء الحساب بنجاح',
  //       };
  //
  //    String get tCancelVerificationDialogueMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'If you cancel email verification '
  //             'this step will not be skipped. You need to verify your '
  //             'email first.\n\n'
  //             'Do you want to cancel the verification ?',
  //         SupportedLocale.ar => 'في حالة إنهاء التحقق من البريد الإلكتروني '
  //             'لن يتم تجاوز هذه الخطوة. لابد من إتمام التحقق أولاً.\n\n'
  //             'هل تود إنهاء التحقق ؟',
  //       };
  //
  //    String get tCancelPhoneOTPDialogueMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'If you cancel phone verification '
  //             'this step will not be skipped. You need to verify your '
  //             'phone first.\n\n'
  //             ' Do you want to cancel the verification ?',
  //         SupportedLocale.ar => 'في حالة إنهاء التحقق من الهاتف '
  //             'لن يتم تجاوز هذه الخطوة. لابد من إتمام التحقق أولاً.\n\n'
  //             'هل تود إنهاء التحقق ؟',
  //       };
  //
  //    String get tCancelPhonePasswordDialogueMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'If you cancel now previous phone number verification will be lost.\n\n'
  //             ' Do you want to cancel registering?',
  //         SupportedLocale.ar => 'في حالة الإنهاء سوف تفقد تحقق رقم الهاتف السابق.\n\n'
  //             ' هل تريد إنهاء إنشاء حسابك؟',
  //       };
  //
  //    String get tConfirmSkipDriverApplyMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'You can add a vehicle and become a Driver by '
  //             'going to Menu > ${L10nR.tBecomeDriverButton}'
  //             '\n\nDo you want to skip?',
  //         SupportedLocale.ar => 'يمكنك إضافة مركبة والتقديم كسائق '
  //             'عن طريق الذهاب إلى القائمة > ${L10nR.tBecomeDriverButton}'
  //             '\n\nهل تريد التخطي؟',
  //       };
  //
  //    String get tChooseFromGallery => switch (_currentLocale) {
  //         SupportedLocale.en => 'Choose from gallery',
  //         SupportedLocale.ar => 'اختر من الصور',
  //       };
  //
  //    String get tTakeAPicture => switch (_currentLocale) {
  //         SupportedLocale.en => 'Take a picture',
  //         SupportedLocale.ar => 'التقط صورة',
  //       };
  //
  //    String get tAppliedSuccessfully => switch (_currentLocale) {
  //         SupportedLocale.en => 'Applied Successfully',
  //         SupportedLocale.ar => 'تم التقديم بنجاح',
  //       };
  //
  //    String get tAppliedSuccessfullyMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Congratulation! You have successfully applied as a Driver.'
  //             ' Once Your application is reviewed you will receive a'
  //             ' feedback in the app notification center.',
  //         SupportedLocale.ar => 'تهانينا! تم تقديم كسائق بنجاح.'
  //             ' سوف تصلكم نتيجة التقديم في مركز الإشعارات'
  //             ' فور الانتهاء من مراجعة الطلب.',
  //       };
  //
  //    String get tVerificationChoiceMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'We will sent you an OTP code to verify your phone number.'
  //             ' Please choose a receiving destination.',
  //         // '\n\n If you can access your'
  //         // ' phone number WhatApp account, It is recommended to continue with WhatsApp.',
  //         SupportedLocale.ar => 'سوف نرسل لك رمز أمان للتحقق من رقم هاتفك.'
  //             ' يرجى اختيار طريقة الاستلام.',
  //         // 'إذا كنت تستطيع الوصول إلى الخاص بك'
  //         //             ' رقم الهاتف حساب WhatApp، يوصى بمتابعة استخدام WhatsApp.',
  //       };
  //
  //    String get tVerificationChoiceWhatsAppNote => switch (_currentLocale) {
  //         SupportedLocale.en => 'Please make sure you have access to your phone '
  //             'number WhatsApp account.',
  //         SupportedLocale.ar => 'يرجى التأكد من إمكانية الوصول إلى حساب '
  //             'الواتساب الخاص برقم الهاتف.',
  //       };
  //
  //    String get tVerificationChoiceSMSNote => switch (_currentLocale) {
  //         SupportedLocale.en => 'Please make sure you can receive SMS'
  //             ' and the cellular network coverage is good.',
  //         SupportedLocale.ar => 'يرجى التأكد من إمكانية استلام رسائل نصية SMS'
  //             ' و أن تغطية الشبكة الخلوية جيدة.',
  //       };
  //
  //    String get tWhatsApp => switch (_currentLocale) {
  //         SupportedLocale.en => 'WhatsApp',
  //         SupportedLocale.ar => 'واتساب',
  //       };
  //
  //    String get tSMS => switch (_currentLocale) {
  //         SupportedLocale.en => 'SMS',
  //         SupportedLocale.ar => 'رسالة نصية SMS',
  //       };
  //
  //    String get recommended => switch (_currentLocale) {
  //         SupportedLocale.en => 'Recommended',
  //         SupportedLocale.ar => 'يفضل',
  //       };
  //
  //    String get tCreatePassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Create Password',
  //         SupportedLocale.ar => 'إنشاء كلمة المرور',
  //       };
  //
  //    String tCreatingPasswordGreeting(String name) => switch (_currentLocale) {
  //         SupportedLocale.ar => '$nameمرحبا ',
  //         SupportedLocale.en => 'Welcome $name',
  //       };
  //
  //    String get tCreatingPasswordMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Please create a password for your account '
  //             'to be able to login via your phone number.',
  //         SupportedLocale.ar => 'يرجى إنشاء كلمة مرور'
  //             ' لتسجيل الدخول عن طريق رقم الهاتف.',
  //       };
  //
  //    String get tConsecutiveRequests => switch (_currentLocale) {
  //         SupportedLocale.en => 'Consecutive Requests',
  //         SupportedLocale.ar => 'محاولات متتالية',
  //       };
  //
  //    String get tConsecutiveRequestsDialogueMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'For accounts security assurance consecutive requests to'
  //             ' reset password are not allowed. Please try again later.',
  //         SupportedLocale.ar => 'لضمان أمان الحسابات الطلبات المتتالية لإعادة ضبط كلمة المرور'
  //             ' غير مسموح بها. برجاء المحاولة في وقت لاحق.',
  //       };
  //
  String tOK([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'OK',
    SupportedLocale.ar => 'حسنا',
  };

  String tRESET([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'RESET',
    SupportedLocale.ar => 'إعادة الضبط',
  };

  String tConfirmReset([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Confirm Reset',
    SupportedLocale.ar => 'تأكيد إعادة الضبط',
  };

  String tConfirmResetMessage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Are you sure you want to reset your settings back to default ones ?',
    SupportedLocale.ar => 'هل أنت متاكد من إعادة ضبط الاعدادات الخاصة بك ؟',
  };

  String tConfirmExit([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Confirm Exit',
    SupportedLocale.ar => 'تأكيد الخروج',
  };

  String tConfirmExitMessage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Are you sure you want to exit ?',
    SupportedLocale.ar => 'هل تريد تأكيد الخروج ؟',
  };

  String tConfirmExitMessageWithTimer([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Are you sure you want to discard the current timer and exit the app?',
    SupportedLocale.ar => 'هل تريد تجاهل المؤقت الحالي و تأكيد الخروج ؟',
  };

  String tGoBack([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Go Back',
    SupportedLocale.ar => 'عودة',
  };

  String tExit([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Exit',
    SupportedLocale.ar => 'خروج',
  };

  String tStay([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Stay',
    SupportedLocale.ar => 'بقاء',
  };

  //
  //    String get tPreviousMatch => switch (_currentLocale) {
  //         SupportedLocale.en => 'Previous Match',
  //         SupportedLocale.ar => 'تطابق سابق',
  //       };
  //
  //    String get tPreviousPasswordMatchDialogueMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'You entered the correct password of your account.'
  //             ' It is recommended to reset your password with a new one.'
  //             '\n\nNote: You can use this password to login without resetting it.',
  //         SupportedLocale.ar => 'لقد قمت بإدخال كلمة المرور الصحيحة. '
  //             'يفضل إعادة ضبطها بكلمة مرور جديدة.\n\n'
  //             'تنويه: يمكنك استخدام كلمة المرور تلك لتسجبل الدخول بدون إعادة ضبطها.',
  //       };
  //
  //    String get tCancelConfirm => switch (_currentLocale) {
  //         SupportedLocale.en => 'Cancel Confirm',
  //         SupportedLocale.ar => 'تأكيد الإنهاء',
  //       };
  //
  //    String get tCancelPasswordResetDialogue => switch (_currentLocale) {
  //         SupportedLocale.en => 'Do you want to cancel password resetting?',
  //         SupportedLocale.ar => 'هل تود إنهاء إعادة ضبط كلمة المرور؟',
  //       };
  //
  //   ///
  //   //  OTP Screen
  //    String get tOTPTitle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Phone number Verification',
  //         SupportedLocale.ar => 'التحقق من رقم الهاتف',
  //       };
  //
  //   //  String get tEnterCode => switch (_currentLocale) {
  //   //       SupportedLocale.en => 'Enter the verification code sent to your phone number.'
  //   //           ' \n\nNote: The code expires after ${GlobalConstants.otpExpirationMinutes} minutes',
  //   //       SupportedLocale.ar => 'أدخل رمز التحقق المرسل إلى رقم الهاتف.'
  //   //           '\n\nتنويه: مدة صلاحية الرمز ${GlobalConstants.otpExpirationMinutes} دقائق',
  //   //     };
  //
  //    String get tResendingCode => switch (_currentLocale) {
  //         SupportedLocale.en => 'Resending OTP Code ...',
  //         SupportedLocale.ar => 'جاري إرسال رمز التحقق ...',
  //       };
  //
  //   //  String get tSendOTPCode => switch (_currentLocale) {
  //   //       SupportedLocale.en => 'Send OTP Code',
  //   //       SupportedLocale.ar => 'أرسل رمز التحقق',
  //   //     };
  //
  //    String get tResendOTPCode => switch (_currentLocale) {
  //         SupportedLocale.en => 'Resend OTP Code',
  //         SupportedLocale.ar => 'أعد إرسال الرمز',
  //       };
  //
  //    String get tVerifying => switch (_currentLocale) {
  //         SupportedLocale.en => 'Verifying ...',
  //         SupportedLocale.ar => 'جاري التحقق ...',
  //       };
  //
  //    String get tPhoneSuccessfullyVerified => switch (_currentLocale) {
  //         SupportedLocale.en => 'Phone number is successfully verified.',
  //         SupportedLocale.ar => 'تم التحقق من رقم الهاتف بنجاح.',
  //       };
  //
  //    String get tInvalidOTP => switch (_currentLocale) {
  //         SupportedLocale.en => 'OTP Code is not valid.',
  //         SupportedLocale.ar => 'رمز التحقق غير صالح.',
  //       };
  //
  //    String get tCouldNotVerifyYourPhone => switch (_currentLocale) {
  //         SupportedLocale.en => 'Could not verify your phone number.',
  //         SupportedLocale.ar => 'لم نتمكن من التحقق من رقم الهاتف.',
  //       };
  //
  // //  Register Screen
  //    String get tSignUpPageTitle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Sign Up',
  //         SupportedLocale.ar => 'إنشاء حساب',
  //       };
  //
  // //  String get tSignUpWith => switch(currentLocale {SupportedLocale.en=>tSignUpWith,SupportedLocale.ar => throw UnimplementedError(),};
  // //  String get tSignUpOr => switch(currentLocale {SupportedLocale.en=>tSignUpOr,SupportedLocale.ar => throw UnimplementedError(),};
  //    String get tSigningVia => switch (_currentLocale) {
  //         SupportedLocale.en => 'via',
  //         SupportedLocale.ar => 'بواسطة',
  //       };
  //
  //    String get tAlreadyHaveAccount => switch (_currentLocale) {
  //         SupportedLocale.en => 'Already have an account ?',
  //         SupportedLocale.ar => 'لديك حساب بالفعل ؟',
  //       };
  //
  //    String get tAccountCannotBeCreated => switch (_currentLocale) {
  //         SupportedLocale.en => 'Account can not be created',
  //         SupportedLocale.ar => 'لا يمكن إنشاء الحساب',
  //       };
  //
  //    String get tCouldNotSignYouIn => switch (_currentLocale) {
  //         SupportedLocale.en => 'Could not sign you in',
  //         SupportedLocale.ar => 'لم نتمكن من تسجبل دخولك',
  //       };
  //
  //    String get tCouldNotSignInWithGoogle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Could not Sign in with Google',
  //         SupportedLocale.ar => 'لم نتمكن من تسجبل دخول بحساب Google',
  //       };
  //
  //    String get tCouldNotContinueWithGoogle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Could not Continue with Google',
  //         SupportedLocale.ar => 'لم نتمكن من استخدام حساب Google',
  //       };
  //
  //    String get tAborted => switch (_currentLocale) {
  //         SupportedLocale.en => 'Aborted',
  //         SupportedLocale.ar => 'لم ينتهي',
  //       };
  //
  //    String get tCancelled => switch (_currentLocale) {
  //         SupportedLocale.en => 'Cancelled',
  //         SupportedLocale.ar => 'تم الإلغاء',
  //       };
  //
  //    String get tCouldNotRetrieveYourAccountInfo => switch (_currentLocale) {
  //         SupportedLocale.en => 'Could not get your account info',
  //         SupportedLocale.ar => 'لم نتمكن من الحصول على معلومات حسابك',
  //       };
  //
  //    String get dialCodeSearchHint => switch (_currentLocale) {
  //         SupportedLocale.en => 'Country name or dial-in code',
  //         SupportedLocale.ar => 'اسم البلد أو رمز الاتصال',
  //       };
  //
  // // Email Verify Screen
  //    String get tPleaseVerifyYourEmail => switch (_currentLocale) {
  //         SupportedLocale.en => 'Please verify your email',
  //         SupportedLocale.ar => 'برجاء إتمام التحقق من البريد الإلكتروني',
  //       };
  //
  //    String get tSendingVerificationLink => switch (_currentLocale) {
  //         SupportedLocale.en => 'Sending verification email ...',
  //         SupportedLocale.ar => 'جاري إرسال بريد التحقق ...',
  //       };
  //
  //    String get tVerifyingYourEmail => switch (_currentLocale) {
  //         SupportedLocale.en => 'Verifying your email ...',
  //         SupportedLocale.ar => 'جاري التحقق من بريدكم الإلكتروني ...',
  //       };
  //
  //    String get tVerificationLinkSent => switch (_currentLocale) {
  //         SupportedLocale.en => 'Verification link has been sent to your email. '
  //             'Please check your inbox to verify your email.\n\n'
  //             'NOTE: You need to open the link using this device.',
  //         //  as for security reasons email verification is not done using web browsers
  //         SupportedLocale.ar => 'تم إرسال رابط التحقق إلى بريدكم الإلكتروني. '
  //             'برجاء مراجعة صندوق الرسائل لإتمام التحقق.\n\n'
  //             'تنويه: لابد من فتح الرابط باستخدام هذا الجهاز.',
  //       };
  //
  //    String get tEmailSuccessfullyVerified => switch (_currentLocale) {
  //         SupportedLocale.en => 'Email is successfully verified',
  //         SupportedLocale.ar => 'تم التحقق من البريد الإلكتروني بنجاح.',
  //       };
  //
  //    String get tEmailVerificationLinkExpired => switch (_currentLocale) {
  //         SupportedLocale.en => 'Verification link is expired. '
  //             'Tap the button to resend a new verification email.',
  //         SupportedLocale.ar => 'انتهت صلاحية رابط التحقق.'
  //             ' اضغط على الزر لإعادة إرسال رابط جديد.',
  //       };
  //
  //    String get tAccountDisabled => switch (_currentLocale) {
  //         SupportedLocale.en => 'Account is disabled',
  //         SupportedLocale.ar => 'تم تعطيل الحساب',
  //       };
  //
  //    String get tAccountNotRegistered => switch (_currentLocale) {
  //         SupportedLocale.en => 'Account not registered',
  //         SupportedLocale.ar => 'الحساب غير مسجل',
  //       };
  //
  //    String get tUseStrongPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Use strong passwords. Besides using upper, lower letters, '
  //             'numbers and special characters, Avoid using common dictionary words',
  //         SupportedLocale.ar => 'استخدم كلمة مرور آمنة. بالإضافة إلى استخدامك حروف كبيرة و صغيرة'
  //             ' و أرقام و رموز خاصة، تجنب أي كلمات  مشهورة أو شائعة الاستخدام.',
  //       };
  //
  //    String get tConnectionErrorTryAgain => switch (_currentLocale) {
  //         SupportedLocale.en => 'Connection Error. Try open the link again.',
  //         SupportedLocale.ar => 'خطأ في الاتصال. حاول الضغط على الرابط مرة أخرى',
  //       };
  //
  //    String get tCouldNotVerifyYourEmail => switch (_currentLocale) {
  //         SupportedLocale.en => 'Could not verify your email',
  //         SupportedLocale.ar => 'لم نتمكن من التحقق من بريدكم الإلكتروني',
  //       };
  //
  // //  String get tTooManyWrongAttemptsResetPasswordWithTry => switch(currentLocale {SupportedLocale.en=>tTooManyWrongAttemptsResetPasswordWithTry,SupportedLocale.ar => throw UnimplementedError(),};
  // //  String get tToastResetRecentlyWithTry => switch(currentLocale {SupportedLocale.en=>tToastResetRecentlyWithTry,SupportedLocale.ar => throw UnimplementedError(),};
  // //  String get tResetRecentlyWithReason => switch(currentLocale {SupportedLocale.en=>tResetRecentlyWithReason,SupportedLocale.ar => throw UnimplementedError(),};
  // //     'Password reset requested recently. For security reasons users are not allowed to request password reset multiple times consecutively. Please Try again later.';
  //    String get tSessionExpired => switch (_currentLocale) {
  //         SupportedLocale.en => 'Session expired',
  //         SupportedLocale.ar => 'انتهت صلاحية الجلسة',
  //       };
  //
  //    String get tAccountDeletedSuccessfully => switch (_currentLocale) {
  //         SupportedLocale.en => 'Account Deleted Successfully',
  //         SupportedLocale.ar => 'تم حذف الحساب بنجاح',
  //       };
  //
  // //  String get tSessionExpiredLoginToContinue => switch(currentLocale {SupportedLocale.en=>tSessionExpiredLoginToContinue,SupportedLocale.ar => throw UnimplementedError(),};
  //    String get tSendVerificationEmail => switch (_currentLocale) {
  //         SupportedLocale.en => 'Send Verification Email',
  //         SupportedLocale.ar => 'أرسل رابط التحقق',
  //       };
  //
  //    String get tResendVerificationEmail => switch (_currentLocale) {
  //         SupportedLocale.en => 'Resend Verification Email',
  //         SupportedLocale.ar => 'أعد إرسال الرابط',
  //       };
  //
  //    String get tCouldNotSendVerificationEmail => switch (_currentLocale) {
  //         SupportedLocale.en => 'Could not send the verification email',
  //         SupportedLocale.ar => 'لم نتمكن من إرسال رابط التحقق',
  //       };
  //
  // //  String get tToRiderAppName => switch(currentLocale {SupportedLocale.en=>tToRiderAppName,SupportedLocale.ar => throw UnimplementedError(),};
  //
  // //  Permission Screen
  //    String get tPermissionScreenTitle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Permissions Check',
  //         SupportedLocale.ar => 'مراجعة الأذونات',
  //       };
  //
  // //  String get tPermissionScreenSubTitle => switch(currentLocale {SupportedLocale.en=>tPermissionScreenSubTitle,SupportedLocale.ar => throw UnimplementedError(),};
  //    String get tLocationEnabled => switch (_currentLocale) {
  //         SupportedLocale.en => 'Location is enabled',
  //         SupportedLocale.ar => 'الموقع مفعل',
  //       };
  //
  //    String get tLocationNotEnabled => switch (_currentLocale) {
  //         SupportedLocale.en => 'Location is not enabled',
  //         SupportedLocale.ar => 'الموقع غير مفعل',
  //       };
  //
  //    String get tLocationPermissionAllowed => switch (_currentLocale) {
  //         SupportedLocale.en => 'Location Permission Allowed',
  //         SupportedLocale.ar => 'إذن الوصول للموقع مسموح به',
  //       };
  //
  //    String get tLocationPermissionNotAllowed => switch (_currentLocale) {
  //         SupportedLocale.en => 'Location Permission is not allowed',
  //         SupportedLocale.ar => 'إذن الوصول للموقع غير مسموح به',
  //       };
  //
  //    String get tNotificationPermissionAllowed => switch (_currentLocale) {
  //         SupportedLocale.en => 'Notification Permission Allowed',
  //         SupportedLocale.ar => 'إذن إظهار الإشعارات مسموح به',
  //       };
  //
  //    String get tNotificationPermissionNotAllowed => switch (_currentLocale) {
  //         SupportedLocale.en => 'Notification Permission is not allowed',
  //         SupportedLocale.ar => 'إذن إظهار الإشعارات غير مسموح به',
  //       };
  //
  String tAllow([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Allow',
    SupportedLocale.ar => 'سماح',
  };

  String tRequest([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Allow Request',
    SupportedLocale.ar => 'السماح بالطلب',
  };

  String tRefresh([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Refresh',
    SupportedLocale.ar => 'تحديث',
  };

  //
  //    String get tDriverApply => switch (_currentLocale) {
  //         SupportedLocale.en => 'Driver Apply',
  //         SupportedLocale.ar => 'تقديم السائق'
  //       };
  //
  //    String get tWelcome {
  //     print(_currentLocale);
  //     return switch (_currentLocale) {
  //       SupportedLocale.en => 'Welcome',
  //       SupportedLocale.ar => 'مرحبا',
  //     };
  //   }
  //
  //    String get tRiderAccountMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Now your account type is Rider. You can set a destination,'
  //             ' pick the trip and the suitable vehicle from drivers\' trips going your way.',
  //         SupportedLocale.ar => 'الآن حسابك من نوع راكب. يمكنك تحديد وجهتك '
  //             'واختيار الرحلة والسيارة المناسبة من رحلات السائقين المتجهة في مسارك.',
  //       };
  //
  //    String get tBecomeDriverButton => switch (_currentLocale) {
  //         SupportedLocale.en => 'Become Driver',
  //         SupportedLocale.ar => 'تقديم السائق'
  //       };
  //
  //    String get tPendingApplication => switch (_currentLocale) {
  //         SupportedLocale.en => 'Pending Application',
  //         SupportedLocale.ar => 'تقديم قيد المراجعة'
  //       };
  //
  //    String get tPendingApplicationMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Your application is pending review. Once it is done'
  //             ' You will receive a feedback in [Menu > Notification Center].',
  //         SupportedLocale.ar => 'تقديم السائق قيد المراجعة، سوف تصلكم نتيجة التقديم'
  //             ' فور الانتهاء من مراجعة الطلب في [القائمة > مركز الإشعارات].',
  //       };
  //
  //    String get tSwitchToDriver => switch (_currentLocale) {
  //         SupportedLocale.en => 'Switch To Driver',
  //         SupportedLocale.ar => 'تحويل لوضع السائق'
  //       };
  //
  //    String get tSwitchToRider => switch (_currentLocale) {
  //         SupportedLocale.en => 'Switch To Rider',
  //         SupportedLocale.ar => 'تحويل لوضع الراكب'
  //       };
  //
  //    String get tBecomeDriverToo => switch (_currentLocale) {
  //         SupportedLocale.en => 'Become Driver Too',
  //         SupportedLocale.ar => 'تقديم كسائق أيضا'
  //       };
  //
  //    String get tBecomeDriverTooMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'If you have vacant seats on your trips or regular rides '
  //             'you can publish them and earn from riders on your route.',
  //         SupportedLocale.ar => 'إذا كان لديك مقعد متاح في رحلاتك أو المشاوير المعتادة لديك'
  //             ' يمكنك نشرها و الربح من الركاب المسافرون في طريقك.'
  //       };
  //
  //    String get tVehicleOwingQuestion => switch (_currentLocale) {
  //         SupportedLocale.en => 'Do you own or have a vehicle?',
  //         SupportedLocale.ar => 'هل تمتلك أو لديك مركبة؟'
  //       };

  String tYes([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Yes',
    SupportedLocale.ar => 'نعم',
  };

  String tYES([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'YES',
    SupportedLocale.ar => 'نعم',
  };

  //    String get tLicenceQuestion => switch (_currentLocale) {
  //         SupportedLocale.en => 'What about a driving licence?',
  //         SupportedLocale.ar => 'ماذا عن رخصة القيادة؟',
  //       };
  //
  //    String get tHaveIt => switch (_currentLocale) {
  //         SupportedLocale.en => 'Have IT',
  //         SupportedLocale.ar => 'معي',
  //       };
  //
  //    String get tGREATWithEXC => switch (_currentLocale) {
  //         SupportedLocale.en => 'GREAT!',
  //         SupportedLocale.ar => 'رائـع!',
  //       };
  //
  //    String get tAddVehicleMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Now you can add a vehicle and become a Driver.',
  //         SupportedLocale.ar => 'الآن يمكنك إضافة مركبة و إكمال حساب سائق.',
  //       };
  //
  //    String get tAddVehicle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Add Vehicle',
  //         SupportedLocale.ar => 'إضافة مركبة',
  //       };
  //
  //    String get tContinueAsRider => switch (_currentLocale) {
  //         SupportedLocale.en => 'Continue As Rider',
  //         SupportedLocale.ar => 'استمرار كراكب',
  //       };
  //
  String tNo([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'No',
    SupportedLocale.ar => 'لا',
  };

  String tNO([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'NO',
    SupportedLocale.ar => 'لا',
  };

  //   /// Labels & Hints TextFields
  //
  //    String get tUserName => switch (_currentLocale) {
  //         SupportedLocale.en => 'User Name',
  //         SupportedLocale.ar => 'اسم المستخدم',
  //       };
  //
  //    String get tName => switch (_currentLocale) {
  //         SupportedLocale.en => 'Name',
  //         SupportedLocale.ar => 'الاسم',
  //       };
  //
  //    String get tLabelPhone => switch (_currentLocale) {
  //         SupportedLocale.en => 'Phone Number',
  //         SupportedLocale.ar => 'رقم الهاتف',
  //       };
  //
  //    String get tHintPhone => '01*********';
  //
  //    String tDiscardDrawings([WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //         SupportedLocale.en => 'Discard Drawings',
  //         SupportedLocale.ar => 'تجاهل الرسم',
  //       };
  String tClose([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Close',
    SupportedLocale.ar => 'إغلاق',
  };

  //  String tDiscardAnnotations([WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //       SupportedLocale.en => 'Discard Annotations',
  //       SupportedLocale.ar => 'تجاهل التوضيحات',
  //     };

  String tDiscardScreenShot([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Discard ScreenShot',
    SupportedLocale.ar => 'تجاهل لقطة الشاشة',
  };

  String tDiscardScreenShotMessage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Closing the feedback view will discard your screenshot.'
          '\n\n Are you sure you want to close?',
    SupportedLocale.ar =>
      'سيتم تجاهل لقطة الشاشة عند الاغلاق. '
          '\n\nهل تريد الاغلاق؟',
  };

  String tYouHaveHiddenDrawingsShowOrClear([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Your drawings are hidden, show them or clear them',
    SupportedLocale.ar => 'الرسم التوضيحي مخفي - قم بإظهاره أو مسحه',
  };

  //  String tDiscardDrawingsConfirmation([WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //       SupportedLocale.en => 'Submitting while in Navigate mode will discard your drawings. '
  //           'If you want to keep them, switch to Draw mode before submitting.',
  //       SupportedLocale.ar => 'سيتم تجاهل الرسم عند الإرسال في وضع التنقل. '
  //           'اذا كنت تريد إبقاء الرسم ، قم بتحويل الى وضع الرسم قبل الأرسال.',
  //     };

  //  String tSwitchToDrawingMode([WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //       SupportedLocale.en => 'Your drawings will be discarded as you are in Navigate mode. '
  //           'To send them, switch to Draw mode before submitting.',
  //       SupportedLocale.ar => 'سيتم تجاهل الرسم التوضيحي عند الإرسال في وضع التنقل. '
  //           'لإرسال الرسم مع الصورة ، قم بالتحويل إلى وضع الرسم قبل الإرسال.',
  //     };

  //  String tSureToDiscardAnnotations([WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //       SupportedLocale.en => 'Your annotations will be discarded if you close without sending'
  //           ' your feedback.\n\n Are you sure you want to close?',
  //       SupportedLocale.ar => 'سيتم تجاهل الرسم التوضيحي عند الاغلاق بدون الإرسال. '
  //           '\n\nهل تريد الاغلاق؟',
  //     };

  String tWhatCanWeDoBetter([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'What can we do better ?',
    SupportedLocale.ar => 'ماذا يمكننا أن نحسّن ؟',
  };

  String tOptional([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Optional',
    SupportedLocale.ar => 'اختياري',
  };

  String tLabelEmail([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'E-mail',
    SupportedLocale.ar => 'البريد الإلكتروني',
  };

  String tContactEmail([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Contact E-mail',
    SupportedLocale.ar => 'البريد الإلكتروني للتواصل',
  };

  String tDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Description',
    SupportedLocale.ar => 'الوصف',
  };

  String tSend([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Send',
    SupportedLocale.ar => 'إرسال',
  };

  String tSubmittedSuccessfully([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Submitted Successfully',
    SupportedLocale.ar => 'تم الارسال بنجاح',
  };

  //
  //    String get tLabelPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Password',
  //         SupportedLocale.ar => 'كلمة المرور',
  //       };
  //
  //    String get tLabelConfirmPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Confirm Password',
  //         SupportedLocale.ar => 'تأكيد كلمة المرور',
  //       };
  //
  //   /// Validators TextFields
  //
  //    String get tValEmptyName => switch (_currentLocale) {
  //         SupportedLocale.en => 'Name is not provided',
  //         SupportedLocale.ar => 'لم يتم إدخال الاسم',
  //       };
  //
  //    String get tValTooLongName => switch (_currentLocale) {
  //         SupportedLocale.en => 'Name is too long',
  //         SupportedLocale.ar => 'الإسم طويل للغاية',
  //       };
  //
  //    String get tValEmptyPhone => switch (_currentLocale) {
  //         SupportedLocale.en => 'Phone Number is not provided',
  //         SupportedLocale.ar => 'لم يتم إدخال رقم الهاتف',
  //       };
  //
  //    String get tValInvalidPhone => switch (_currentLocale) {
  //         SupportedLocale.en => 'Phone Number is not valid',
  //         SupportedLocale.ar => 'رقم الهاتف غير صالح',
  //       };
  //
  String tValEmptyEmail([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Email is not provided',
    SupportedLocale.ar => 'لم يتم إدخال البريد الإلكتروني',
  };

  String tValInvalidEmail([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Email is not valid',
    SupportedLocale.ar => 'البريد الإلكتروني غير صالح',
  };

  String tSendingFeedback([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Sending Feedback ...',
    SupportedLocale.ar => 'جاري ارسال الملاحظات ...',
  };

  String tSomethingWentWrongWhileFeedback([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Something went wrong while submitting your feedback. '
          'Try again later.',
    SupportedLocale.ar => 'حدث خطاء ما اثناء تقديم الملاحظات. حاول مرة اخرى في وقت لاحق',
  };

  //
  //    String get tValEmptyPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Password is not provided',
  //         SupportedLocale.ar => 'لم يتم إدخال كلمة المرور',
  //       };
  //
  //    String get tValPasswordAlreadyUsed => switch (_currentLocale) {
  //         SupportedLocale.en => 'Password is already used',
  //         SupportedLocale.ar => 'كلمة المرور مستخدمة بالفعل',
  //       };
  //
  //    String get tValEmptyConfirmPassword => switch (_currentLocale) {
  //         SupportedLocale.en => 'Please confirm your password',
  //         SupportedLocale.ar => 'فضلا قم بتأكيد كلمة المرور',
  //       };
  //
  //    String get tValPasswordDoNotMatch => switch (_currentLocale) {
  //         SupportedLocale.en => "Passwords Don't Match",
  //         SupportedLocale.ar => 'كلمة المرور غير مطابقة',
  //       };
  //
  //   /// Buttons
  //
  //    String get tLOGIN => switch (_currentLocale) {
  //         SupportedLocale.en => 'LOGIN',
  //         SupportedLocale.ar => 'سجل دخول',
  //       };
  //
  //    String get tLogin => switch (_currentLocale) {
  //         SupportedLocale.en => 'Login',
  //         SupportedLocale.ar => 'سجل دخول',
  //       };
  //
  //    String get tNext => switch (_currentLocale) {
  //         SupportedLocale.en => 'Next',
  //         SupportedLocale.ar => 'متابعة',
  //       };
  //
  //    String get tNEXT => switch (_currentLocale) {
  //         SupportedLocale.en => 'NEXT',
  //         SupportedLocale.ar => 'متابعة',
  //       };
  //
  //    String get tGetStarted => switch (_currentLocale) {
  //         SupportedLocale.en => 'GET STARTED',
  //         SupportedLocale.ar => 'إبدأ التسجيل',
  //       };
  //
  //    String get tGoogleAccount => switch (_currentLocale) {
  //         SupportedLocale.en => 'Google Account',
  //         SupportedLocale.ar => 'حساب Google',
  //       };
  //
  //    String get tAppleIDToolTip => 'Apple ID';
  //
  //    String get tOrUse => switch (_currentLocale) {
  //         SupportedLocale.en => 'Or use you account in',
  //         SupportedLocale.ar => 'أو استخدم حسابك لدى',
  //       };
  //
  //    String get tB4GoogleSigningDialogueContent {
  //     final android = Platform.isAndroid;
  //     return android
  //         ? switch (_currentLocale) {
  //             SupportedLocale.en => 'You will be prompted to allow access to your name, '
  //                 'email address and profile picture associated with your Google account.\n\n'
  //                 'Note: This method may not work if your device is not connected with a Google account.',
  //             SupportedLocale.ar => 'سيُطلب منك السماح بالوصول إلى اسمك و بريدك الإلكتروني '
  //                 'و صورة ملفك الشخصي المرتبطة بحسابك على Google.\n\n'
  //                 'ملاحظة: قد لا تعمل هذه الطريقة إذا كان جهازك غير مرتبط بحساب Google.',
  //           }
  //         : switch (_currentLocale) {
  //             SupportedLocale.en => 'You will be prompted to allow access to your name, '
  //                 'email address and profile picture associated with your Google account.\n\n'
  //                 'Note: This may open your web browser.',
  //             SupportedLocale.ar => 'سيُطلب منك السماح بالوصول إلى اسمك و بريدك الإلكتروني '
  //                 'و صورة ملفك الشخصي المرتبطة بحسابك على Google.\n\n'
  //                 'ملاحظة: قد يتم فتح المتفصح لإتمام هذه الخطوة.',
  //           };
  //   }
  //
  //    String tCannotResetPwFor3rdParty(String word) {
  //     return switch (_currentLocale) {
  //       SupportedLocale.en => 'This account was created via $word'
  //           ' and it does not have a password.\n\nIf you have access to your $word'
  //           ' You can use to login right away.',
  //       SupportedLocale.ar => 'هذا الحساب تم إنشاؤه بواسطة $word'
  //           ' و ليس لديه كلمة مرور.\n\nإذا يمكنكم الوصول لحساب $word'
  //           ' الخاص بكم يمكن استخدامه لتسجيل الدخول.',
  //     };
  //   }
  //
  //    String get tRegisterTextButton => switch (_currentLocale) {
  //         SupportedLocale.en => 'Register',
  //         SupportedLocale.ar => 'قم بالتسجيل',
  //       };
  //
  //    String get tForgotPasswordTextButton => switch (_currentLocale) {
  //         SupportedLocale.en => 'Forgot Password ?',
  //         SupportedLocale.ar => 'نسيت كلمة المرور ؟',
  //       };
  //
  //    String get tSendEmailButtonInRecover => switch (_currentLocale) {
  //         SupportedLocale.en => 'Send Recovery Email',
  //         SupportedLocale.ar => 'أرسل بريد الاسترجاع',
  //       };
  //
  //    String get tVerifyButton => switch (_currentLocale) {
  //         SupportedLocale.en => 'Verify',
  //         SupportedLocale.ar => 'تحقق',
  //       };
  //
  //    String get tConfirmDestinationButton => switch (_currentLocale) {
  //         SupportedLocale.en => 'Confirm Destination',
  //         SupportedLocale.ar => 'تأكيد الوجهة',
  //       };
  //
  //    String get tConfirmPickUpButton => switch (_currentLocale) {
  //         SupportedLocale.en => 'Confirm Pick Up',
  //         SupportedLocale.ar => 'تأكيد مكان التقابل',
  //       };
  //
  //    String get tConfirm => switch (_currentLocale) {
  //         SupportedLocale.en => 'Confirm',
  //         SupportedLocale.ar => 'تأكيد',
  //       };
  //
  //    String get tPublishButton => switch (_currentLocale) {
  //         SupportedLocale.en => 'Publish',
  //         SupportedLocale.ar => 'انشر',
  //       };
  //
  //    String get tSubmitButton => switch (_currentLocale) {
  //         SupportedLocale.en => 'Submit',
  //         SupportedLocale.ar => 'إدخال',
  //       };
  //
  String tDone([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Done',
    SupportedLocale.ar => 'تم',
  };

  //
  //    String get tFinish => switch (_currentLocale) {
  //         SupportedLocale.en => 'Finish',
  //         SupportedLocale.ar => 'إكمال',
  //       };
  //
  String tViewProfile([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'View Profile',
    SupportedLocale.ar => 'عرض البيانات الشخصية',
  };

  String tSetTotalTime([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Set Total Time',
    SupportedLocale.ar => 'حدد الوقت الكلي',
  };

  String tPleaseSetTotalTime([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Please set total time',
    SupportedLocale.ar => 'قم بتحديد الوقت الكلي',
  };

  String tMinimumPeriodIs30Seconds([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Minimum period is 30 seconds',
    SupportedLocale.ar => 'أقل مدة هي 30 ثانية',
  };

  String tMin([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'min',
    SupportedLocale.ar => 'دقيقة',
  };

  String tHourAbbreviation([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'h',
    SupportedLocale.ar => 'س',
  };

  String tMinuteAbbreviation([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'm',
    SupportedLocale.ar => 'د',
  };

  String tSecondAbbreviation([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 's',
    SupportedLocale.ar => 'ث',
  };

  String tTop([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Top',
    SupportedLocale.ar => 'القمة',
  };

  String tSec([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'sec',
    SupportedLocale.ar => 'ثانية',
  };

  //  String tGo([WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //       SupportedLocale.en => 'Go',
  //       SupportedLocale.ar => 'إبدأ',
  //     };

  String tSTART([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'START',
    SupportedLocale.ar => 'إبدأ',
  };

  String tFINISH([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'FINISH',
    SupportedLocale.ar => 'انهاء',
  };

  String tSavingTraining([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Saving Training ...',
    SupportedLocale.ar => 'جاري حفظ التمرين ...',
  };

  String tStartDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Starts the total timer after if it is set.',
    SupportedLocale.ar => 'يبدأ الوقت الكلي المحدد مسبقاً.',
  };

  //  String tPause([WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //       SupportedLocale.en => 'Pause',
  //       SupportedLocale.ar => 'إيقاف',
  //     };
  //
  String tResume([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Resume',
    SupportedLocale.ar => 'إكمال',
  };

  String tAbort([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Abort',
    SupportedLocale.ar => 'إنهاء',
  };

  String tAbortTraining([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Abort Training',
    SupportedLocale.ar => 'انهاء التمرين',
  };

  String tAbortLadder([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Abort Ladder',
    SupportedLocale.ar => 'انهاء السلم',
  };

  String tRest([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Rest',
    SupportedLocale.ar => 'راحة',
  };

  String tExtendRest([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Extend Rest',
    SupportedLocale.ar => 'إطالة الراحة',
  };

  String tResumeTraining([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Resume Training',
    SupportedLocale.ar => 'استئناف التمرين',
  };

  String tTrain([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Train',
    SupportedLocale.ar => 'تمرن',
  };

  String tTrainToday([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Train Today !',
    SupportedLocale.ar => 'تمرن اليوم !',
  };

  String tExtraRest([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Extra Rest',
    SupportedLocale.ar => 'راحة إضافية',
  };

  String tDiscardExtraRest([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Discard Extra Rest',
    SupportedLocale.ar => 'إلغاء الراحة الإضافية',
  };

  String tMaximumRest([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Maximum Rest',
    SupportedLocale.ar => 'أقصى راحة ممكنة',
  };

  String tVoiceAction([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Voice Action',
    SupportedLocale.ar => 'أمر صوتي',
  };

  String tMonitorRestTrigger([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Monitor Rest Trigger',
    SupportedLocale.ar => 'متابعة تفعيل الراحة',
  };

  String tListening([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Listening ...',
    SupportedLocale.ar => 'يستمع ...',
  };

  String tListeningForRestTrigger([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Listening for rest trigger ...',
    SupportedLocale.ar => 'يستمع لتفعيل الراحة ...',
  };

  String tSpeak([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Speak ...',
    SupportedLocale.ar => 'تحدث ...',
  };

  //
  //   /// In App Scaffold Bodies
  //
  //   /// Schedule
  //
  // //  String get int schedulePageIndex = 0;
  //    String get tSchedulePageTitle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Schedule',
  //         SupportedLocale.ar => 'الجدول الزمني',
  //       };
  //
  //    String get tProvideVehicleInformation => switch (_currentLocale) {
  //         SupportedLocale.en => 'Please provide your vehicle information '
  //             'and upload its photos as shown in the examples.',
  //         SupportedLocale.ar => 'يرجى إدخال معلومات المركبة '
  //             'وإرفاق الصور الخاصة بها كالأمثلة الموضحة.'
  //       };
  //
  //    String get tManufacturingYear => switch (_currentLocale) {
  //         SupportedLocale.en => 'Manufacturing Year',
  //         SupportedLocale.ar => 'سنة الصنع',
  //       };
  //
  //    String get tVehicleType => switch (_currentLocale) {
  //         SupportedLocale.en => 'Vehicle Type',
  //         SupportedLocale.ar => 'نوع المركبة',
  //       };
  //
  //    String get tVehicleFrontImage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Front Image',
  //         SupportedLocale.ar => 'الصورة الأمامية',
  //       };
  //
  //    String get tVehicleRearImage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Rear Image',
  //         SupportedLocale.ar => 'الصورة الخلفية',
  //       };
  //
  //    String get tVehicleLicenseFront => switch (_currentLocale) {
  //         SupportedLocale.en => 'Vehicle License Front',
  //         SupportedLocale.ar => 'وجه رخصة المركبة'
  //       };
  //
  //    String get tVehicleLicenseBack => switch (_currentLocale) {
  //         SupportedLocale.en => 'Vehicle License Back',
  //         SupportedLocale.ar => 'ظهر رخصة المركبة',
  //       };
  //
  //    String get tMotorcycleLicenseFront => switch (_currentLocale) {
  //         SupportedLocale.en => 'Motorcycle License Front',
  //         SupportedLocale.ar => 'وجه رخصة الدراجة النارية'
  //       };
  //
  //    String get tMotorcycleLicenseBack => switch (_currentLocale) {
  //         SupportedLocale.en => 'Motorcycle License Back',
  //         SupportedLocale.ar => 'ظهر رخصة الدراجة النارية'
  //       };
  //
  //    String get tDrivingLicenseFront => switch (_currentLocale) {
  //         SupportedLocale.en => 'Driving License Front',
  //         SupportedLocale.ar => 'وجه رخصة القيادة',
  //       };
  //
  //    String get tDrivingLicenseBack => switch (_currentLocale) {
  //         SupportedLocale.en => 'Driving License Back',
  //         SupportedLocale.ar => 'ظهر رخصة القيادة'
  //       };
  //
  //    String get tUpdateImage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Update Image',
  //         SupportedLocale.ar => 'تحديث الصورة',
  //       };
  //
  //    String get tCar => switch (_currentLocale) {
  //         SupportedLocale.en => 'Car',
  //         SupportedLocale.ar => 'سيارة',
  //       };
  //
  //    String get tMotorcycle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Motorcycle',
  //         SupportedLocale.ar => 'دراجة نارية',
  //       };
  //
  //    String get tOthers => switch (_currentLocale) {
  //         SupportedLocale.en => 'Others',
  //         SupportedLocale.ar => 'أخرى',
  //       };
  //
  // // Published
  //    String get tPublished => switch (_currentLocale) {
  //         SupportedLocale.en => 'Published',
  //         SupportedLocale.ar => 'معلنة',
  //       };
  //
  //    String get tSetYourRoute => switch (_currentLocale) {
  //         SupportedLocale.en => 'Set your route',
  //         SupportedLocale.ar => 'قم بتحديد مسارك',
  //       };
  //
  //    String get tToSeeRangers => switch (_currentLocale) {
  //         SupportedLocale.en => 'To see Rangers going your way',
  //         SupportedLocale.ar => 'للاطلاع على الرحلات ............',
  //       };
  //
  //    String get tCannotFindRangers => switch (_currentLocale) {
  //         SupportedLocale.en => 'We could not find any ranger to  ............. pick you up.',
  //         SupportedLocale.ar => 'لم نتمكن من العثور على أي رحلة عابرة في مسارك أو بالقرب منه',
  //       };
  //
  //    String get tBook => switch (_currentLocale) {
  //         SupportedLocale.en => 'Book',
  //         SupportedLocale.ar => 'احجز',
  //       };
  //
  // //  String get tYouCanSchedule => switch(currentLocale {SupportedLocale.en=>tYouCanSchedule,SupportedLocale.ar => throw UnimplementedError(),};
  //    String get tUpdatingPublished => switch (_currentLocale) {
  //         SupportedLocale.en => 'Updating Published Trips',
  //         SupportedLocale.ar => 'جاري تحديث الرحلات المعلنة',
  //       };
  //
  //    String get tPickUpDistance => switch (_currentLocale) {
  //         SupportedLocale.en => 'Pick up Distance: ',
  //         SupportedLocale.ar => 'بعد الالتقاط: ',
  //       };
  //
  //    String get tDropOffDistance => switch (_currentLocale) {
  //         SupportedLocale.en => 'Drop-off Distance: ',
  //         SupportedLocale.ar => 'throw UnimplementedError()',
  //       };
  //
  //    String get tCannotFindAnyRangers => switch (_currentLocale) {
  //         SupportedLocale.en => 'Can\'t find any ranger going your way',
  //         SupportedLocale.ar => 'throw UnimplementedError()',
  //       };
  //
  //    String get tChangeFilterSettings => switch (_currentLocale) {
  //         SupportedLocale.en => 'Change filter Settings to expand your search',
  //         SupportedLocale.ar => 'قم بتغيير إعدادات التنقية لتوسيع دائرة البحث',
  //       };
  //
  // // Booked
  //    String get tBooked => switch (_currentLocale) {
  //         SupportedLocale.en => 'Booked',
  //         SupportedLocale.ar => 'محجوزة',
  //       };
  //
  //    String get tUpdatingBookings => switch (_currentLocale) {
  //         SupportedLocale.en => 'Updating Bookings',
  //         SupportedLocale.ar => 'جاري تحديث الحجوزات',
  //       };
  //
  //    String get tPending => switch (_currentLocale) {
  //         SupportedLocale.en => 'Pending',
  //         SupportedLocale.ar => 'تم الإرسال',
  //       };
  //
  //    String get tNotified => switch (_currentLocale) {
  //         SupportedLocale.en => 'Notified',
  //         SupportedLocale.ar => 'تم الاستلام',
  //       };
  //
  //    String get tNotAccepted => switch (_currentLocale) {
  //         SupportedLocale.en => 'Not Accepted',
  //         SupportedLocale.ar => 'لم يقبل',
  //       };
  //
  //    String get tAccepted => switch (_currentLocale) {
  //         SupportedLocale.en => 'Accepted',
  //         SupportedLocale.ar => 'تم القبول',
  //       };

  String tCancel([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Cancel',
    SupportedLocale.ar => 'إنهاء',
  };

  String tDismiss([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Dismiss',
    SupportedLocale.ar => 'تجاهل',
  };

  String tDAY([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'DAY',
    SupportedLocale.ar => 'اليوم',
  };

  String tStreak([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Streak',
    SupportedLocale.ar => 'السلسلة',
  };

  String tMaxStreak([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Max Streak',
    SupportedLocale.ar => 'أطول سلسلة',
  };

  String tMinStreak([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Min Streak',
    SupportedLocale.ar => 'أقصر سلسلة',
  };

  String tCurrentStreak([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Current Streak',
    SupportedLocale.ar => 'السلسلة الحالية',
  };

  String tOverallTrainings([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Overall Trainings',
    SupportedLocale.ar => 'إجمالي التمارين',
  };

  String tMaxTrainingsPerDay([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Max Trainings | Day',
    SupportedLocale.ar => 'أقصى تمرينات | يوم',
  };

  String tDaysStreaks([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Days Streaks',
    SupportedLocale.ar => 'سلاسل الأيام',
  };

  String tDaysStreakDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'The days streak is a commitment to repeating'
          ' a daily exercise habit for a number of days in a row.',
    SupportedLocale.ar =>
      'سلسلة الأيام هي التزام بتكرار عادة '
          'التمرين اليومية لعدد من الأيام على التوالي.',
  };

  String tType([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Type',
    SupportedLocale.ar => 'النوع',
  };

  String tDelete([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Delete',
    SupportedLocale.ar => 'حذف',
  };

  String tConfirmDelete([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Confirm Delete',
    SupportedLocale.ar => 'تاكيد الحذف',
  };

  String tConfirmDeleteMessage([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'This action will permanently delete this training.'
          ' Are you sure you want to delete it?',
    SupportedLocale.ar =>
      'سوف يتم حذف هذا التمرين نهائيا.'
          ' هل تريد تأكيد الحذف؟',
  };

  String tDeletedSuccessfully([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Deleted Successfully',
    SupportedLocale.ar => 'تم الحذف بنجاح',
  };

  //  String tAllTrainingsDeletedSuccessfully([WidgetRef? ref]) => switch (_currentLocale(ref)) {
  //       SupportedLocale.en => 'All Trainings Deleted Successfully',
  //       SupportedLocale.ar => 'تم حذف جميع التمارين بنجاح',
  //     };
  String tStreakTrainingsDeleted([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Streak Trainings Deleted',
    SupportedLocale.ar => 'تم حذف سلسلة التمارين',
  };

  String tTrainingTypeHint([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Training Type...',
    SupportedLocale.ar => 'نوع التمرين...',
  };

  String tUntitled([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'untitled',
    SupportedLocale.ar => 'بلا عنوان',
  };

  String tTime([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Time',
    SupportedLocale.ar => 'الوقت',
  };

  String tDate([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Date',
    SupportedLocale.ar => 'التاريخ',
  };

  String tScore([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Score',
    SupportedLocale.ar => 'النقاط',
  };

  String tCompletion([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Completion',
    SupportedLocale.ar => 'الاكتمال',
  };

  String tDuration([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Duration',
    SupportedLocale.ar => 'المدة',
  };

  String tTook([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Took',
    SupportedLocale.ar => 'استغرق',
  };

  String tNotDetermined([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'n.a.',
    SupportedLocale.ar => 'غير محدد',
  };

  String tNoTrainingsToday([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'No trainings today',
    SupportedLocale.ar => 'لا يوجد تمارين اليوم',
  };

  String tNoTrainingsOn(String formattedDate, [WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'No trainings on $formattedDate',
    SupportedLocale.ar => 'لا يوجد تمارين في $formattedDate',
  };

  String tCouldNotDeleteTraining([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => 'لم نتمكن من حذف التمرين',
    SupportedLocale.en => 'Could Not Delete Training',
  };

  //  String tDeletedAllTrainingsOn(String formattedDate, [WidgetRef? ref]) =>
  //     switch (_currentLocale(ref)) {
  //       SupportedLocale.en => 'Successfully Deleted all trainings on $formattedDate',
  //       SupportedLocale.ar => 'تم حذف جميع التمارين في $formattedDate',
  //     };

  //
  //    String get tSaveInArchive => switch (_currentLocale) {
  //         SupportedLocale.en => 'Save In Archive',
  //         SupportedLocale.ar => 'حفظ في الأرشيف',
  //       };
  //
  //    String get tBookedTripsWillShowHere => switch (_currentLocale) {
  //         SupportedLocale.en => 'Booked Trips will be listed here',
  //         SupportedLocale.ar => 'الرحلات المحجورة سوف تعرض في هذه الصفحة',
  //       };
  //
  // // History
  // // History is part if home Nav but consumes Schedule Cubit
  // //    String get int historyPageIndex = 3;
  //    String get tArchivePageTitle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Archive',
  //         SupportedLocale.ar => 'الأرشيف',
  //       };
  //
  //    String get tLoadingArchive => switch (_currentLocale) {
  //         SupportedLocale.en => 'Loading Archive',
  //         SupportedLocale.ar => 'تحميل بيانات الأرشيف',
  //       };
  //
  //    String get tCompletedTripsWillShowHere => switch (_currentLocale) {
  //         SupportedLocale.en => 'Completed Trips will be listed here',
  //         SupportedLocale.ar => 'throw UnimplementedError()',
  //       };
  //
  // // Arranged
  //    String get tArranged => switch (_currentLocale) {
  //         SupportedLocale.en => 'Arranged',
  //         SupportedLocale.ar => 'تم تنسيقها',
  //       };
  //
  //    String get tArrangedTripsWillShowHere => switch (_currentLocale) {
  //         SupportedLocale.en => 'Arranged Trips will be listed here',
  //         SupportedLocale.ar => 'الرحلات المنسقة سوف تعرض في هذه الصفحة',
  //       };
  //
  //    String get tUpdatingArrangements => switch (_currentLocale) {
  //         SupportedLocale.en => 'Updating Arrangements',
  //         SupportedLocale.ar => 'تحديث التنسيقات',
  //       };
  //
  // // Filter UI
  //    String get tSearchButton => switch (_currentLocale) {
  //         SupportedLocale.en => 'Search',
  //         SupportedLocale.ar => 'بحث',
  //       };
  //
  //    String get tFilter => switch (_currentLocale) {
  //         SupportedLocale.en => 'Filter',
  //         SupportedLocale.ar => 'تنقية',
  //       };
  //
  //    String get tMaxPickUpDistance => switch (_currentLocale) {
  //         SupportedLocale.en => 'Max Pick Up Distance: ',
  //         SupportedLocale.ar => 'أقصى بعد عن مكان التقابل: ',
  //       };
  //
  //    String get tMaxDropOffDistance => switch (_currentLocale) {
  //         SupportedLocale.en => 'Max Drop-off Distance: ',
  //         SupportedLocale.ar => 'أقصى بعد عن الوجهة: ',
  //       };
  //
  //    String get tMinAvailableSeats => switch (_currentLocale) {
  //         SupportedLocale.en => 'Minimum Seats: ',
  //         SupportedLocale.ar => 'الحد الأدنى للمقاعد',
  //       };
  //
  //    String get tLabelShowUntil => switch (_currentLocale) {
  //         SupportedLocale.en => 'Show Trips Until',
  //         SupportedLocale.ar => 'إعرض الرحلات حتى',
  //       };
  //
  //    String get tHintShowUntil => switch (_currentLocale) {
  //         SupportedLocale.en => 'throw UnimplementedError()',
  //         SupportedLocale.ar => 'throw UnimplementedError()',
  //       };
  //
  //   /// Chat View
  //    String get tLoadingMessages => switch (_currentLocale) {
  //         SupportedLocale.en => 'Loading Messages',
  //         SupportedLocale.ar => 'جاري تحميل الرسائل',
  //       };
  //
  //    String get tNoMessages => switch (_currentLocale) {
  //         SupportedLocale.en => 'No Messages',
  //         SupportedLocale.ar => 'لا توجد رسائل',
  //       };
  //
  //    String get tStartMessagingBelow => switch (_currentLocale) {
  //         SupportedLocale.en => 'Start messaging below',
  //         SupportedLocale.ar => 'إبدأ المحادثة بالأسفل',
  //       };
  //
  //    String get tSomethingWentWrong => switch (_currentLocale) {
  //         SupportedLocale.en => 'Something went wrong',
  //         SupportedLocale.ar => 'حدث خطأ ما',
  //       };
  //
  //    String get tReload => switch (_currentLocale) {
  //         SupportedLocale.en => 'Reload',
  //         SupportedLocale.ar => 'إعادة التحميل',
  //       };
  //
  //    String get tNoRecentlyUsedEmojis => switch (_currentLocale) {
  //         SupportedLocale.en => 'No Recently Used Emojis',
  //         SupportedLocale.ar => 'لا توجد إشعارات مستخدمة مؤخرًا',
  //       };

  String tPermissionRequired([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Permission Required',
    SupportedLocale.ar => 'مطلوب السماح بالإذن',
  };

  String tPermissionDenied([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Permission Denied',
    SupportedLocale.ar => 'الإذن غير مسموح به',
  };

  String tMicrophone([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Microphone',
    SupportedLocale.ar => 'الميكروفون',
  };

  String tMicrophoneReason([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'capture voice actions',
    SupportedLocale.ar => 'التقاط الأوامر الصوتية',
  };

  String tCameraReason([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'take a picture',
    SupportedLocale.ar => 'التقاط صورة',
  };

  String tPhotosReason([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'pick a photo',
    SupportedLocale.ar => 'الاختيار من الصور',
  };

  String tSpeechRecognition([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Speech Recognition',
    SupportedLocale.ar => 'التعرف على الصوت',
  };

  String tSpeech([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Speech',
    SupportedLocale.ar => 'التحدث',
  };

  String tSpeechReason([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'perform voice action',
    SupportedLocale.ar => 'تنفيذ الأوامر الصوتية',
  };

  String tLocationAlwaysReadableName([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Background Location Access',
    SupportedLocale.ar => 'الوصول للموقع في الخلفية',
  };

  String tLocationAlwaysReason([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'track your location',
    SupportedLocale.ar => 'تتبع موقعك',
  };

  //
  //    String get tConfirmDelete => switch (_currentLocale) {
  //         SupportedLocale.en => 'Confirm Delete',
  //         SupportedLocale.ar => 'تأكيد الحذف',
  //       };
  //
  //    String get tActionCannotBeUndone => switch (_currentLocale) {
  //         SupportedLocale.en =>
  //           'When you tap Delete you will delete the message for everyone. You can not undo this action.',
  //         SupportedLocale.ar => 'عند الضغط على حذف ستقوم بحذف الرسالة للجميع. لا يمكن الرجوع في هذا الحذف',
  //       };
  //
  //    String get tAreYouSureToDelete => switch (_currentLocale) {
  //         SupportedLocale.en => 'Are you sure to delete this message ?',
  //         SupportedLocale.ar => 'هل تود حذف الرسالة ؟',
  //       };
  //
  //    String get tDeletedMessage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Deleted Message',
  //         SupportedLocale.ar => 'رسالة محذوفة',
  //       };
  //
  //    String get tCancelRecoding => switch (_currentLocale) {
  //         SupportedLocale.en => 'Cancel Recording',
  //         SupportedLocale.ar => 'إنهاء التسجيل',
  //       };
  //
  //    String get tYouAreRecodingVoice => switch (_currentLocale) {
  //         SupportedLocale.en => 'You are recording a voice message. $tAreYouSureToCancel',
  //         SupportedLocale.ar => '$tAreYouSureToCancelالآن يتم تسجيل رسالة صوتية. ',
  //       };
  //
  //    String get tAreYouSureToCancel => switch (_currentLocale) {
  //         SupportedLocale.en => 'Do you want to cancel ?',
  //         SupportedLocale.ar => 'هل تود الإنهاء ؟',
  //       };
  //
  String permissionRequestMessage(String readableName, String reason, [WidgetRef? ref]) =>
      switch (_currentLocale(ref)) {
        SupportedLocale.en => '$readableName permission is required to $reason.',
        SupportedLocale.ar => 'إذن $readableName مطلوب من أجل $reason.',
      };

  //
  String permissionSettingMessage({
    required String readableName,
    required String reason,
    required String appName,
    WidgetRef? ref,
  }) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Allow $appName $readableName permission in app settings to $reason.',
    SupportedLocale.ar => ' قم بالسماح ل $appName بإذن $readableName في إعدادات الجهاز.',
  };

  //
  // // class L10nStrings {
  // //   String get String today => switch(currentLocale {SupportedLocale.en=>today,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String yesterday => switch(currentLocale {SupportedLocale.en=>yesterday,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String repliedToYou => switch(currentLocale {SupportedLocale.en=>repliedToYou,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String repliedBy => switch(currentLocale {SupportedLocale.en=>repliedBy,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String reply => switch(currentLocale {SupportedLocale.en=>reply,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String copy => switch(currentLocale {SupportedLocale.en=>copy,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String edit => switch(currentLocale {SupportedLocale.en=>edit,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String cancelSending => switch(currentLocale {SupportedLocale.en=>cancelSending,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String delete => switch(currentLocale {SupportedLocale.en=>delete,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String report => switch(currentLocale {SupportedLocale.en=>report,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String replyTo => switch(currentLocale {SupportedLocale.en=>replyTo,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String message => switch(currentLocale {SupportedLocale.en=>message,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String reactionPopupTitle => switch(currentLocale {SupportedLocale.en=>reactionPopupTitle,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String photo => switch(currentLocale {SupportedLocale.en=>photo,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String send => switch(currentLocale {SupportedLocale.en=>send,SupportedLocale.ar => throw UnimplementedError(),};
  // //   String get String you => switch(currentLocale {SupportedLocale.en=>you,SupportedLocale.ar => throw UnimplementedError(),};
  // // }
  // //
  // // class ReceiptsCustomMessages implements LookupMessages {
  // // @override
  // // String prefixAgo(),> prefixAgo;
  // //
  // // @override
  // // String prefixFromNow(),> prefixFromNow;
  // //
  // // @override
  // // String suffixAgo(),> suffixAgo;
  // //
  // // @override
  // // String suffixFromNow(),> suffixFromNow;
  // //
  // // @override
  // // String lessThanOneMinute(int seconds) > seconds;
  // //
  // // @override
  // // String aboutAMinute(int minutes) > minutes;
  // //
  // // @override
  // // String minutes(int minutes) > minutes;
  // //
  // // @override
  // // String aboutAnHour(int minutes) > minutes;
  // //
  // // @override
  // // String hours(int hours) > hours;
  // //
  // // @override
  // // String aDay(int hours) > hours;
  // //
  // // @override
  // // String days(int days) > days;
  // //
  // // @override
  // // String aboutAMonth(int days) > days;
  // //
  // // @override
  // // String months(int months) > months;
  // //
  // // @override
  // // String aboutAYear(int year) > year;
  // //
  // // @override
  // // String years(int years) > years;
  // //
  // // @override
  // // String wordSeparator(),> wordSeparator;
  // // }
  //
  //   /// Account
  // //  String get int accountPageIndex = 1;
  //    String get tAccount => switch (_currentLocale) {
  //         SupportedLocale.en => 'Account',
  //         SupportedLocale.ar => 'الحساب',
  //       };
  //
  //    String get tBirthday => switch (_currentLocale) {
  //         SupportedLocale.en => 'Birthday',
  //         SupportedLocale.ar => 'تاريخ الميلاد',
  //       };
  //
  //    String get tPhone => switch (_currentLocale) {
  //         SupportedLocale.en => 'Phone',
  //         SupportedLocale.ar => 'الهاتف',
  //       };
  //
  //    String get tWallet => switch (_currentLocale) {
  //         SupportedLocale.en => 'Wallet',
  //         SupportedLocale.ar => 'المحفظة',
  //       };
  //
  //    String get tBalance => switch (_currentLocale) {
  //         SupportedLocale.en => 'Balance:',
  //         SupportedLocale.ar => 'الرصيد:',
  //       };
  //
  //    String get tNoPhone => switch (_currentLocale) {
  //         SupportedLocale.en => 'No Phone Registered',
  //         SupportedLocale.ar => 'رقم الهاتف غير مسجل',
  //       };
  //
  //    String get tNoEmail => switch (_currentLocale) {
  //         SupportedLocale.en => 'No E-mail Registered',
  //         SupportedLocale.ar => 'البريد الإلكتروني غير مسجل',
  //       };
  //
  //    String get tNoBirthday => switch (_currentLocale) {
  //         SupportedLocale.en => 'No Birthday Registered',
  //         SupportedLocale.ar => 'تاريخ الميلاد غير مسجل',
  //       };
  //
  //    String get tCurrency => switch (_currentLocale) {
  //   /// Check This out .. according to country as I Suppose using IP LOCATION FO EX
  //         SupportedLocale.en => ' EGP',
  //         SupportedLocale.ar => ' جنيه مصري',
  //       };
  //
  //    String get tUpdateProfileImage => switch (_currentLocale) {
  //         SupportedLocale.en => 'Update Profile Image',
  //         SupportedLocale.ar => 'حدث الصورة الشخصية',
  //       };
  //
  //    String get tLogout => switch (_currentLocale) {
  //         SupportedLocale.en => 'Logout',
  //         SupportedLocale.ar => 'تسجيل الخروج',
  //       };
  //
  //   /// Map
  // //  String get int mapPageIndex => switch(currentLocale {SupportedLocale.en=>mapPageIndex,SupportedLocale.ar => throw UnimplementedError(),};
  //    String get tMapPageTitle => switch (_currentLocale) {
  //         SupportedLocale.en => 'Map',
  //         SupportedLocale.ar => 'الخريطة',
  //       };
  //
  //    String get tHintSearchPlaces => switch (_currentLocale) {
  //         SupportedLocale.en => 'Search Places ...',
  //         SupportedLocale.ar => 'بحث الأماكن ...',
  //       };
  //
  //    String get tLabelSearchPlaces => switch (_currentLocale) {
  //         SupportedLocale.en => 'Search',
  //         SupportedLocale.ar => 'بحث',
  //       };
  //
  //   /// Settings
  // //  String get int settingsPageIndex => switch(currentLocale {SupportedLocale.en=>settingsPageIndex,SupportedLocale.ar => throw UnimplementedError(),};
  //
  String tWhatsNew([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'What\'s New',
    SupportedLocale.ar => 'ما الجديد',
  };

  String tChangeLog([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Change Log',
    SupportedLocale.ar => 'سجل التغييرات',
  };

  String tPrivacyPolicy([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Privacy Policy',
    SupportedLocale.ar => 'سياية الخصوصية',
  };

  String tTermsOfUse([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Terms of Use',
    SupportedLocale.ar => 'شروط الاستخدام',
  };

  String tShareTheApp([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Share the App',
    SupportedLocale.ar => 'مشاركة التطبيق',
  };

  String tShare([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Share',
    SupportedLocale.ar => 'مشاركة',
  };

  String tDownloadItNowForFree([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Download it now - For free!',
    SupportedLocale.ar => 'قم بتحميله الآن مجاناً!',
  };

  String tSimplestMostElegantMessage([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en =>
      'The Simplest and Most Elegant '
          'LADDERS workout timer app out there.',
    SupportedLocale.ar =>
      'أفضل تطبيق للتمرين '
          'بنظام السلالم الأكثر بساطة على الإطلاق.',
  };

  String tDownload([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'Download',
    SupportedLocale.ar => 'تنزيل',
  };

  String tDownloadFrom([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'Download From',
    SupportedLocale.ar => 'تنزيل من',
  };

  String tDownloadFor([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'Download For',
    SupportedLocale.ar => 'تنزيل لنظام',
  };

  String tOR([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'OR',
    SupportedLocale.ar => 'أو',
  };

  String tDownloadUniversalAPK([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'Download Universal APK',
    SupportedLocale.ar => 'تنزيل APK',
  };

  String tKnowAboutArchitecturePickYours([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'Know about architecture? Pick yours:',
    SupportedLocale.ar => 'تعرف عن التقنية؟ اختر الخاصة بك:',
  };

  String tRunInBrowser([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'Run In Browser',
    SupportedLocale.ar => 'تشغيل في المتصفح',
  };

  String tDownloadAppName(String appName, [WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'Download $appName',
    SupportedLocale.ar => 'تنزيل $appName',
  };

  String tAvailableOn([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'Available On:',
    SupportedLocale.ar => 'متوفر على:',
  };

  String tSoonThreeDots([WidgetRef? ref]) => switch (currentLocale(ref)) {
    SupportedLocale.en => 'Soon ...',
    SupportedLocale.ar => 'قريباً ...',
  };

  String tDevicePlatformDisplayName(DevicePlatform platform, [WidgetRef? ref]) =>
      platform.tDisplayName(ref);

  String get tApkPure => 'APKPure';

  String get tAppStore => 'App Store';

  String tContact([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Contact',
    SupportedLocale.ar => 'تواصل',
  };

  String tOurSite([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Our Site',
    SupportedLocale.ar => 'موقعنا',
  };

  String tContactUs([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Contact Us',
    SupportedLocale.ar => 'تواصل معنا',
  };

  String tContactSupport([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Contact Support',
    SupportedLocale.ar => 'تواصل الدعم',
  };

  String tVisitOurSite([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Visit Our Site',
    SupportedLocale.ar => 'زور موقعنا',
  };

  String tCopyEmail([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Copy E-mail',
    SupportedLocale.ar => 'نسخ البريد الإلكتروني',
  };

  /// About Screen
  String tAbout([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'About',
    SupportedLocale.ar => 'عن التطبيق',
  };

  String tEmailUsAt([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'E-Mail us at:',
    SupportedLocale.ar => 'راسلنا عبر البريد الإلكتروني:',
  };

  String tToastCopiedToClipboard([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Copied to Clipboard',
    SupportedLocale.ar => 'تم النسخ إلى الحافظة',
  };

  String tLoadingPleaseWait([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Loading, Please Wait',
    SupportedLocale.ar => 'جاري التحميل، يرجى الانتظار',
  };

  String tRateUs([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Rate Us',
    SupportedLocale.ar => 'قيمنا',
  };

  String tYourRating([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Your Rating',
    SupportedLocale.ar => 'تقييمك',
  };

  String tRating([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Rating',
    SupportedLocale.ar => 'التقييم',
  };

  String tPreRatingSendingNote([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      'Once submitted, rating can not be deleted or changed.'
          '\n\nAre you sure you want to submit?',
    SupportedLocale.ar =>
      'بعد الإرسال، لا يمكن تغيير التقييم او حذفه.'
          '\n\nهل تريد تأكيد الارسال؟',
  };

  String tThanksForYourRating([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Submitted Successfully,\nThanks for your rating.',
    SupportedLocale.ar => 'تم الارسال بنجاح،\n شكرا لتقييك.',
  };

  String tView([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'View',
    SupportedLocale.ar => 'عرض',
  };

  String tDescribeYourExperience([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Describe your experience...',
    SupportedLocale.ar => 'صف تجربتك ...',
  };

  String tDescriptionColonDash([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Description: - ',
    SupportedLocale.ar => 'الوصف: - ',
  };

  String tFeedback([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Feedback',
    SupportedLocale.ar => 'ملاحظات',
  };

  String tUnderstood([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Understood',
    SupportedLocale.ar => 'أعي ذلك',
  };

  String tSave([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Save',
    SupportedLocale.ar => 'حفظ',
  };

  String tDiscard([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Discard',
    SupportedLocale.ar => 'تجاهل',
  };

  String tDiscardChanges([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Discard Changes',
    SupportedLocale.ar => 'تجاهل التغييرات',
  };

  String tDiscardUnsavedChanges([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'You have unsaved changes. Do you want to discard them?',
    SupportedLocale.ar => 'لديك تغييرات غير محفوظة. هل تريد تجاهلها؟',
  };

  String tRetryingToStopRecognition([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Retrying to stop recognition',
    SupportedLocale.ar => 'إعادة محاولة إيقاف التعرف الصوتي',
  };

  String tRecognitionStopped([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Recognition stopped',
    SupportedLocale.ar => 'تم إيقاف التعرف الصوتي',
  };

  String tStoppedListening([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Stopped Listening',
    SupportedLocale.ar => 'تم توقيف الاستماع',
  };

  String tPAUSE([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => 'توقف',
    SupportedLocale.en => 'PAUSE',
  };

  String tPauseDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => 'يقوم بتعليق الوقت الكلي.',
    SupportedLocale.en => 'Pauses the overall Timer.',
  };

  String tREST([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => 'راحة',
    SupportedLocale.en => 'REST',
  };

  String tRestDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Starts a countdown timer equal to the last training period.',
    SupportedLocale.ar => 'يقوم بالعد عكسيا لآخر وقت مستغرق في التمرين.',
  };

  String tRESUME([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.ar => 'أكمل',
    SupportedLocale.en => 'RESUME',
  };

  String tResumeDescription([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Resumes the overall timer if it was paused.',
    SupportedLocale.ar => 'يقوم باستئناف الوقت الكلي إذا كان معلّق.',
  };

  String tVersion([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Version',
    SupportedLocale.ar => 'إصدار',
  };

  /// LADDERS Admin Panel
  String tAdminPortal([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Admin Portal',
    SupportedLocale.ar => 'مدخل الإشراف',
  };

  String tControlPanel([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Control Panel',
    SupportedLocale.ar => 'لوحة التحكم',
  };

  String tNewRatingTitle(int number, [WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      '${number > 1 ? number : ''} New Rating${number > 1 ? 's' : ''} Submitted',
    SupportedLocale.ar => switch (number) {
      1 => 'تقييم جديد',
      2 => 'تقييمان جديدان',
      _ => '$number تقييمات جديدة',
    },
  };

  String tNewFeedbackTitle(int number, [WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en =>
      '${number > 1 ? number : ''} New Feedback${number > 1 ? 's' : ''} Arrived',
    SupportedLocale.ar => switch (number) {
      1 => 'ملاحظة جديدة',
      2 => 'ملاحظتان جديدتان',
      _ => '$number ملاحظات جديدة',
    },
  };

  String tFeedbackScreenshotMissing([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Feedback screenshot is missing',
    SupportedLocale.ar => 'لقطة شاشة الملاحظات مفقودة',
  };

  String tErrorFetchingScreenshot([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Error occurred while fetching the screenshot',
    SupportedLocale.ar => 'حدث خطأ أثناء استقبال الصورة',
  };

  String tScreenshot([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Screenshot',
    SupportedLocale.ar => 'لقطة الشاشة',
  };

  String tDeleteFeedback([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Delete Feedback',
    SupportedLocale.ar => 'حذف الملاحظة',
  };

  String tDeleteRating([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Delete Rating',
    SupportedLocale.ar => 'حذف التقييم',
  };

  String tConfirmDeleteFeedback([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Are you sure you want to delete this feedback?',
    SupportedLocale.ar => 'هل أنت متأكد من حذف هذه الملاحظة؟',
  };

  String tConfirmDeleteRating([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Are you sure you want to delete this rating?',
    SupportedLocale.ar => 'هل أنت متأكد من حذف هذه التقييم؟',
  };

  String tRatingNotFound([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Rating Not Found!',
    SupportedLocale.ar => 'التقييم غير موجود!',
  };

  String tUserRatingNotFound([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'User\'s Rating Not Found!',
    SupportedLocale.ar => 'تقييم المستخدم غير موجود!',
  };

  String tUserFeedbackNotFound([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'User\'s Feedback Not Found!',
    SupportedLocale.ar => 'ملاحظة المستخدم غير موجودة!',
  };

  String tUserFeedbacksNotFound([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'User\'s Feedbacks Not Found!',
    SupportedLocale.ar => 'ملاحظات المستخدم غير موجودة!',
  };

  String tProvidedInAnotherFeedback([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Provided in another feedback',
    SupportedLocale.ar => 'تم إدخاله في ملاحظة أخرى',
  };

  String tAlternativeEmail([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Alternative email',
    SupportedLocale.ar => 'بريد بديل',
  };

  String tGoToUserDetails([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Go To User Details',
    SupportedLocale.ar => 'الذهاب إلى بيانات المستخدم',
  };

  String tNotYet([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Not Yet',
    SupportedLocale.ar => 'ليس بعد',
  };

  String tNoRatingsYet([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'No Ratings Yet!',
    SupportedLocale.ar => 'لا توجد تقييمات بعد!',
  };

  String tNoFeedbacksYet([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'No Feedbacks Yet!',
    SupportedLocale.ar => 'لا توجد ملاحظات بعد!',
  };

  String tNoUsersYet([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'No Users Yet!',
    SupportedLocale.ar => 'لا يوجد مستخدمين بعد!',
  };

  String tUserNotFound([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'User Not Found!',
    SupportedLocale.ar => 'المستخدم غير موجود!',
  };

  String tFeedbackNotFound([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Feedback Not Found',
    SupportedLocale.ar => 'ملاحظة غير موجودة',
  };

  String tFeedbackDetails([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Feedback Details',
    SupportedLocale.ar => 'تفاصيل الملاحظة',
  };

  String tUserRating([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'User Rating',
    SupportedLocale.ar => 'تقييم المستخدم',
  };

  String tDeviceDetails([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Device Details',
    SupportedLocale.ar => 'تفاصيل الجهاز',
  };

  String tOtherDetails([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Other Details',
    SupportedLocale.ar => 'تفاصيل أخرى',
  };

  String tUserFeedbacks([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'User Feedbacks',
    SupportedLocale.ar => 'ملاحظات المستخدم',
  };

  String tDeviceType([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Device Type',
    SupportedLocale.ar => 'نوع الجهاز',
  };

  String more([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'more',
    SupportedLocale.ar => 'المزيد',
  };

  String tRatingDetails([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Rating Details',
    SupportedLocale.ar => 'تفاصيل التقييم',
  };

  String tLogout([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Logout',
    SupportedLocale.ar => 'تسجيل الخروج',
  };

  String tRetry([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Retry',
    SupportedLocale.ar => 'أعد المحاولة',
  };

  String tFeedbacks([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Feedbacks',
    SupportedLocale.ar => 'ملاحظات',
  };

  String tRatings([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Ratings',
    SupportedLocale.ar => 'التقييمات',
  };

  /// Portfolio
  String tEnable([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Enable',
    SupportedLocale.ar => 'تمكين',
  };

  String tFontSize([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Font Size',
    SupportedLocale.ar => 'حجم الخط',
  };

  String tReset([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Reset',
    SupportedLocale.ar => 'إعادة تعيين',
  };

  String tPlaybackSpeed([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Playback Speed',
    SupportedLocale.ar => 'سرعة التشغيل',
  };

  String tWelcomeEveryone([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => '👋 Welcome Everyone!',
    SupportedLocale.ar => '👋 مـرحــبا بالجـمـيـع !',
  };

  String tIam([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'I am Bashier Al-Saeid',
    SupportedLocale.ar => 'أنا بــشــير السـعــيد',
  };

  String tTitle([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Flutter Developer from Egypt',
    SupportedLocale.ar => 'مبــرمـج فِـلاتَــر مــن مـصــر',
  };

  String tBriefBio([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Brief Bio',
    SupportedLocale.ar => 'نبذة مختصرة',
  };

  String tBriefBioDescription([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en =>
      'This video gives a quick walkthrough of biography.'
          ' It includes my education background, development journey'
          ' and some details about the central steps along the way.',
    SupportedLocale.ar =>
      'هذا الفيديو يعطي جولة سريعة عبر سيرتي الذاتية.'
          ' يتضمن مسيرتي التعليمية ورحلتي مع البرمجة'
          ' وبعض التفاصيل عن الخطوات الهامة في هذه الرحلة.',
  };

  String tDevelopmentMap([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Development Map',
    SupportedLocale.ar => 'خريطة التطوير',
  };

  String tShowcase([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Showcase',
    SupportedLocale.ar => 'عــرض',
  };

  String tDownloadLadders([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Download Ladders',
    SupportedLocale.ar => 'تنزيل Ladders',
  };

  String tLaddersApp([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Ladders App',
    SupportedLocale.ar => 'تـطـبيق السـلالـم',
  };

  String tLaddersAppMoto([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    // SupportedLocale.en => 'Train wisely gain massively using the Ladders workout style',
    SupportedLocale.en => 'Stay in shape and produce massive outcomes using Ladders workout style',
    SupportedLocale.ar => 'حافظ على لياقتك وحقق نتائج هائلة باستخدام أسلوب تمرين السلالم',
  };

  String tLaddersAppShowcase([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Ladders App Showcase',
    SupportedLocale.ar => 'عرض تطبيق السلالم',
  };

  String tLaddersAppShowcaseDescription([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en =>
      'This playlist explains the main concepts of the ladders workout style'
          ' and views the Ladders App in practice.',
    SupportedLocale.ar =>
      'هذه القائمة تشرح المبادئ الأساسية لأسلوب تمرين السلالم'
          ' و تعرض عمليا تطبيق Ladders.',
  };

  String tTotal([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Total',
    SupportedLocale.ar => 'الإجمالي',
  };

  String tVideo([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Video',
    SupportedLocale.ar => 'فيديو',
  };

  String tBuildingBlocks([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Building Blocks',
    SupportedLocale.ar => 'مكونات أساسية',
  };

  String tBuildingBlocksDescription([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Below are some of the components I built during development.',
    SupportedLocale.ar => 'فيما يلي بعض المكونات التي قمت ببنائها أثناء التطوير.',
  };

  String tShowAll([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Show All',
    SupportedLocale.ar => 'عرض الكل',
  };

  String tShowCode([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Show Code',
    SupportedLocale.ar => 'عرض الكود',
  };

  String tCode([WidgetRef? ref]) => switch (_currentLocale(ref)) {
    SupportedLocale.en => 'Code',
    SupportedLocale.ar => 'الكود',
  };

  String tDartFlutterOnly([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Dart/Flutter Only',
    SupportedLocale.ar => ' فقط Dart/Flutter',
  };

  String tDependencies([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Dependencies',
    SupportedLocale.ar => 'الإعتمادات',
  };
  //    String get today => switch (_currentLocale) {
  //         SupportedLocale.en => 'Today',
  //         SupportedLocale.ar => 'اليوم',
  //       };
  //
  //    String get yesterday => switch (_currentLocale) {
  //         SupportedLocale.en => 'Yesterday',
  //         SupportedLocale.ar => 'أمس',
  //       };
  //
  //    String get repliedToYou => switch (_currentLocale) {
  //         SupportedLocale.en => 'Replied to you',
  //         SupportedLocale.ar => 'تم الرد على THrow',
  //       };
  //
  //    String get repliedBy => switch (_currentLocale) {
  //         SupportedLocale.en => 'Replied by',
  //         SupportedLocale.ar => 'رد من',
  //       };
  //
  //    String get reply => switch (_currentLocale) {
  //         SupportedLocale.en => 'Reply',
  //         SupportedLocale.ar => 'رد',
  //       };
  //
  //    String get copy => switch (_currentLocale) {
  //         SupportedLocale.en => 'Copy',
  //         SupportedLocale.ar => 'نسخ',
  //       };
  //
  //    String get edit => switch (_currentLocale) {
  //         SupportedLocale.en => 'Edit',
  //         SupportedLocale.ar => 'تعديل',
  //       };
  //
  //    String get cancelSending => switch (_currentLocale) {
  //         SupportedLocale.en => 'Cancel Sending',
  //         SupportedLocale.ar => 'إنهاء الإرسال',
  //       };
  //
  //    String get delete => switch (_currentLocale) {
  //         SupportedLocale.en => 'Delete',
  //         SupportedLocale.ar => 'حذف',
  //       };
  //
  //    String get deleteAll => switch (_currentLocale) {
  //         SupportedLocale.en => 'Delete ALL',
  //         SupportedLocale.ar => 'حذف الكل',
  //       };
  //
  //    String get tCancelApply => switch (_currentLocale) {
  //         SupportedLocale.en => 'Cancel Apply',
  //         SupportedLocale.ar => 'إنهاء التقديم'
  //       };
  //
  //    String get tCancelUploadingImages => switch (_currentLocale) {
  //         SupportedLocale.en => 'Cancel images upload',
  //         SupportedLocale.ar => 'إنهاء رفع الصور'
  //       };
  //
  //    String get tConfirmDeleteAllImages => switch (_currentLocale) {
  //         SupportedLocale.en => 'Do you want to delete all images ?'
  //             '\n\nNote: Images will not be deleted from your device.',
  //         SupportedLocale.ar => 'هل تريد حذف جميع الصور ؟'
  //             '\n\nتنويه: لن يتم حذف الصور من الجهاز.'
  //       };
  //
  //    String get report => switch (_currentLocale) {
  //         SupportedLocale.en => 'Report',
  //         SupportedLocale.ar => 'إبلاغ',
  //       };
  //
  //    String get replyTo => switch (_currentLocale) {
  //         SupportedLocale.en => 'Replying to',
  //         SupportedLocale.ar => 'رد على',
  //       };
  //
  //    String get message => switch (_currentLocale) {
  //         SupportedLocale.en => 'Message',
  //         SupportedLocale.ar => 'رسالة',
  //       };
  //
  // //  String get reactionPopupTitle => switch (currentLocale) {
  // //       SupportedLocale.en => 'Tap and hold to multiply your reaction',
  // //       SupportedLocale.ar => "throw UnimplementedError()",
  // //     };
  //
  //    String get photo => switch (_currentLocale) {
  //         SupportedLocale.en => 'Photo',
  //         SupportedLocale.ar => 'صورة',
  //       };
  //
  //    String get send => switch (_currentLocale) {
  //         SupportedLocale.en => 'Sen',
  //         SupportedLocle.ar => 'أرسل',
  //       };
  //
  //    String get you => switch (_currentLocale) {
  //         SupportedLocale.en => 'You',
  //         SupportedLocale.ar => 'أنت',
  //       };
}

extension DevicePlatformName on DevicePlatform {
  String tDisplayName([WidgetRef? ref]) => switch (this) {
    DevicePlatform.android => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.en => 'android',
      SupportedLocale.ar => 'اندرويد',
    },
    DevicePlatform.fuchsia => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.ar => 'فيوشا',
      SupportedLocale.en => 'Fuchsia',
    },
    DevicePlatform.iOS => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.ar => 'ايفون',
      SupportedLocale.en => 'iOS',
    },
    DevicePlatform.linux => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.ar => 'لينوكس',
      SupportedLocale.en => 'Linux',
    },
    DevicePlatform.macOS => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.ar => 'ماك بوك',
      SupportedLocale.en => 'macOS',
    },
    DevicePlatform.windows => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.en => 'Windows',
      SupportedLocale.ar => 'ويندوز',
    },
    DevicePlatform.web => switch (l10nR.currentLocale(ref)) {
      SupportedLocale.en => 'Web App',
      SupportedLocale.ar => 'تطبيق ويب',
    },
  };
}

part of 'session_data.dart';

/// Static Alternate from LiveData that can be used to access data
/// without a context.
///
/// Comes in handy when in callbacks or displaying dialogs or toasts.
abstract final class StaticData {
  static double get scalePercentage => LiveData.__scalePercentage;

  static MediaQueryData get mediaQuery => LiveData.__mediaQuery;

  static Size get sizeQuery => LiveData.__sizeQuery;

  static double get deviceWidth => LiveData.__deviceWidth;

  static double get deviceHeight => LiveData.__deviceHeight;

  static EdgeInsets get viewPadding => LiveData.__viewPadding;

  static EdgeInsets get viewInsets => LiveData.__viewInsets;

  static EdgeInsets get padding => LiveData.__padding;

  static bool get isPortrait => LiveData.__isPortrait;

  static ThemeData get themeData => LiveData.__themeData;

  static TextTheme get textTheme => LiveData.__textTheme;

  static bool get isLight => LiveData.__isLight;

  static final DevicePlatform platform = DevicePlatform.fromIO;

  /// Use this to force a specific device platform
  /// besides wrapping up your router with Theme with TargetPlatform
  /// overridden and do any necessary work in deviceInfo stuff
  // static final DevicePlatform platform = DevicePlatform.android;
}

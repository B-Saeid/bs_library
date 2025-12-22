part of 'session_data.dart';

/// Static Alternate from LiveData that can be used to access data
/// without a context.
///
/// Comes in handy when in callbacks or displaying dialogs or toasts.
abstract final class StaticData {
  static double get scalePercentage {
    LiveData._assertInitialized();
    return LiveData.__scalePercentage;
  }

  static MediaQueryData get mediaQuery {
    LiveData._assertInitialized();
    return LiveData.__mediaQuery;
  }

  static Size get sizeQuery {
    LiveData._assertInitialized();
    return LiveData.__sizeQuery;
  }

  static double get deviceWidth {
    LiveData._assertInitialized();
    return LiveData.__deviceWidth;
  }

  static double get deviceHeight {
    LiveData._assertInitialized();
    return LiveData.__deviceHeight;
  }

  static EdgeInsets get viewPadding {
    LiveData._assertInitialized();
    return LiveData.__viewPadding;
  }

  static EdgeInsets get viewInsets {
    LiveData._assertInitialized();
    return LiveData.__viewInsets;
  }

  static EdgeInsets get padding {
    LiveData._assertInitialized();
    return LiveData.__padding;
  }

  static bool get isPortrait {
    LiveData._assertInitialized();
    return LiveData.__isPortrait;
  }

  static ThemeData get themeData {
    LiveData._assertInitialized();
    return LiveData.__themeData;
  }

  static TextTheme get textTheme {
    LiveData._assertInitialized();
    return LiveData.__textTheme;
  }

  static bool get isLight {
    LiveData._assertInitialized();
    return LiveData.__isLight;
  }

  static final DevicePlatform platform = DevicePlatform.fromIO;

  /// Use this to force a specific device platform
  /// besides wrapping up your router with Theme with TargetPlatform
  /// overridden and do any necessary work in deviceInfo stuff
  // static final DevicePlatform platform = DevicePlatform.android;
}

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import '../l18n/localization.dart';
import '../theme/feedback_theme.dart';
import 'media_query_from_window.dart';

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({
    super.key,
    required this.child,
    // this.themeMode,
    // this.theme,
    // this.darkTheme,
    this.localizationsDelegates,
    this.localeOverride,
  });

  final Widget child;

  // final ThemeMode? themeMode;
  // final FeedbackThemeData? theme;
  // final FeedbackThemeData? darkTheme;
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? localeOverride;

  // FeedbackThemeData _buildThemeData(BuildContext context) {
  //   final feedbackThemeData = switch (themeMode) {
  //     ThemeMode.system || null => MediaQuery.maybePlatformBrightnessOf(context) == Brightness.dark
  //         ? darkTheme ?? FeedbackThemeData.dark()
  //         : theme ?? FeedbackThemeData.light(),
  //     ThemeMode.light => theme ?? FeedbackThemeData.light(),
  //     ThemeMode.dark => darkTheme ?? FeedbackThemeData.dark()
  //   };
  //
  //   // final themeData = FeedbackThemeData.merge(
  //   //   themeData: Theme.of(context),
  //   //   theme: feedbackThemeData,
  //   // );
  //
  //   // return themeData;
  //   return feedbackThemeData;
  // }

  @override
  Widget build(BuildContext context) {
    final themeWrapper = FeedbackTheme(
      // data: _buildThemeData(context),
      data: FeedbackThemeData(),
      child: child,
    );

    Widget mediaQueryWrapper;

    /// Don't replace existing MediaQuery widget if it exists.
    if (MediaQuery.maybeOf(context) == null) {
      mediaQueryWrapper = MediaQueryFromWindow(child: themeWrapper);
    } else {
      mediaQueryWrapper = themeWrapper;
    }

    return FeedbackLocalization(
      delegates: localizationsDelegates,
      localeOverride: localeOverride,
      child: mediaQueryWrapper,
    );
  }
}

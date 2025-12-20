import 'dart:async';

import 'package:flutter/material.dart';

import 'controllers/feedback_controller.dart';
import 'controllers/feedback_data.dart';
import 'controllers/internal_controller.dart';
import 'enums/feedback_mode.dart';
import 'models/user_feedback.dart';
import 'theme/feedback_theme.dart';
import 'utilities/debug_check.dart';
import 'widgets/feedback_app.dart';
import 'widgets/main_widget/feedback_widget.dart';

/// The function to be called when the user submits his feedback.
typedef OnSubmit =
    Future<void> Function(
      String? feedback, {
      Map<String, dynamic>? extras,
    });

/// A function that returns a Widget that prompts the user for feedback and
/// calls [OnSubmit] when the user wants to submit their feedback.
///
/// A non-null controller is provided if the sheet is set to draggable in the
/// feedback theme.
/// If the sheet is draggable, the non null controller should be passed into a
/// scrollable widget to make the feedback sheet expand when the widget is
/// scrolled. Typically, this will be a `ListView` or `SingleChildScrollView`
/// wrapping the feedback sheet's content.
/// See: [FeedbackThemeData.sheetIsDraggable] and [DraggableScrollableSheet].
///
/// If [onSubmit] is null, This only means that the user has drawn something
/// and they are in navigate mode while no freezeFrame, so you should
/// disable the submit button accordingly.
///
/// It is also very noticeable to the user why it is disabled
/// as if they have drawn something yet didn't clear and of course
/// ,since they are in navigate mode without freezeFrame,
/// they do not see it they would know the reason right away.
///
/// So no need to show any info or explanation.
typedef FeedbackBuilder =
    Widget Function(
      BuildContext,
      OnSubmit?, {
      ScrollController? scrollController,
    });

/// Function which gets called when the user submits his feedback.
/// [feedback] is the user generated feedback. A string, by default.
/// [app] is a raw png encoded image.
/// [OnFeedbackCallback] should cast [feedback] to the appropriate type.
typedef OnFeedbackCallback = FutureOr<void> Function(UserFeedback);

/// A feedback widget that uses a custom widget and data type for
/// prompting the user for their feedback. This widget should be the root of
/// your widget tree. Specifically, it should be above any [Navigator] widgets,
/// including the navigator provided by [MaterialApp].
///
/// For example like this
/// ```dart
/// BetterFeedback(
///   child: MaterialApp(
///   title: 'App',
///   home: MyHomePage(),
/// );
/// ```
///
class BetterFeedback extends StatefulWidget {
  const BetterFeedback({
    super.key,
    required this.child,
    this.feedbackBuilder,
    this.localizationsDelegates,
    this.localeOverride,
    this.initialMode = FeedbackMode.navigate,
    this.pixelRatio = 3.0,
  }) : assert(
         pixelRatio > 0,
         'pixelRatio needs to be larger than 0',
       );

  /// The application to wrap, typically a [MaterialApp].
  final Widget child;

  /// Returns a widget that prompts the user for feedback and calls the provided
  /// submit function with their completed feedback. Typically, this involves
  /// some form fields and a submit button that calls [OnSubmit] when pressed.
  /// Defaults to [StringFeedback] which uses a single editable text field to
  /// prompt for input.
  final FeedbackBuilder? feedbackBuilder;

  // /// Determines which theme will be used by the Feedback UI.
  // /// If set to [ThemeMode.system], the choice of which theme to use will be based
  // /// on the user's system preferences (using the [MediaQuery.platformBrightnessOf]).
  // /// If set to [ThemeMode.light] the [theme] will be used, regardless of the user's
  // /// system preference.  If [theme] isn't provided [FeedbackThemeData] will
  // /// be used.
  // /// If set to [ThemeMode.dark] the [darkTheme] will be used regardless of the
  // /// user's system preference. If [darkTheme] isn't provided, will fallback to
  // /// [theme]. If both [darkTheme] and [theme] aren't provided
  // /// [FeedbackThemeData.dark] will be used.
  // /// The default value is [ThemeMode.system].
  // final ThemeMode? themeMode;
  //
  // /// The Theme, which gets used to style the feedback ui if the [themeMode] is
  // /// ThemeMode.light or user's system preference is light.
  // final FeedbackThemeData? theme;
  //
  // /// The theme, which gets used to style the feedback ui if the [themeMode] is
  // /// ThemeMode.dark or user's system preference is dark.
  // final FeedbackThemeData? darkTheme;

  /// The delegates for this library's FeedbackLocalization widget.
  /// You need to supply the following delegates if you choose to customize it.
  /// [MaterialLocalizations]
  /// [CupertinoLocalizations]
  /// [WidgetsLocalizations]
  /// an instance of [LocalizationsDelegate]<[FeedbackLocalizations]>
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Can be used to set the locale.
  /// If it is not set, the platform default locale is used.
  /// If no platform default locale exists, english is used.
  final Locale? localeOverride;

  /// Set the default mode when launching feedback.
  /// By default it will allow the user to navigate.
  /// See [FeedbackMode] for other options.
  final FeedbackMode initialMode;

  /// The pixelRatio describes the scale between
  /// the logical pixels and the size of the output image.
  /// Specifying 1.0 will give you a 1:1 mapping between
  /// logical pixels and the output pixels in the image.
  /// The default is a pixel ration of 3 and a value below 1 is not recommended.
  ///
  /// See [RenderRepaintBoundary](https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary/toImage.html)
  /// for information on the underlying implementation.
  final double pixelRatio;

  /// Call `BetterFeedback.of(context)` to get an
  /// instance of [FeedbackData] on which you can call `.show()` or `.hide()`
  /// to enable or disable the feedback view.
  ///
  /// For example:
  /// ```dart
  /// BetterFeedback.of(context).show(...);
  /// BetterFeedback.of(context).hide(...);
  /// ```
  static FeedbackController of(BuildContext context) {
    final feedbackData = context.dependOnInheritedWidgetOfExactType<FeedbackData>();
    assert(
      feedbackData != null,
      'You need to add a $BetterFeedback widget above this context!',
    );
    return feedbackData!.controller;
  }

  @override
  State<BetterFeedback> createState() => _BetterFeedbackState();
}

class _BetterFeedbackState extends State<BetterFeedback> {
  FeedbackController controller = FeedbackController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onUpdateOfController);
    InternalController.instance.updateMode(widget.initialMode);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(onUpdateOfController);
  }

  void onUpdateOfController() => setState(() {});

  @override
  Widget build(BuildContext context) => FeedbackApp(
    localizationsDelegates: widget.localizationsDelegates,
    localeOverride: widget.localeOverride,
    child: FeedbackData(
      controller: controller,
      child: Builder(
        builder: (context) {
          assert(debugCheckHasFeedbackLocalizations(context));
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => FeedbackWidget(
                  isFeedbackVisible: controller.isVisible,
                  feedbackBuilder: widget.feedbackBuilder,
                  child: widget.child,
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../enums/custom_color_position.dart';

/// See the following image to get a better understanding of the properties.
/// ![Theme](https://raw.githubusercontent.com/ueman/feedback/master/img/theme_description.png "Theme")
class FeedbackThemeData {
  /// Creates a [FeedbackThemeData].
  /// ![Theme](https://raw.githubusercontent.com/ueman/feedback/master/img/theme_description.png "Theme")
  FeedbackThemeData({
    this.background,
    this.feedbackSheetColor,
    this.initialSheetHeight = .3,
    this.minSheetHeight = .2,
    this.maxSheetHeight = .7,
    this.activeFeedbackModeColor,
    this.drawColors = FeedbackC.drawColors,
    this.showCustomColor = true,
    this.customColorPosition = CustomColorPosition.trailing,
    this.inputHintStyle,
    this.inputStyle,
    this.inputDecoration,
    this.maxFeedbackLines,
    this.sheetIsDraggable = true,
    // this.themeModeOverride,
    this.dragHandleColor,
  }) : // if the user chooses to supply custom drawing colors,
       // make sure there is at least on color to draw with
       assert(
         // ignore: prefer_is_empty
         drawColors.length > 0,
         'There must be at least one color to draw with',
       );

  // /// Override the app themeMode if inserted below [MaterialApp] or [CupertinoApp], ... etc
  // final ThemeMode? themeModeOverride;

  /// The background of the feedback view.
  final Color? background;

  /// The background color of the bottom sheet in which the user can input
  /// his feedback and thoughts.
  final Color? feedbackSheetColor;

  /// The initial height of the bottom sheet as a fraction of the screen height.
  ///
  /// Value must be between [minSheetHeight] and [maxSheetHeight].
  final double initialSheetHeight;

  /// The minimum height of the bottom sheet as a fraction of the screen height.
  ///
  /// Values between .2 and .3 are usually ideal.
  final double minSheetHeight;

  /// The maximum height of the bottom sheet as a fraction of the screen height.
  ///
  /// Values between .6 and .7 are usually ideal.
  final double maxSheetHeight;

  /// The color to highlight the currently selected feedback mode.
  final Color? activeFeedbackModeColor;

  /// Colors which can be used to draw while in feedback mode.
  final List<Color> drawColors;

  /// Determines whether or not to show the custom color picker icon.
  final bool showCustomColor;

  /// Determines the position of the custom color picker icon.
  final CustomColorPosition customColorPosition;

  /// Text Style of the text above of the feedback text input.
  late final TextStyle? inputHintStyle;

  /// Text Style of the text input.
  late final TextStyle? inputStyle;

  /// Input decoration of the text input
  final InputDecoration? inputDecoration;

  /// Max lines of the feedback text input
  final int? maxFeedbackLines;

  /// Whether or not the bottom sheet is draggable.
  ///
  /// If this is set to true, the user feedback form will be wrapped in a
  /// [DraggableScrollableSheet] that will expand when the user drags upward on
  /// it. This is useful for large feedback forms.
  final bool sheetIsDraggable;

  /// Color of the drag handle on the feedback sheet
  final Color? dragHandleColor;

  /// Creates a copy of the current [FeedbackThemeData] with the given
  /// optional fields replaced with the given values.
  FeedbackThemeData copyWith({
    // ThemeMode? themeModeOverride,
    Color? background,
    Color? feedbackSheetColor,
    double? initialSheetHeight,
    double? minSheetHeight,
    double? maxSheetHeight,
    Color? activeFeedbackModeColor,
    List<Color>? drawColors,
    bool? showCustomColor,
    CustomColorPosition? customColorPosition,
    TextStyle? inputHintStyle,
    TextStyle? inputStyle,
    InputDecoration? inputDecoration,
    int? maxFeedbackLines,
    bool? sheetIsDraggable,
    Color? dragHandleColor,
  }) {
    return FeedbackThemeData(
      background: background ?? this.background,
      feedbackSheetColor: feedbackSheetColor ?? this.feedbackSheetColor,
      initialSheetHeight: initialSheetHeight ?? this.initialSheetHeight,
      minSheetHeight: minSheetHeight ?? this.minSheetHeight,
      maxSheetHeight: maxSheetHeight ?? this.maxSheetHeight,
      activeFeedbackModeColor: activeFeedbackModeColor ?? this.activeFeedbackModeColor,
      drawColors: drawColors ?? this.drawColors,
      inputHintStyle: inputHintStyle ?? this.inputHintStyle,
      inputStyle: inputStyle ?? this.inputStyle,
      sheetIsDraggable: sheetIsDraggable ?? this.sheetIsDraggable,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      // themeModeOverride: themeModeOverride ?? this.themeModeOverride,
      showCustomColor: showCustomColor ?? this.showCustomColor,
      customColorPosition: customColorPosition ?? this.customColorPosition,
      inputDecoration: inputDecoration ?? this.inputDecoration,
      maxFeedbackLines: maxFeedbackLines ?? this.maxFeedbackLines,
    );
  }
}

/// Provides an instance of [FeedbackThemeData] for all descendants.
class FeedbackTheme extends InheritedTheme {
  /// Creates a feedback theme that controls the color, opacity, and size of
  /// descendant widgets.
  ///
  /// Both [data] and [child] arguments must not be null.
  const FeedbackTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// This [FeedbackThemeData] can be obtained by calling
  /// `FeedbackTheme.of(context)`.
  final FeedbackThemeData data;

  /// The data from the closest instance of this class that encloses the given
  /// context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FeedbackThemeData theme = FeedbackTheme.of(context);
  /// ```
  static FeedbackThemeData of(BuildContext context) {
    final feedbackThemeData = context.dependOnInheritedWidgetOfExactType<FeedbackTheme>();
    return feedbackThemeData!.data;
  }

  @override
  bool updateShouldNotify(FeedbackTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final theme = context.findAncestorWidgetOfExactType<FeedbackTheme>();
    return identical(this, theme) ? child : FeedbackTheme(data: data, child: child);
  }
}

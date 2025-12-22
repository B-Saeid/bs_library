import 'package:bs_riverpod_utils/bs_riverpod_utils.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'live_data_or_query.dart';

part 'extensions.dart';
part 'session_data.g.dart';
part 'static_data.dart';

@Riverpod(keepAlive: true)
class LiveData extends _$LiveData {
  // /// To avoid have both LiveData and LiveData() in the code completion
  // /// but riverpod says there must be a default constructor. TEST IT.
  // LiveData._();

  @override
  LiveDataState build() => LiveDataState._();

  // ignore: avoid_build_context_in_providers
  void _keepSynced(BuildContext context) {
    _setThemeData(context);
    _setMediaQuery(context);
  }

  /// This method is to be called with the context at the top of your app.
  /// Make sure to wrap it inside `Future(() {...})` as below.
  ///
  /// Example:
  ///
  /// ```dart
  ///
  /// MaterialApp( // or .router
  ///
  ///   ...
  ///   builder: (context, child) {
  ///           // ignore: use_build_context_synchronously // use for silencing linter warning
  ///           Future(() => LiveData.init(context)); // you need to have a ProviderScope.
  ///           return child!;
  ///         },
  ///   ...
  /// ),
  /// ```
  ///
  /// or in router's builder callback:
  ///
  // ignore: avoid_build_context_in_providers
  static void init(BuildContext context) {
    context.read(liveDataProvider.notifier)._keepSynced(context);
    _initialized = true;
  }

  static bool _initialized = false;

  static void _assertInitialized() {
    assert(_initialized, notInitializedAssertionString);
  }

  @internal
  static const notInitializedAssertionString =
      'LiveData is not initialized, Make sure to initialize it by calling'
      ' `Future(() => LiveData.init(context));` '
      'in you root widget builder.';

  /// These static variables are used in the [StaticData] class.
  static double __scalePercentage = 1.0;

  static MediaQueryData __mediaQuery = const MediaQueryData();

  static Size __sizeQuery = Size.zero;

  static double __deviceWidth = __sizeQuery.width;

  static double __deviceHeight = __sizeQuery.height;

  static EdgeInsets __viewPadding = EdgeInsets.zero;

  static EdgeInsets __viewInsets = EdgeInsets.zero;

  static EdgeInsets __padding = EdgeInsets.zero;

  static bool __isPortrait = true;

  static ThemeData __themeData = ThemeData();

  static TextTheme __textTheme = const TextTheme();

  static bool __isLight = true;

  // ignore: avoid_build_context_in_providers
  void _setMediaQuery(BuildContext context) {
    final newMediaQuery = MediaQuery.of(context);
    if (state.mediaQuery == newMediaQuery) return;

    _updateMediaDependants(newMediaQuery);
    _updateLiveScalePercentage(newMediaQuery.textScaler);
  }

  @override
  bool updateShouldNotify(LiveDataState previous, LiveDataState next) {
    return true;
    // return super.updateShouldNotify(previous, next);
  }

  void _updateMediaDependants(MediaQueryData newMediaQuery) {
    final sizeQuery = newMediaQuery.size;
    state = state._copyWith(
      mediaQuery: newMediaQuery,
      sizeQuery: sizeQuery,
      deviceWidth: sizeQuery.width,
      deviceHeight: sizeQuery.height,
      viewPadding: newMediaQuery.viewPadding,
      viewInsets: newMediaQuery.viewInsets,
      padding: newMediaQuery.padding,
      isPortrait: newMediaQuery.orientation == Orientation.portrait,
    );
    __mediaQuery = state.mediaQuery;
    __sizeQuery = state.sizeQuery;
    __deviceWidth = state.deviceWidth;
    __deviceHeight = state.deviceHeight;
    __viewPadding = state.viewPadding;
    __viewInsets = state.viewInsets;
    __padding = state.padding;
    __isPortrait = state.isPortrait;
  }

  // ignore: avoid_build_context_in_providers
  void _setThemeData(BuildContext context) {
    final newThemeData = Theme.of(context);
    if (state.themeData == newThemeData) return;

    _updateThemeDependants(newThemeData);
  }

  void _updateThemeDependants(ThemeData newThemeData) {
    state = state._copyWith(
      themeData: newThemeData,
      textTheme: newThemeData.textTheme,
      isLight: newThemeData.brightness == Brightness.light,
    );
    __themeData = state.themeData;
    __textTheme = state.textTheme;
    __isLight = state.themeData.brightness == Brightness.light;
  }

  void _updateLiveScalePercentage(TextScaler textScaler) {
    final newPercentage = textScaler.scale(16) / 16;
    if (state.scaleFactor == newPercentage) return;
    // print('newPercentage: $newPercentage');

    state = state._copyWith(scaleFactor: newPercentage);
    __scalePercentage = state.scaleFactor;
  }

  /// Watcher static methods
  /// These methods are just shortcuts.
  ///
  /// For example:
  /// Instead of: `ref.watch(liveDataProvider.select((p) => p.scaleFactor))`
  /// we write: `LiveData.scalePercentage(ref)`

  static ProviderListenable<double> get scalePercentageSelector =>
      liveDataProvider.select((value) => value.scaleFactor);

  static double scalePercentage(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.scaleFactor));

  static ProviderListenable<MediaQueryData> get mediaQuerySelector =>
      liveDataProvider.select((value) => value.mediaQuery);

  static MediaQueryData mediaQuery(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.mediaQuery));

  static ProviderListenable<Size> get sizeQuerySelector =>
      liveDataProvider.select((value) => value.sizeQuery);

  static Size sizeQuery(WidgetRef ref) => ref.watch(liveDataProvider.select((p) => p.sizeQuery));

  static ProviderListenable<double> get widthSelector =>
      liveDataProvider.select((value) => value.deviceWidth);

  static double deviceWidth(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.deviceWidth));

  static ProviderListenable<double> get heightSelector =>
      liveDataProvider.select((value) => value.deviceHeight);

  static double deviceHeight(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.deviceHeight));

  static ProviderListenable<EdgeInsets> get viewPaddingSelector =>
      liveDataProvider.select((value) => value.viewPadding);

  static EdgeInsets viewPadding(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.viewPadding));

  static ProviderListenable<EdgeInsets> get viewInsetsSelector =>
      liveDataProvider.select((value) => value.viewInsets);

  static EdgeInsets viewInsets(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.viewInsets));

  static ProviderListenable<EdgeInsets> get paddingSelector =>
      liveDataProvider.select((value) => value.padding);

  static EdgeInsets padding(WidgetRef ref) => ref.watch(liveDataProvider.select((p) => p.padding));

  static ProviderListenable<bool> get isPortraitSelector =>
      liveDataProvider.select((value) => value.isPortrait);

  static bool isPortrait(WidgetRef ref) => ref.watch(liveDataProvider.select((p) => p.isPortrait));

  static ProviderListenable<ThemeData> get themeDataSelector =>
      liveDataProvider.select((value) => value.themeData);

  static ThemeData themeData(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.themeData));

  static ProviderListenable<TextTheme> get textThemeSelector =>
      liveDataProvider.select((value) => value.textTheme);

  static TextTheme textTheme(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.textTheme));

  static ProviderListenable<bool> get isLightSelector =>
      liveDataProvider.select((value) => value.isLight);

  static bool isLight(WidgetRef ref) => ref.watch(liveDataProvider.select((p) => p.isLight));

  /// End of watcher static methods

  /// Scaling Logic
  static double applyScaleLogic(
    double currentScaleFactor, {
    required double baseValue,
    bool allowBelow = true,
    double? maxValue,
    double? maxFactor,
    double? startFrom,
    double? beforeStart,
  }) {
    var scaledValue = baseValue * currentScaleFactor.clamp(0, maxFactor ?? double.infinity);

    if (startFrom != null && currentScaleFactor < startFrom) {
      return beforeStart ?? baseValue;
    }

    if (scaledValue < baseValue) {
      return allowBelow ? scaledValue : baseValue;
    } else {
      return scaledValue.clamp(baseValue, maxValue ?? scaledValue);
    }
  }
}

class LiveDataState {
  LiveDataState._({
    double scaleFactor = 1.0,
    MediaQueryData mediaQuery = const MediaQueryData(),
    Size sizeQuery = Size.zero,
    double deviceWidth = 0.0,
    double deviceHeight = 0.0,
    EdgeInsets viewPadding = EdgeInsets.zero,
    EdgeInsets viewInsets = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    bool isPortrait = true,
    ThemeData? themeData,
    TextTheme textTheme = const TextTheme(),
    bool isLight = true,
  }) : _isLight = isLight,
       _textTheme = textTheme,
       _isPortrait = isPortrait,
       _padding = padding,
       _viewInsets = viewInsets,
       _viewPadding = viewPadding,
       _deviceHeight = deviceHeight,
       _deviceWidth = deviceWidth,
       _sizeQuery = sizeQuery,
       _mediaQuery = mediaQuery,
       _scaleFactor = scaleFactor,
       _themeData = themeData ?? ThemeData();

  final double _scaleFactor;

  double get scaleFactor {
    LiveData._assertInitialized();
    return _scaleFactor;
  }

  final MediaQueryData _mediaQuery;

  MediaQueryData get mediaQuery {
    LiveData._assertInitialized();
    return _mediaQuery;
  }

  final Size _sizeQuery;

  Size get sizeQuery {
    LiveData._assertInitialized();
    return _sizeQuery;
  }

  final double _deviceWidth;

  double get deviceWidth {
    LiveData._assertInitialized();
    return _deviceWidth;
  }

  final double _deviceHeight;

  double get deviceHeight {
    LiveData._assertInitialized();
    return _deviceHeight;
  }

  final EdgeInsets _viewPadding;

  EdgeInsets get viewPadding {
    LiveData._assertInitialized();
    return _viewPadding;
  }

  final EdgeInsets _viewInsets;

  EdgeInsets get viewInsets {
    LiveData._assertInitialized();
    return _viewInsets;
  }

  final EdgeInsets _padding;

  EdgeInsets get padding {
    LiveData._assertInitialized();
    return _padding;
  }

  final bool _isPortrait;

  bool get isPortrait {
    LiveData._assertInitialized();
    return _isPortrait;
  }

  final ThemeData _themeData;

  ThemeData get themeData {
    LiveData._assertInitialized();
    return _themeData;
  }

  final TextTheme _textTheme;

  TextTheme get textTheme {
    LiveData._assertInitialized();
    return _textTheme;
  }

  final bool _isLight;

  bool get isLight {
    LiveData._assertInitialized();
    return _isLight;
  }

  LiveDataState _copyWith({
    double? scaleFactor,
    MediaQueryData? mediaQuery,
    Size? sizeQuery,
    double? deviceWidth,
    double? deviceHeight,
    EdgeInsets? viewPadding,
    EdgeInsets? viewInsets,
    EdgeInsets? padding,
    bool? isPortrait,
    ThemeData? themeData,
    TextTheme? textTheme,
    bool? isLight,
  }) => LiveDataState._(
    scaleFactor: scaleFactor ?? this.scaleFactor,
    mediaQuery: mediaQuery ?? this.mediaQuery,
    sizeQuery: sizeQuery ?? this.sizeQuery,
    deviceWidth: deviceWidth ?? this.deviceWidth,
    deviceHeight: deviceHeight ?? this.deviceHeight,
    viewPadding: viewPadding ?? this.viewPadding,
    viewInsets: viewInsets ?? this.viewInsets,
    padding: padding ?? this.padding,
    isPortrait: isPortrait ?? this.isPortrait,
    themeData: themeData ?? this.themeData,
    textTheme: textTheme ?? this.textTheme,
    isLight: isLight ?? this.isLight,
  );
}

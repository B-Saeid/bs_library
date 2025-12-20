import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'extensions.dart';
part 'session_data.g.dart';
part 'static_data.dart';

@Riverpod(keepAlive: true)
class LiveData extends _$LiveData {
  @override
  LiveDataState build() => LiveDataState._();

  /// This method is to be called with the context
  /// inside wrapped inside `Future(() {...})` at the top of your app.
  ///
  /// Example: In router's builder callback
  ///
  /// ```dart
  /// MaterialApp.router(
  ///   ...
  ///   builder: (context, child) {
  ///           // ignore: use_build_context_synchronously
  ///           Future(() => ref.read(liveDataProvider.notifier).keepSynced(context));
  ///           return child!;
  ///         },
  ///   ...
  /// ),
  /// ```
  ///
  /// or in router's builder callback:
  ///
  // ignore: avoid_build_context_in_providers
  void keepSynced(BuildContext context) {
    _setThemeData(context);
    _setMediaQuery(context);
  }

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

  late TextStyle _normalSize;

  void _updateThemeDependants(ThemeData newThemeData) {
    state = state._copyWith(
      themeData: newThemeData,
      textTheme: newThemeData.textTheme,
      isLight: newThemeData.brightness == Brightness.light,
    );
    __themeData = state.themeData;
    __textTheme = state.textTheme;
    _normalSize = state.textTheme.bodyMedium!; // you can use any textTheme
    __isLight = state.themeData.brightness == Brightness.light;
  }

  void _updateLiveScalePercentage(TextScaler textScaler) {
    final scaledSize = textScaler.scale(_normalSize.fontSize!);
    final newPercentage = scaledSize / _normalSize.fontSize!;
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

  static Size sizeQuery(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.sizeQuery));

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

  static EdgeInsets padding(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.padding));

  static ProviderListenable<bool> get isPortraitSelector =>
      liveDataProvider.select((value) => value.isPortrait);

  static bool isPortrait(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.isPortrait));

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

  static bool isLight(WidgetRef ref) =>
      ref.watch(liveDataProvider.select((p) => p.isLight));

  /// End of watcher static methods

  /// Scaling Logic
  static double _getScaledValue(
    WidgetRef ref, {
    required double baseValue,
    bool allowBelow = true,
    double? maxValue,
    double? maxFactor,
    double? startFrom,
    double? beforeStart,
  }) {
    final currentScaleFactor = LiveData.scalePercentage(ref);
    return applyScaleLogic(
      currentScaleFactor,
      baseValue: baseValue,
      allowBelow: allowBelow,
      maxValue: maxValue,
      maxFactor: maxFactor,
      startFrom: startFrom,
      beforeStart: beforeStart,
    );
  }

  static double applyScaleLogic(
    double currentScaleFactor, {
    required double baseValue,
    bool allowBelow = true,
    double? maxValue,
    double? maxFactor,
    double? startFrom,
    double? beforeStart,
  }) {
    var scaledValue =
        baseValue * currentScaleFactor.clamp(0, maxFactor ?? double.infinity);

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
    this.scaleFactor = 1.0,
    this.mediaQuery = const MediaQueryData(),
    this.sizeQuery = Size.zero,
    this.deviceWidth = 0.0,
    this.deviceHeight = 0.0,
    this.viewPadding = EdgeInsets.zero,
    this.viewInsets = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.isPortrait = true,
    ThemeData? themeData, // = ThemeData(),
    this.textTheme = const TextTheme(),
    this.isLight = true,
  }) : themeData = themeData ?? ThemeData();

  final double scaleFactor;

  final MediaQueryData mediaQuery;

  final Size sizeQuery;

  final double deviceWidth;

  final double deviceHeight;

  final EdgeInsets viewPadding;

  final EdgeInsets viewInsets;

  final EdgeInsets padding;

  final bool isPortrait;

  final ThemeData themeData;

  final TextTheme textTheme;

  final bool isLight;

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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'session_data.dart';

/// This is a helper class written to be used in internally in bs_library.
///
/// In case Developers opt out of using LiveData and keep using Inherited MediaQuery and ThemeData
/// this class provide a fallback to them without throwing initialization assertion exceptions.
///
/// ##### Here is the flow:
///   - WidgetRef is not null > use `LiveData`
///   - BuildContext is not null > use `MediaQuery`/`Theme`
///   - Both are null > use StaticData BUT BE AWARE THIS WILL THROW IF `LiveData` is not initialized.
///
/// ###### Be sure to pass either `ref` or `context` if a lively updating value is needed or Initialize `LiveData` if you omit both.
abstract class LiveDataOrQuery {
  static T? _getLiveValueOrNull<T>({
    required ProviderListenable<T> selector,
    required WidgetRef ref,
    required BuildContext? context,
  }) {
    try {
      return ref.watch(selector);
    } catch (_) {
      assert(
        context != null,
        'LiveData is not initialized YET you did not pass in a BuildContext for fallback',
      );

      return null;
    }

    /// I did not want to silence all error, I instead wanted to ONLY catch my assertion
    /// BUT "Bad state: No ProviderScope found" was thrown for users who do not use
    /// riverpod at all. If I say something like:
    /// ``` on StateError catch(e) {
    ///       if(e.message != 'No ProviderScope found') rethrow;
    ///       // and then only catch this one, It would be clumsy because
    ///       // the message may change and/or other errors would be encountered.
    ///       // So I chose to catch all for now.
    ///     }
    /// ```
    ///
    /*on AssertionError catch (error) {
      if (error.message != LiveData.notInitializedAssertionString) rethrow;

      /// Making that assertion here to avoid duplicating it in all methods.
      /// It is put there to safely null check in the caller on context when we returns null here.
      assert(
        context != null,
        'LiveData is not initialized YET you did not pass in a BuildContext for fallback',
      );

      return null;
    } catch (e) {
      rethrow;
    }*/
  }

  static double scalePercentage({WidgetRef? ref, BuildContext? context}) {
    double getLiveScalePercentage(TextScaler textScaler) {
      final percentage = textScaler.scale(16) / 16;
      print('percentage: $percentage');
      return percentage;
    }

    if (ref != null) {
      return _getLiveValueOrNull(
            ref: ref,
            selector: liveDataProvider.select((p) => p.scaleFactor),
            context: context,
          ) ??
          getLiveScalePercentage(MediaQuery.of(context!).textScaler);
    } else {
      return context != null
          ? getLiveScalePercentage(MediaQuery.of(context).textScaler)
          : StaticData.scalePercentage;
    }
  }

  static MediaQueryData mediaQuery({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              selector: liveDataProvider.select((p) => p.mediaQuery),
              ref: ref,
              context: context,
            ) ??
            MediaQuery.of(context!)
      : context != null
      ? MediaQuery.of(context)
      : StaticData.mediaQuery;

  static Size sizeQuery({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.sizeQuery),
              context: context,
            ) ??
            MediaQuery.sizeOf(context!)
      : context != null
      ? MediaQuery.sizeOf(context)
      : StaticData.sizeQuery;

  static double deviceWidth({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.deviceWidth),
              context: context,
            ) ??
            MediaQuery.sizeOf(context!).width
      : context != null
      ? MediaQuery.sizeOf(context).width
      : StaticData.deviceWidth;

  static double deviceHeight({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.deviceHeight),
              context: context,
            ) ??
            MediaQuery.sizeOf(context!).height
      : context != null
      ? MediaQuery.sizeOf(context).height
      : StaticData.deviceHeight;

  static EdgeInsets viewPadding({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.viewPadding),
              context: context,
            ) ??
            MediaQuery.viewPaddingOf(context!)
      : context != null
      ? MediaQuery.viewPaddingOf(context)
      : StaticData.viewPadding;

  static EdgeInsets viewInsets({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.viewInsets),
              context: context,
            ) ??
            MediaQuery.viewInsetsOf(context!)
      : context != null
      ? MediaQuery.viewInsetsOf(context)
      : StaticData.viewInsets;

  static EdgeInsets padding({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.padding),
              context: context,
            ) ??
            MediaQuery.paddingOf(context!)
      : context != null
      ? MediaQuery.paddingOf(context)
      : StaticData.padding;

  static bool isPortrait({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.isPortrait),
              context: context,
            ) ??
            MediaQuery.orientationOf(context!) == Orientation.portrait
      : context != null
      ? MediaQuery.orientationOf(context) == Orientation.portrait
      : StaticData.isPortrait;

  static ThemeData themeData({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.themeData),
              context: context,
            ) ??
            Theme.of(context!)
      : context != null
      ? Theme.of(context)
      : StaticData.themeData;

  static TextTheme textTheme({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.textTheme),
              context: context,
            ) ??
            Theme.of(context!).textTheme
      : context != null
      ? Theme.of(context).textTheme
      : StaticData.textTheme;

  static bool isLight({WidgetRef? ref, BuildContext? context}) => ref != null
      ? _getLiveValueOrNull(
              ref: ref,
              selector: liveDataProvider.select((p) => p.isLight),
              context: context,
            ) ??
            Theme.of(context!).brightness == Brightness.light
      : context != null
      ? Theme.of(context).brightness == Brightness.light
      : StaticData.isLight;
}

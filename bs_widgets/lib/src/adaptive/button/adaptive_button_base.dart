import 'package:bs_internet_service/bs_internet_service.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod_widgets/consumer_or_stateless.dart';
import '../adaptive_loading_indicator.dart';
import 'enums/density.dart';

abstract class AdaptiveButtonBase extends StatelessWidget {
  const AdaptiveButtonBase({
    super.key,
    this.adaptive = true,
    this.platform,
    this.child,
    required VoidCallback? onPressed,
    required VoidCallback? onLongPressed,
    this.animate = true,
    this.requireInternet = false,
    this.disableOnlyWhenDisconnected = false,
    this.forceUseContextForInternetPresentation = false,
    this.actionable = true,
    this.hidden,
    this.loadingIndicator,
    this.textStyle,
    this.foregroundColor,
    this.colorSchemeSeed,
    // this.fillColor,
    this.width,
    this.height,
    this.padding,
    this.addPadding,
    this.density,
    this.materialDensity,
    this.cupertinoSizeStyle,
  }) : _onPressed = onPressed,
       _onLongPressed = onLongPressed;

  /// A flag to return the correct button, as of now
  /// it responds to Material and Cupertino only. If set to `false`
  /// It fallbacks to using Material design regardless of the platform
  ///
  /// defaults to `true`
  // TODO : Use Fluent for Windows Later on.
  final bool adaptive;

  /// Overrides the current default platform.
  final TargetPlatform? platform;

  /// If you have a text child:
  /// It is **recommended** to pass the string directly to
  /// [child] and you can adjust [padding] to your liking.
  ///
  /// Either a String or a Widget.
  final dynamic child;

  /// If set to `null` the button will be disabled.
  final VoidCallback? _onPressed;

  final VoidCallback? _onLongPressed;

  /// Applies a subtle animation when child size changes
  ///
  /// defaults to: `true`
  final bool animate;

  /// Subscribes to `isConnectedWithUIProvider` of `bs_internet_service`
  /// which will act when internet connection changes:
  /// onDisconnected: button gets disabled until connection is restored
  /// onReconnected: button gets actionable again.
  ///
  /// ##### Notes when set to `true`:
  ///   - On web you need to import `bs_internet_service` and run:
  ///     `Internet.updateCheckerConfig(forceCheckOnWeb: true);`
  ///   - Because this depends on `riverpod`, you must be wrapping your app
  ///     or at least the button parent with [ProviderScope].
  ///   - By default it shows toasts on connection state changes,
  ///     you can [override](https://riverpod.dev/docs/concepts2/overrides)
  ///     `internetPresentationProvider` by extending [InternetPresentationBase]
  ///     and adjust the behaviour when connection state changes. OR you can
  ///     set [disableOnlyWhenDisconnected] to `true` and no UI will be shown
  ///     when connection state changes.
  ///
  ///
  /// defaults to `false`.
  final bool requireInternet;

  /// Disables any UI showing when connection state changes.
  ///
  /// It is ignored when [requireInternet] is not set to true.
  ///
  /// defaults to `false`.
  final bool disableOnlyWhenDisconnected;

  /// If `true` it will force the internet presentation to use
  /// the button's `BuildContext`.
  ///
  /// ###### ignored if [disableOnlyWhenDisconnected] is set `true`.
  ///
  /// ###### Note: if you use the default `internetPresentationProvider`:
  /// if you didn't call `Toast.setNavigatorKey` or `BsOverlay.setNavigatorKey`
  /// you need to pass this with `true` or an exception will be thrown.
  ///
  /// defaults to `false`
  final bool forceUseContextForInternetPresentation;

  /// Master flag. When set to `false` it disables the button,
  /// regardless of any other parameters.
  ///
  /// defaults to `true`.
  final bool actionable;

  /// Can be used to animate the appearance of the button.
  ///
  /// Size and place of the button is maintained either ways.
  final bool? hidden;

  /// A flag to show an adaptive loading indicator when set `true`
  ///
  /// Useful to prevent [onPressed] be called while being executed.
  ///
  /// Size and place of the button is maintained either ways.
  final bool? loadingIndicator;

  /// The Style of the button's child [Text]
  ///
  /// The color of the [textStyle] is typically not used directly, the
  /// [foregroundColor] is used instead.
  final TextStyle? textStyle;

  /// The color of the button's child `Text` and [icon]
  ///
  /// This color is typically used for the text instead of the color of the [textStyle],
  ///
  /// If omitted the default color of button's text and icon will be used
  /// unless [colorSchemeSeed] is set, If so, it will be evaluated from it
  // /// unless [fillColor] is set, If so, and the text and/or icon is thought
  // /// to be obscured by it, then the text color will be [fillColor.invertedBW],
  // /// a contrasting color to ensure text visibility.
  final Color? foregroundColor;

  // /// ##### This color will be used for:
  // ///   - in case of Material:
  // ///     - `surfaceTintColor` and `overlayColor` in all values of [type]
  // ///     - `backgroundColor` in case of [AdaptiveButtonType.filled]
  // ///     - `borderColor` in case of [AdaptiveButtonType.outlinedOrGreyed]
  // ///
  // ///   - in case of Cupertino:
  // ///     - `backgroundColor` in all values of [type] except [AdaptiveButtonType.plain]
  // ///
  // final Color? fillColor;

  /// Modify the colorScheme to be used instead of the inherited one from ThemeData
  ///
  /// This can used to put a specific button in a special color of your choice.
  final Color? colorSchemeSeed;

  /// Entire button width
  final double? width;

  /// Entire button height
  final double? height;

  /// Overrides default padding for the respected button.
  ///
  /// If you want to only add padding to the default padding,
  /// use [addPadding].
  final EdgeInsets? padding;

  /// Use this property when you need to add some padding to the default
  /// one assigned by the respected button.
  ///
  /// see also: [padding] if you want to take full
  /// control over the button internal padding
  final EdgeInsets? addPadding;

  /// If `null`, the *default* and none of [materialDensity] and [cupertinoSizeStyle] is specified,
  ///
  /// `CupertinoButtonSize.medium` is passed to `sizeStyle` for Cupertino
  /// and null is passed to `visualDensity` for Material
  ///
  /// see also: [materialDensity] and [cupertinoSizeStyle] if you want particular mapping on the platform
  final AdaptiveDensity? density;

  /// Specifies `visualDensity` to be passed to `Material` Buttons
  ///
  /// if not null, it will take precedence over [density]
  final VisualDensity? materialDensity;

  /// Specifies `sizeStyle` to be passed to `Cupertino` Buttons
  ///
  /// if not null, it will take precedence over [density]
  final CupertinoButtonSize? cupertinoSizeStyle;

  bool get isAppleAndAdaptive => (platform ?? StaticData.targetPlatform).isApple && adaptive;

  VisualDensity? get visualDensity => materialDensity ?? density?.visualDensity;

  CupertinoButtonSize get sizeStyle =>
      cupertinoSizeStyle ?? density?.sizeStyle ?? CupertinoButtonSize.medium;

  @override
  Widget build(BuildContext context) {
    // Important note in here when actionable is set to false
    // onPressed will also be null regardless of requireInternet bool
    // as actionable is setting the onPressed at the very start
    // of the build method to take effect in any case which
    // satisfies the top priority for the actionable flag
    final onPressed = actionable ? _onPressed : null;
    final onLongPressed = actionable ? _onLongPressed : null;

    var result = requireInternet
        ? _internetListenerWrapper(onPressed, onLongPressed)
        : buildButton(onPressed, onLongPressed);

    if (loadingIndicator != null) {
      result = Stack(
        children: [
          Visibility.maintain(
            visible: !loadingIndicator!,
            child: IgnorePointer(
              ignoring: loadingIndicator!,
              child: result,
            ),
          ),
          if (loadingIndicator!)
            Positioned.fill(
              child: AdaptiveLoadingIndicator(targetPlatform: platform),
            ),
        ],
      );
    }
    if (hidden != null) {
      result = AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        opacity: hidden ?? false ? 0 : 1,
        child: IgnorePointer(ignoring: hidden ?? false, child: result),
      );
    }

    if (animate) {
      result = AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInCubic,
        child: result,
      );
    }

    if (colorSchemeSeed != null) {
      result = ConsumerOrStateless(
        builder: (context, ref, child) {
          final origThemeData = LiveDataOrQuery.themeData(ref: ref, context: context);

          final seedModifiedThemeData = ThemeData(
            fontFamily: origThemeData.textTheme.bodySmall?.fontFamily,
            brightness: origThemeData.brightness,
            // colorSchemeSeed: colorSchemeSeed!,
            colorScheme: ColorScheme.fromSeed(
              seedColor: colorSchemeSeed!,
              brightness: origThemeData.brightness,

              /// This is to ensure that the colorScheme is exactly as we want it to be
              dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
            ),
            cupertinoOverrideTheme: origThemeData.cupertinoOverrideTheme,
          );

          return Theme(
            data: seedModifiedThemeData,
            // data: origThemeData,
            child: child!,
          );
        },
        child: result,
      );
    }

    return result;
  }

  /// Must depend on riverpod when using requireInternet
  Consumer _internetListenerWrapper(VoidCallback? onPressed, VoidCallback? onLongPressed) =>
      Consumer(
        builder: (context, ref, _) {
          final passedContext = forceUseContextForInternetPresentation ? context : null;

          /// This approach is to avoid the initial fluctuation of
          /// Button State and Internet Connection Indication UI
          /// i.e. button gets disabled then enabled with toasts or overlays
          /// indication internet connectivity is shown in an inconsistent way.
          ///
          /// What happens is:
          ///
          /// - We check if [Internet.connected] is null, which
          /// is the case when app first starts and no other listener had been
          /// attached to any connection provider.
          ///
          ///   - If true we watch [isConnectedProvider] to initially get the
          ///   connection status WITHOUT indicating any thing to user.
          ///
          ///   - If false, It means we KNOW the current connection status
          ///   so we normally watch [connectedWithUIProvider] to get the connection
          ///   status AND indicate any change to user.
          ///
          /// **NOTE**: Both Providers check and update on connection changes
          /// once a listener is attached BUT the first one does that without indicating
          /// any change to user i.e. It suppresses the initial fluctuation that happens
          /// when app first starts or in case this button was the first listener.
          final connected = Internet.connected == null
              /// am being optimistic here ^^
              ? (ref.watch(isConnectedProvider) ?? true)
              : ref.watch(
                  disableOnlyWhenDisconnected
                      ? isConnectedProvider
                      : isConnectedWithUIProvider(passedContext),
                )!;
          return buildButton(connected ? onPressed : null, connected ? onLongPressed : null);
        },
      );

  Widget buildButton(VoidCallback? onPressed, VoidCallback? onLongPressed);
}

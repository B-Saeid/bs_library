import 'package:bs_internet_service/bs_internet_service.dart';
import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod_widgets/ref_widget.dart';
import 'neat_circular_indicator.dart';

enum AdaptiveButtonType { filled, outlined, text, elevated }

enum AdaptiveButtonDensity {
  /// for Material: Maps to [VisualDensity.compact]
  /// for Cupertino: Maps to [StyleSize.small]
  compact,

  /// for Material: Maps to [VisualDensity.comfortable]
  /// for Cupertino: Maps to [StyleSize.medium]
  medium,

  /// for Material: Maps to [VisualDensity.maximumDensity] in both axes
  /// for Cupertino: Maps to [StyleSize.large]
  lossless
  ;

  bool get isCompact => this == AdaptiveButtonDensity.compact;
}

class AdaptiveButton extends StatelessWidget {
  /// Build a CustomButton with some UI and textStyle adjustments
  ///
  /// IF you want to use the a default button and also be able
  /// to specify your own adjustments from scratch use [AdaptiveButton.basic]
  const AdaptiveButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.requireInternet = false,
    this.actionable = true,
    this.hidden,
    this.adaptive = true,
    // this.crystal,
    this.loadingIndicator,
    this.type = AdaptiveButtonType.filled,
    this.textStyle,
    this.childHeight,
    this.width,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    this.fillColor,
    this.childPadding,
    this.addPadding,
    this.onLongPressed,
    this.density,
    this.forceUseContextForInternetPresentation = false,
  }) : basic = false,
       assert(child is String || child is Widget);

  const AdaptiveButton.basic({
    super.key,
    required this.child,
    required this.onPressed,
    this.requireInternet = false,
    this.actionable = true,
    this.hidden,
    this.adaptive = true,
    // this.crystal,
    this.loadingIndicator,
    this.type = AdaptiveButtonType.filled,
    this.textStyle,
    this.childHeight,
    this.width,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    this.fillColor,
    this.childPadding,
    this.addPadding,
    this.onLongPressed,
    this.density,
    this.forceUseContextForInternetPresentation = false,
  }) : basic = true,
       assert(child is String || child is Widget);

  /// If not true It will follow Material
  /// Also currently it is Cupertino for Apple Platforms
  /// and Material for all other platforms
  /// TO DO : Use Fluent for Windows Later on
  final bool adaptive;

  /// **Recommended** If you have a text child:
  /// pass the string directly in [child] and you can
  /// adjust [childPadding] to your liking.
  ///
  /// Either a String or a Widget
  final dynamic child;
  final VoidCallback? onPressed;
  final bool requireInternet;
  final bool actionable;
  final bool? hidden;

  // final bool? crystal;
  final bool? loadingIndicator;
  final AdaptiveButtonType type;
  final TextStyle? textStyle;

  /// [childPadding] is **NOT** included here
  ///
  /// Note that [childHeight] constraints the height and
  /// it is auto scaling according to textScale
  ///
  /// If you want to free the height or you want [density]
  /// or [textStyle.fontSize] to take effect keep it null
  final double? childHeight;

  /// Entire button width
  final double? width;
  final Widget? icon;
  final IconAlignment iconAlignment;
  final Color? fillColor;
  final EdgeInsets? childPadding;
  final EdgeInsets? addPadding;
  final VoidCallback? onLongPressed;

  /// If omitted,
  ///
  /// [CupertinoButtonSize.medium] is used for Apple platforms
  /// and null is passed to [VisualDensity]
  final AdaptiveButtonDensity? density;

  /// If true it will force the internet presentation to use
  /// `BuildContext` of the button
  ///
  /// default is false
  final bool forceUseContextForInternetPresentation;
  final bool basic;

  VisualDensity? get visualDensity => switch (density) {
    AdaptiveButtonDensity.compact => VisualDensity.compact,
    AdaptiveButtonDensity.medium => VisualDensity.comfortable,
    AdaptiveButtonDensity.lossless => const VisualDensity(
      horizontal: VisualDensity.maximumDensity,
      vertical: VisualDensity.maximumDensity,
    ),
    null => null,
  };

  CupertinoButtonSize get sizeStyle => switch (density) {
    AdaptiveButtonDensity.compact => CupertinoButtonSize.small,
    AdaptiveButtonDensity.medium => CupertinoButtonSize.medium,
    AdaptiveButtonDensity.lossless => CupertinoButtonSize.large,
    _ => CupertinoButtonSize.medium,
  };

  bool get iconExists => icon != null;

  bool get isAppleAndAdaptive => StaticData.platform.isApple && adaptive;

  // bool get isApple => StaticData.platform.isApple;

  static String? fontFamily;

  @override
  Widget build(BuildContext context) {
    fontFamily = Theme.of(context).textTheme.titleMedium?.fontFamily;

    /// Priority Order regarding button wrappers
    // hidden or not ... i.e. if hidden != null
    // we have to wrap with opacity to hide and show according to hidden bool
    /// and then regarding onPressed
    // actionable
    // requireInternet

    // Important note in here when actionable is set to false
    // onPressed will also be null regardless of requireInternet bool
    // as actionable is setting the onPressed at the very start
    // of the build method to take effect in any case which
    // satisfies the top priority for the actionable flag
    final onPressed = actionable ? this.onPressed : null;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInCubic,
      child: Stack(
        children: [
          Visibility.maintain(
            visible: !(loadingIndicator ?? false),
            child: IgnorePointer(
              ignoring: loadingIndicator ?? false,
              child: requireInternet
                  ? _internetListenerWrapper(onPressed)
                  : determineChild(onPressed),
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: loadingIndicator ?? false,
              child: const NeatCircularIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Consumer _internetListenerWrapper(VoidCallback? onPressed) => Consumer(
    builder: (context, ref, _) {
      final ancestorRouter = Router.maybeOf(context);
      final passedContext = (ancestorRouter != null && !forceUseContextForInternetPresentation)
          ? null
          : context;

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
          : ref.watch(isConnectedWithUIProvider(passedContext))!;

      return determineChild(
        connected ? onPressed : null,
      );
    },
  );

  Widget _opacityWrapper(Widget button) => AnimatedOpacity(
    duration: const Duration(milliseconds: 300),
    curve: Curves.ease,
    opacity: hidden ?? false ? 0 : 1,
    child: button,
  );

  Widget determineChild(VoidCallback? onPressed) {
    // final shouldCallOpacityWrapper = crystal != null;
    final mustCallOpacityWrapper = hidden != null;

    if (mustCallOpacityWrapper) {
      final button = buildButton(onPressed);
      return _opacityWrapper(button);
    } else {
      return buildButton(onPressed);
    }
  }

  Widget buildButton(VoidCallback? onPressed) => SizedBox(
    width: width,
    child: _buildAdaptiveButton(onPressed),
  );

  Widget _buildAdaptiveButton(VoidCallback? callToAction) {
    /// SUPER Useful AND SWEET but note [computeLuminance] is expensive
    final contrastingColor = fillColor?.invertedBW;

    /// Main Part
    Widget mainPart(WidgetRef ref) => _buildMainPart(
      contrastingColor,
      callToAction != null,
    );

    /// Icon Part
    final iconPart = iconExists ? _buildIcon(contrastingColor, callToAction != null) : null;

    return RefWidget(
      (ref) => isAppleAndAdaptive
          ? _appleButton(callToAction, mainPart(ref), iconPart)
          : _othersButton(callToAction, mainPart(ref), iconPart),
    );
  }

  Widget _buildMainPart(
    Color? contrastingColor,
    bool enabled,
  ) {
    TextStyle convenienceStyle(
      BuildContext context,
      WidgetRef ref,
    ) => /*LiveDataOrQuery.textTheme(ref:ref,context:context)
        .titleLarge!
        .copyExcept(
          color: false,
          fontFamily: false,
          foreground: false,
          backgroundColor: false,
          background: false,
          decoration: false,
          decorationColor: false,
          decorationStyle: false,
        )
        .copyWith(*/ TextStyle(
      color: enabled
          ? contrastingColor
          : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
      fontSize: basic
          ? null
          : LiveDataOrQuery.textTheme(ref: ref, context: context).titleLarge?.fontSize,
      height: basic
          ? null
          : LiveDataOrQuery.textTheme(ref: ref, context: context).titleLarge?.height,
      // foreground: basic ? null : LiveDataOrQuery.textTheme(ref:ref,context:context).titleLarge?.foreground,
      // fontWeight: basic || !isAppleAndAdaptive ? null : FontWeight.w700,
      fontWeight: basic
          ? null
          : LiveDataOrQuery.textTheme(ref: ref, context: context).titleLarge?.fontWeight,
      // fontVariations: basic || !isAppleAndAdaptive ? null : [FontVariation('wght', 600)],
      fontVariations: basic
          ? null
          : LiveDataOrQuery.textTheme(ref: ref, context: context).titleLarge?.fontVariations,
      fontFamily: fontFamily,
      // fontFamily: ref.watch(
      //   stylesProvider.select((value) => value.topLevelFamily),
      // ),
      // ),
    );
    return Consumer(
      builder: (context, ref, child) => Padding(
        padding: _mainPadding(context, ref),
        child: SizedBox(
          height: childHeight?.scalableFlexible(ref: ref, context: context),
          child: FittedBox(
            child: DefaultTextStyle.merge(
              ///
              /// TextStyle Priority:
              /// 1. the user provided [textStyle]
              /// 2. our [convenienceStyle]
              /// 3. the [DefaultTextStyle]
              ///
              /// Note: [disabledColor] has to be emphasized over any other color.
              /// This is done by copying [textStyle] ,The highest priority, with
              /// [LiveDataOrQuery.themeData(ref:ref,context:context).disabledColor]
              ///
              /// Also Note: We don't pass in [textStyle] to the [Text] widget below
              /// we have already merged it above, so either the user pass a Widget
              /// or a String in [child] we apply [textStyle] over any of them.
              ///
              style: convenienceStyle(context, ref).merge(
                textStyle?.copyWith(
                  color: enabled
                      ? null
                      : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
                ),
              ),
              child: child is String ? Text(child as String) : child as Widget,
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets _mainPadding(BuildContext context, WidgetRef ref) {
    if (childPadding != null) {
      if (addPadding == null) return childPadding!;

      return childPadding! + addPadding!;
    }

    final defaultPadding = basic
        ? LiveDataOrQuery.scalePercentage(ref: ref, context: context) > 1.5
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
              : EdgeInsets.zero
        : EdgeInsets.symmetric(
            /// When [IconExists] and It [isApple] Platform And [adaptive] is true
            /// i.e. we will actually build use [_appleButton] method so we don't need
            /// horizontal spacing as we handle it in the Row in [_appleButton]
            horizontal: iconExists
                ? isAppleAndAdaptive
                      ? 0
                      : 8
                : 25,
            vertical: isAppleAndAdaptive ? 0 : 10,
          );

    if (addPadding == null) return defaultPadding;

    return defaultPadding + addPadding!;
  }

  Consumer _buildIcon(Color? contrastingColor, bool enabled) => Consumer(
    builder: (context, ref, _) => SizedBox.square(
      /// TODO: Revisit dimension and the fittedBox below
      dimension: density?.isCompact ?? false
          ? 24.scalableFlexible(ref: ref, context: context, maxValue: 40)
          : 32.scalableFlexible(ref: ref, context: context, maxValue: 50),
      child: FittedBox(
        child: IconTheme.merge(
          data: IconThemeData(
            color: enabled
                ? contrastingColor
                : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
          ),
          child: icon!,
        ),
      ),
    ),
  );

  /// Normal Button for apple platforms
  CupertinoButton _appleButton(
    VoidCallback? callToAction,
    Widget mainPart,
    Widget? iconPart,
  ) {
    // final disabledColor = LiveDataOrQuery.themeData(ref:ref,context:context).disabledColor;
    final zChild = iconPart != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              if (iconAlignment == IconAlignment.start) iconPart,
              Flexible(child: mainPart),
              if (iconAlignment == IconAlignment.end) iconPart,
            ],
          )
        : mainPart;

    if (fillColor != null) {
      return CupertinoButton(
        onLongPress: onLongPressed,
        borderRadius: basic ? null : customBorderRadius,
        onPressed: callToAction,
        color: fillColor,
        // disabledColor: disabledColor,
        sizeStyle: sizeStyle,
        child: zChild,
      );
    }
    return switch (type) {
      AdaptiveButtonType.filled => CupertinoButton.filled(
        onLongPress: onLongPressed,
        borderRadius: basic ? null : customBorderRadius,
        onPressed: callToAction,
        // disabledColor: disabledColor,
        sizeStyle: sizeStyle,
        child: zChild,
      ),
      AdaptiveButtonType.elevated || AdaptiveButtonType.outlined => CupertinoButton.tinted(
        color: fillColor,
        onLongPress: onLongPressed,
        borderRadius: basic ? null : customBorderRadius,
        // disabledColor: disabledColor,
        onPressed: callToAction,
        sizeStyle: sizeStyle,
        child: zChild,
      ),
      AdaptiveButtonType.text => CupertinoButton(
        onLongPress: onLongPressed,
        borderRadius: basic ? null : customBorderRadius,
        // disabledColor: disabledColor,
        onPressed: callToAction,
        sizeStyle: sizeStyle,
        child: zChild,
      ),
    };
  }

  /// Normal Button for all other platforms
  RefWidget _othersButton(
    VoidCallback? callToAction,
    Widget mainPart,
    Widget? iconPart,
  ) {
    final shape = basic ? null : RoundedRectangleBorder(borderRadius: customBorderRadius);
    final filledStyle = FilledButton.styleFrom(
      backgroundColor: fillColor,
      shape: shape,
      visualDensity: visualDensity,
    );

    final outlinedStyle = OutlinedButton.styleFrom(
      backgroundColor: fillColor,
      shape: shape,
      visualDensity: visualDensity,
    );

    final textButtonStyle = TextButton.styleFrom(
      visualDensity: visualDensity,
      shape: shape,
      backgroundColor: fillColor,
    );

    final elevatedStyle = ElevatedButton.styleFrom(
      backgroundColor: fillColor,
      // foregroundColor: fillColor,
      shape: shape,
      visualDensity: visualDensity,
    );
    return RefWidget(
      (ref) => switch (type) {
        AdaptiveButtonType.filled =>
          /// Copied from Docs: If icon is null, will create a FilledButton instead
          FilledButton.icon(
            onPressed: callToAction,
            onLongPress: onLongPressed,
            icon: iconPart,
            iconAlignment: iconAlignment,
            style: filledStyle,
            label: mainPart,
          ),
        AdaptiveButtonType.outlined => OutlinedButton.icon(
          onPressed: callToAction,
          onLongPress: onLongPressed,
          icon: iconPart,
          iconAlignment: iconAlignment,
          style: outlinedStyle,
          label: mainPart,
        ),
        AdaptiveButtonType.text => TextButton.icon(
          onPressed: callToAction,
          onLongPress: onLongPressed,
          icon: iconPart,
          iconAlignment: iconAlignment,
          style: textButtonStyle,
          label: mainPart,
        ),
        AdaptiveButtonType.elevated => ElevatedButton.icon(
          onPressed: callToAction,
          onLongPress: onLongPressed,
          icon: iconPart,
          iconAlignment: iconAlignment,
          style: elevatedStyle,
          label: mainPart,
        ),
      },
    );
  }

  BorderRadius get customBorderRadius => BorderRadius.circular(8);
}

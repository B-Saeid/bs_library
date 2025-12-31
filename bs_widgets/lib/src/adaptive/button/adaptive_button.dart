import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod_widgets.dart';
import 'adaptive_button_base.dart';
import 'enums/types.dart';

class AdaptiveButton extends AdaptiveButtonBase {
  const AdaptiveButton({
    super.key,
    super.adaptive = true,
    super.platform,
    this.type = AdaptiveButtonType.plain,
    this.materialType,
    this.cupertinoType,
    required super.child,
    required super.onPressed,
    super.onLongPressed,
    super.animate = true,
    super.requireInternet = false,
    super.disableOnlyWhenDisconnected = false,
    super.forceUseContextForInternetPresentation = false,
    super.actionable = true,
    super.hidden,
    super.loadingIndicator,
    super.textStyle,
    super.foregroundColor,
    super.colorSchemeSeed,
    // super.fillColor,
    super.width,
    super.height,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    super.padding,
    super.addPadding,
    super.density,
    super.materialDensity,
    super.cupertinoSizeStyle,
  }) : assert(
         child is String || child is Widget,
         'Child can only be String directly or a Widget',
       ),
       _basic = true;

  /// Build an AdaptiveButton with some padding and textStyle adjustments.
  ///
  /// IF you want to use the a default button and also be able
  /// to specify your own adjustments, you can use [AdaptiveButton]
  const AdaptiveButton.custom({
    super.key,
    super.adaptive = true,
    super.platform,
    this.type = AdaptiveButtonType.plain,
    this.materialType,
    this.cupertinoType,
    required super.child,
    required super.onPressed,
    super.onLongPressed,
    super.animate = true,
    super.requireInternet = false,
    super.disableOnlyWhenDisconnected = false,
    super.forceUseContextForInternetPresentation = false,
    super.actionable = true,
    super.hidden,
    super.loadingIndicator,
    super.textStyle,
    super.foregroundColor,
    super.colorSchemeSeed,
    // super.fillColor,
    super.width,
    super.height,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    super.padding,
    super.addPadding,
    super.density,
    super.materialDensity,
    super.cupertinoSizeStyle,
  }) : assert(
         child is String || child is Widget,
         'Child can only be String directly or a Widget',
       ),
       _basic = false;

  /// ##### Parameter to control the look of the button with less code.
  /// ###### Instead of:
  /// ```
  /// someCondition
  ///         ? FilledButton(
  ///             onPressed: onPressed,
  ///             child: child,
  ///           )
  ///         : TextButton(
  ///             onPressed: onPressed,
  ///             child: child,
  ///           );
  /// ```
  ///
  /// ###### You can say:
  ///
  /// ```
  ///     AdaptiveButton(
  ///       type: someCondition ? .filled : .plain,
  ///       onPressed: onPressed,
  ///       child: child,
  ///     );
  /// ```
  ///
  /// see also: [materialType] and [cupertinoType] if you want particular mapping on the platform
  ///
  /// defaults to: [AdaptiveButtonType.plain]
  final AdaptiveButtonType type;

  /// Type to use in Material Buttons.
  ///
  /// If not null, this property takes precedence over [type].
  final MaterialButtonType? materialType;

  /// Type to use in Cupertino Buttons.
  ///
  /// If not null, this property takes precedence over [type].
  final CupertinoButtonType? cupertinoType;

  /// Exactly as you use [.icon] constructor on Material Buttons
  /// and in Cupertino a `Row` is used to show the icon
  ///
  /// see: [iconAlignment] to control the positioning of the icon
  final Widget? icon;

  /// Controls the positioning of the button's [icon].
  final IconAlignment iconAlignment;

  final bool _basic;

  bool get _iconExists => icon != null;

  MaterialButtonType? get _mType => isAppleAndAdaptive ? null : (materialType ?? type.mType);

  CupertinoButtonType? get _cType => isAppleAndAdaptive ? (cupertinoType ?? type.cType) : null;

  bool get _isFilled => _mType?.isFilled ?? _cType!.isFilled;

  @override
  Widget buildButton(VoidCallback? onPressed, VoidCallback? onLongPressed) {
    /// Main Part
    final mainPart = _buildMainPart(onPressed != null);

    /// Icon Part
    final iconPart = _iconExists ? _buildIcon(onPressed != null) : null;

    return SizedBox(
      width: width,
      height: height,
      child: isAppleAndAdaptive
          ? _appleButton(onPressed, onLongPressed, mainPart, iconPart)
          : _othersButton(onPressed, onLongPressed, mainPart, iconPart),
    );
  }

  // /// You should not invert [colorSchemeSeed] in these cases because the background is
  // /// not used utilizing [colorSchemeSeed] at all or it uses a dimmed version of it.
  // bool get _shouldInvertFillColorOnForeground =>
  //     [
  //           MaterialButtonType.text,
  //           MaterialButtonType.outlined,
  //           MaterialButtonType.elevated,
  //         ].contains(_mType) ||
  //         [CupertinoButtonType.plain, CupertinoButtonType.greyish].contains(_cType)
  //     ? false
  //     : true;

  Widget _buildMainPart(bool enabled) {
    TextStyle? resolvedStyle(BuildContext context, WidgetRef? ref) {
      // /// textStyle and foregroundColor are handled on .styleFrom when Material
      // if (!isAppleAndAdaptive) return null;

      final themeData = colorSchemeSeed != null
          ? Theme.of(context)
          : LiveDataOrQuery.themeData(ref: ref, context: context);

      final bodyLarge = themeData.textTheme.bodyLarge;
      final defaultForegroundColor = _isFilled
          ? themeData.colorScheme.onPrimary
          : themeData.colorScheme.primary;

      ///  What is happening:
      ///  -  text color =
      // ///     if enabled this.foregroundColor or defaultForegroundColor
      // ///     if enabled this.foregroundColor or fillColor?.invertedBW or defaultForegroundColor
      ///     if not it is = themeData.disabledColor
      ///  -  if this.textStyle is given it is used with its color adjusted as above
      ///     if not, we check for [this._basic], and only if false we use bodyLarge textStyle
      ///     also with its color adjusted as above
      ///
      /// Disabled foreground color is correctly resolved on Material,
      /// however, on Cupertino we found a bug when resolving effectiveForegroundColor
      /// in "flutter/packages/flutter/lib/src/cupertino/button.dart" ln: 485
      /// TODO: Send a PR
      ///
      /// That's why we use themeData.disabledColor when not enabled to ensure consistency.
      TextStyle? textStyle = TextStyle(
        color: enabled
            ? foregroundColor /*??
                  (_shouldInvertFillColorOnForeground ? colorSchemeSeed?.invertedBW : null)*/ ??
                  defaultForegroundColor
            : themeData.disabledColor,

        /// Used to workaround [CupertinoButton]s not using the app fontFamily
        fontFamily: bodyLarge?.fontFamily,
      );

      final merged = this.textStyle ?? (_basic ? null : bodyLarge);
      return merged?.merge(textStyle) ?? textStyle;
    }

    final customDefaultPadding = EdgeInsets.symmetric(
      horizontal: _iconExists
          ? isAppleAndAdaptive
                /// Another horizontal spacing of ~8.0 is in the Row in `_appleButton` when [iconExists]
                ? 8.0
                : 12.0
          : isAppleAndAdaptive
          ? 24
          : 18,
      vertical: isAppleAndAdaptive ? 0 : 10,
    );
    final defaultPadding = _basic ? EdgeInsets.zero : customDefaultPadding;

    final mainPadding = addPadding == null ? defaultPadding : defaultPadding + addPadding!;

    return ConsumerOrStateless(
      builder: (context, ref, child) => Padding(
        padding: mainPadding,
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
          style: resolvedStyle(context, ref),
          child: child!,
        ),
      ),
      child: child is String ? Text(child as String) : child as Widget,
    );
  }

  Widget _buildIcon(bool enabled) {
    IconThemeData resolvedData(BuildContext context, WidgetRef? ref) {
      final themeData = colorSchemeSeed != null
          ? Theme.of(context)
          : LiveDataOrQuery.themeData(ref: ref, context: context);
      final defaultForegroundColor = _isFilled
          ? themeData.colorScheme.onPrimary
          : themeData.colorScheme.primary;

      return IconThemeData(
        color: enabled
            ? foregroundColor ??
                  // (_shouldInvertFillColorOnForeground ? colorSchemeSeed?.invertedBW : null) ??
                  defaultForegroundColor
            : themeData.disabledColor,
        size: _basic ? null : 24,
      );
    }

    return ConsumerOrStateless(
      builder: (context, ref, child) => IconTheme.merge(
        data: resolvedData(context, ref),
        child: child!,
      ),
      child: icon!,
    );
  }

  BorderRadius get customBorderRadius => BorderRadius.circular(8);

  /// Cupertino Button for apple platforms
  Widget _appleButton(
    VoidCallback? onPressed,
    VoidCallback? onLongPressed,
    Widget mainPart,
    Widget? iconPart,
  ) {
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

    Color? resolvedColor(BuildContext context, WidgetRef? ref) {
      final colorScheme = colorSchemeSeed != null
          ? Theme.of(context).colorScheme
          : LiveDataOrQuery.themeData(ref: ref, context: context).colorScheme;

      return switch (_cType!) {
        CupertinoButtonType.plain => Colors.transparent,
        CupertinoButtonType.greyish =>
          /*fillColor?.withAlphaFraction(0.4) ??*/ colorScheme.surfaceContainerHighest,
        CupertinoButtonType.tinted =>
          /*fillColor?.withAlphaFraction(0.7) ??*/ colorScheme.secondaryContainer,
        CupertinoButtonType.filled => /*fillColor ??*/ colorScheme.primary,
      };
    }

    return ConsumerOrStateless(
      builder: (context, ref, child) => CupertinoButton.filled(
        color: resolvedColor(context, ref),
        onLongPress: onLongPressed,
        borderRadius: _basic ? null : customBorderRadius,
        padding: padding,
        onPressed: onPressed,
        sizeStyle: sizeStyle,
        child: zChild,
      ),
    );
  }

  /// Material Buttons for all other platforms
  Widget _othersButton(
    VoidCallback? onPressed,
    VoidCallback? onLongPressed,
    Widget mainPart,
    Widget? iconPart,
  ) {
    final shape = _basic ? null : RoundedSuperellipseBorder(borderRadius: customBorderRadius);

    /// Copied from Docs: If icon is null, it will return the respected normal button.
    switch (_mType!) {
      case MaterialButtonType.text:
        final textButtonStyle = TextButton.styleFrom(
          // surfaceTintColor: fillColor,
          // overlayColor: fillColor,
          shape: shape,
          padding: padding,
          visualDensity: visualDensity,
        );

        return TextButton.icon(
          onPressed: onPressed,
          onLongPress: onLongPressed,
          icon: iconPart,
          iconAlignment: iconAlignment,
          style: textButtonStyle,
          label: mainPart,
        );
      case MaterialButtonType.outlined:
        final outlinedStyle = OutlinedButton.styleFrom(
          // // backgroundColor: onPressed != null ? fillColor : null,
          // side: onPressed == null || fillColor == null ? null : BorderSide(color: fillColor!),
          // surfaceTintColor: fillColor,
          // overlayColor: fillColor,
          shape: shape,
          padding: padding,
          visualDensity: visualDensity,
        );

        return OutlinedButton.icon(
          onPressed: onPressed,
          onLongPress: onLongPressed,
          icon: iconPart,
          iconAlignment: iconAlignment,
          style: outlinedStyle,
          label: mainPart,
        );
      case MaterialButtonType.elevated:
        final elevatedStyle = ElevatedButton.styleFrom(
          // // backgroundColor: fillColor,
          // surfaceTintColor: fillColor,
          // overlayColor: fillColor,
          shape: shape,
          padding: padding,
          visualDensity: visualDensity,
        );

        return ElevatedButton.icon(
          onPressed: onPressed,
          onLongPress: onLongPressed,
          icon: iconPart,
          iconAlignment: iconAlignment,
          style: elevatedStyle,
          label: mainPart,
        );
      case MaterialButtonType.filledTonal:
        final tonalStyle = FilledButton.styleFrom(
          // backgroundColor: fillColor?.shadeColor(0.3),
          // surfaceTintColor: fillColor,
          // overlayColor: fillColor,
          shape: shape,
          padding: padding,
          visualDensity: visualDensity,
        );

        return FilledButton.tonalIcon(
          onPressed: onPressed,
          onLongPress: onLongPressed,
          icon: iconPart,
          iconAlignment: iconAlignment,
          style: tonalStyle,
          label: mainPart,
        );
      case MaterialButtonType.filled:
        final filledStyle = FilledButton.styleFrom(
          // backgroundColor: fillColor,
          // surfaceTintColor: fillColor,
          // overlayColor: fillColor,
          shape: shape,
          padding: padding,
          visualDensity: visualDensity,
        );

        return FilledButton.icon(
          onPressed: onPressed,
          onLongPress: onLongPressed,
          icon: iconPart,
          iconAlignment: iconAlignment,
          style: filledStyle,
          label: mainPart,
        );
    }
  }
}

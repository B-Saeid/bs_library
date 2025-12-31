import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
// import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../riverpod_widgets/consumer_or_stateless.dart';
import 'adaptive_button_base.dart';
import 'enums/types.dart';

// void _assertions(IconData? iconData, Widget? child, Color? iconColor, double? iconSize) {
//   assert(
//     (iconData != null) ^ (child != null),
//     'Only one of iconData and child must be passed, '
//     '${iconData == null && iconData == null ? 'Neither was passed' : 'NOT BOTH'}.',
//   );
//   assert(
//     iconData != null || (iconColor == null && iconSize == null),
//     'None of iconColor or iconSize is effective when iconData is not provided',
//   );
// }

class AdaptiveIconButton extends AdaptiveButtonBase {
  const AdaptiveIconButton({
    super.key,
    super.adaptive = true,
    super.platform,
    super.child,
    super.onPressed,
    super.onLongPressed,
    super.animate = true,
    super.requireInternet = false,
    super.disableOnlyWhenDisconnected = false,
    super.forceUseContextForInternetPresentation = false,
    super.actionable = true,
    super.hidden,
    super.loadingIndicator = false,
    super.foregroundColor,
    super.colorSchemeSeed,
    super.padding,
    super.addPadding,
    super.density,
    super.materialDensity,
    super.cupertinoSizeStyle,
    this.type = AdaptiveIconButtonType.plain,
    this.dimension,
    this.minimumSize,
    this.iconData,
    this.iconSize,
    this.iconColor,
    this.useSuperellipseOnApple = false,
  }) : assert(
         (iconData != null) ^ (child != null),
         'Only one of iconData and child must be passed, '
         '${iconData == null && iconData == null ? 'Neither was passed' : 'NOT BOTH'}.',
       ),
       assert(
         iconData != null || (iconColor == null && iconSize == null),
         'None of iconColor or iconSize is effective when iconData is not provided',
       ),
       super(width: dimension, height: dimension);

  /// The width and height of the button, hence it shall fit in a square anyway.
  ///
  /// button will be not larger, content can spill out or be obscured
  ///
  /// see also: [minimumSize] to allow sizing dynamic increase.
  final double? dimension;

  /// Set the bare minimum of the button Size.
  final Size? minimumSize;

  /// ##### Parameter to control the look of the button with less code.
  /// ###### Instead of:
  /// ```
  /// someCondition
  ///         ? IconButton.filled(
  ///             onPressed: onPressed,
  ///             icon: icon,
  ///           )
  ///         : IconButton(
  ///             onPressed: onPressed,
  ///             icon: icon,
  ///           );
  /// ```
  ///
  /// ###### You can say:
  ///
  /// ```
  ///     AdaptiveIconButton(
  ///       type: someCondition ? .filled : .plain,
  ///       onPressed: onPressed,
  ///       child: child,
  ///     );
  /// ```
  ///
  /// defaults to: [AdaptiveIconButtonType.plain]
  final AdaptiveIconButtonType type;

  /// Can be used to instead of `child: Icon(iconData)`
  final IconData? iconData;

  /// Sets the color of the icon **ONLY** when [iconData] is used.
  final Color? iconColor;

  /// Sets the size of the icon **ONLY** when [iconData] is used.
  ///
  /// If null, it uses the nearest [IconThemeData].size.
  /// If it is also null, the default size is 24.0.
  final double? iconSize;

  /// If true, the button will be [RoundedSuperellipse] on apple platforms
  /// instead of the circular shape.
  ///
  /// defaults to false.
  final bool useSuperellipseOnApple;

  @override
  Widget buildButton(VoidCallback? onPressed, VoidCallback? onLongPressed) => SizedBox.square(
    dimension: dimension,
    child: isAppleAndAdaptive
        ? _appleButton(onPressed, onLongPressed)
        : _othersButton(onPressed, onLongPressed),
  );

  Widget _buildIcon(bool enabled) {
    Widget result = child ?? Icon(iconData);
    if (addPadding != null) result = Padding(padding: addPadding!, child: result);

    return ConsumerOrStateless(
      builder: (context, ref, child) {
        final themeData = colorSchemeSeed != null
            ? Theme.of(context)
            : LiveDataOrQuery.themeData(ref: ref, context: context);

        final defaultForegroundColor = switch (type) {
          AdaptiveIconButtonType.plain ||
          AdaptiveIconButtonType.outlined => themeData.colorScheme.onSurfaceVariant,
          AdaptiveIconButtonType.tinted => themeData.colorScheme.onSecondaryContainer,
          AdaptiveIconButtonType.filled => themeData.colorScheme.onPrimary,
        };

        final iconThemeData = IconThemeData(
          color: enabled
              ? foregroundColor ?? iconColor ?? defaultForegroundColor
              : themeData.disabledColor,
          size: iconSize,
        );
        return IconTheme(
          data: iconThemeData,
          child: result,
        );
      },
    );
  }

  /// Android & Other platform button
  IconButton _othersButton(VoidCallback? onPressed, VoidCallback? onLongPressed) {
    final constraints = minimumSize == null
        ? null
        : BoxConstraints(minWidth: minimumSize!.width, minHeight: minimumSize!.height);

    return switch (type) {
      AdaptiveIconButtonType.plain => IconButton(
        icon: _buildIcon(onPressed != null),
        onPressed: onPressed,
        onLongPress: onLongPressed,
        constraints: constraints,
        padding: padding,
        visualDensity: visualDensity,
      ),
      AdaptiveIconButtonType.outlined => IconButton.outlined(
        icon: _buildIcon(onPressed != null),
        onPressed: onPressed,
        onLongPress: onLongPressed,
        constraints: constraints,
        padding: padding,
        visualDensity: visualDensity,
      ),
      AdaptiveIconButtonType.tinted => IconButton.filledTonal(
        icon: _buildIcon(onPressed != null),
        onPressed: onPressed,
        onLongPress: onLongPressed,
        constraints: constraints,
        padding: padding,
        visualDensity: visualDensity,
      ),
      AdaptiveIconButtonType.filled => IconButton.filled(
        icon: _buildIcon(onPressed != null),
        onPressed: onPressed,
        onLongPress: onLongPressed,
        constraints: constraints,
        padding: padding,
        visualDensity: visualDensity,
      ),
    };
  }

  /// Apple platform button
  Widget _appleButton(VoidCallback? onPressed, VoidCallback? onLongPressed) => ConsumerOrStateless(
    builder: (context, ref, child) {
      var result = _buildIcon(onPressed != null);

      final themeData = colorSchemeSeed != null
          ? Theme.of(context)
          : LiveDataOrQuery.themeData(ref: ref, context: context);

      result = switch (type) {
        AdaptiveIconButtonType.plain => _cupertinoButton(result, onPressed, onLongPressed),
        AdaptiveIconButtonType.outlined => _outlinedCupertinoButton(
          result,
          onPressed,
          onLongPressed,

          /// Copied from _OutlinedIconButtonDefaultsM3 in icon_button.dart
          borderColor: onPressed != null
              ? themeData.colorScheme.outline
              : themeData.colorScheme.onSurface.withAlphaFraction(0.12),
        ),
        AdaptiveIconButtonType.tinted || AdaptiveIconButtonType.filled => _coloredCupertinoButton(
          result,
          onPressed,
          onLongPressed,

          /// Copied from _FilledIconButtonDefaultsM3 and _FilledTonalIconButtonDefaultsM3 in icon_button.dart
          color: type.isTinted
              ? themeData.colorScheme.secondaryContainer
              : themeData.colorScheme.primary,
        ),
      };

      return result;
    },
  );

  /// Plain
  Widget _cupertinoButton(
    Widget child,
    VoidCallback? onPressed,
    VoidCallback? onLongPressed,
  ) {
    final cupertinoButton = CupertinoButton(
      onPressed: onPressed,
      onLongPress: onLongPressed,
      minimumSize: minimumSize,
      padding: padding,
      sizeStyle: sizeStyle,
      child: child,
    );

    return useSuperellipseOnApple
        ? cupertinoButton
        : Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: cupertinoButton,
          );
  }

  /// This is crafted to have a matching look of the Material counter part in Cupertino
  Widget _outlinedCupertinoButton(
    Widget child,
    VoidCallback? onPressed,
    VoidCallback? onLongPressed, {
    required Color borderColor,
  }) {
    final decoration = useSuperellipseOnApple
        ? ShapeDecoration(
            shape: RoundedSuperellipseBorder(
              borderRadius: kCupertinoButtonSizeBorderRadius[sizeStyle],
              side: BorderSide(color: borderColor),
            ),
          )
        : BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          );
    final borderlessDecoration = useSuperellipseOnApple
        ? ShapeDecoration(
            shape: RoundedSuperellipseBorder(
              borderRadius: kCupertinoButtonSizeBorderRadius[sizeStyle],
            ),
          )
        : const BoxDecoration(shape: BoxShape.circle);
    return Container(
      decoration: borderlessDecoration,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: CupertinoButton(
        onPressed: onPressed,
        onLongPress: onLongPressed,
        // The outer shall always be EdgeInsets.zero, padding is to be only placed in the lower one
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        child: DecoratedBox(
          decoration: decoration,

          /// Just put there as placeholder in order for the decoration to
          /// have the tap effect when the upper CupertinoButton is tapped
          /// otherwise the decoration box will be as small as possible.
          child: IgnorePointer(
            child: SizedBox.square(
              dimension: dimension,
              child: CupertinoButton(
                minimumSize: minimumSize,
                padding: padding,
                onPressed: null,
                sizeStyle: sizeStyle,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Tinted & Filled
  Widget _coloredCupertinoButton(
    Widget child,
    VoidCallback? onPressed,
    VoidCallback? onLongPressed, {
    required Color color,
  }) {
    final cupertinoButton = CupertinoButton.filled(
      minimumSize: minimumSize,
      color: color,
      onPressed: onPressed,
      onLongPress: onLongPressed,
      padding: padding,
      sizeStyle: sizeStyle,
      child: child,
    );

    return useSuperellipseOnApple
        ? cupertinoButton
        : Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: cupertinoButton,
          );
  }
}

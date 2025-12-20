import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _Type { outline, tinted, fill }

enum VisualSize {
  small,
  medium,
  large,

  /// Same as large, for apple platforms but it
  /// maps to [VisualDensity] of [Maximum] values for other platforms.
  huge,
}

class AdaptiveIconButton extends ConsumerWidget {
  const AdaptiveIconButton({
    super.key,
    this.iconData,
    this.child,
    required this.onPressed,
    this.iconSize,
    this.visualSize,
    this.iconColor,
    this.platform,
    this.forceCircularShapeOnApple = false,
  }) : _type = null,
       color = null,
       assert(
         (iconData != null) ^ (child != null),
         'Only one of iconData and child must be passed, '
         '${iconData == null && iconData == null ? 'Neither was passed' : 'NOT BOTH'}.',
       ),
       assert(
         iconData != null || (iconColor == null && iconSize == null),
         'None of iconColor or iconSize is effective when iconData is not provided',
       );

  const AdaptiveIconButton.outlined({
    super.key,
    this.iconData,
    this.child,
    required this.onPressed,
    this.iconSize,
    this.visualSize,
    this.color,
    this.iconColor,
    this.platform,
    this.forceCircularShapeOnApple = false,
  }) : _type = _Type.outline,
       assert(
         (iconData != null) ^ (child != null),
         'Only one of iconData and child must be passed, '
         '${iconData == null && iconData == null ? 'Neither was passed' : 'NOT BOTH'}.',
       ),
       assert(
         iconData != null || (iconColor == null && iconSize == null),
         'None of iconColor or iconSize is effective when iconData is not provided',
       );

  const AdaptiveIconButton.fill({
    super.key,
    this.iconData,
    this.child,
    required this.onPressed,
    this.iconSize,
    this.visualSize,
    this.color,
    this.iconColor,
    this.platform,
    this.forceCircularShapeOnApple = false,
  }) : _type = _Type.fill,
       assert(
         (iconData != null) ^ (child != null),
         'Only one of iconData and child must be passed, '
         '${iconData == null && iconData == null ? 'Neither was passed' : 'NOT BOTH'}.',
       ),
       assert(
         iconData != null || (iconColor == null && iconSize == null),
         'None of iconColor or iconSize is effective when iconData is not provided',
       );

  const AdaptiveIconButton.tinted({
    super.key,
    this.iconData,
    this.child,
    required this.onPressed,
    this.iconSize,
    this.visualSize,
    this.color,
    this.iconColor,
    this.platform,
    this.forceCircularShapeOnApple = false,
  }) : _type = _Type.tinted,
       assert(
         (iconData != null) ^ (child != null),
         'Only one of iconData and child must be passed, '
         '${iconData == null && iconData == null ? 'Neither was passed' : 'NOT BOTH'}.',
       ),
       assert(
         iconData != null || (iconColor == null && iconSize == null),
         'None of iconColor or iconSize is effective when iconData is not provided',
       );

  final IconData? iconData;
  final Widget? child;
  final VoidCallback? onPressed;
  final _Type? _type;

  /// If null, uses the nearest [IconThemeData].size.
  /// If it is also null, the default size is 24.0.
  final double? iconSize;
  final VisualSize? visualSize;

  final Color? color;
  final Color? iconColor;

  /// Use this to override the platform.
  final DevicePlatform? platform;

  /// If true, the button will be circular on apple platforms.
  /// instead of [RoundedSuperellipse].
  ///
  /// This is useful when you want to use the same button on both platforms
  /// with only different tap effect.
  ///
  /// defaults to false.
  final bool forceCircularShapeOnApple;

  static VisualDensity? _visualDensity(VisualSize? visualSize) => switch (visualSize) {
    VisualSize.small => const VisualDensity(
      vertical: VisualDensity.minimumDensity,
      horizontal: VisualDensity.minimumDensity,
    ),
    VisualSize.medium => VisualDensity.compact,
    VisualSize.large => VisualDensity.comfortable,
    VisualSize.huge => const VisualDensity(
      vertical: VisualDensity.maximumDensity,
      horizontal: VisualDensity.maximumDensity,
    ),
    null => null,
  };

  static CupertinoButtonSize _buttonSize(VisualSize? visualSize) => switch (visualSize) {
    VisualSize.small => CupertinoButtonSize.small,
    VisualSize.medium => CupertinoButtonSize.medium,
    VisualSize.large => CupertinoButtonSize.large,
    VisualSize.huge => CupertinoButtonSize.large,
    null => CupertinoButtonSize.large,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      (platform ?? StaticData.platform).isApple ? _appleButton(ref) : _othersButton;

  /// Android & Other platform button
  IconButton get _othersButton {
    const iconPadding = EdgeInsets.zero;
    // const iconPadding = EdgeInsets.all(4.0);
    const buttonPadding = EdgeInsets.zero;
    // const buttonPadding = EdgeInsets.all(12.0);
    final child = this.child ?? Icon(iconData);

    return switch (_type) {
      null => IconButton(
        style: IconButton.styleFrom(backgroundColor: color),
        color: iconColor,
        icon: Padding(
          padding: iconPadding,
          child: child,
        ),
        onPressed: onPressed,
        iconSize: iconSize,
        padding: buttonPadding,
        visualDensity: _visualDensity(visualSize),
      ),
      _Type.outline => IconButton.outlined(
        style: color == null ? null : IconButton.styleFrom(side: BorderSide(color: color!)),
        color: iconColor,
        icon: Padding(
          padding: iconPadding,
          child: child,
        ),
        onPressed: onPressed,
        iconSize: iconSize,
        padding: buttonPadding,
        visualDensity: _visualDensity(visualSize),
      ),
      _Type.tinted => IconButton.filledTonal(
        /// It is fulfilling to inter use your code.
        style: IconButton.styleFrom(backgroundColor: color?.darken(by: 0.7)),
        color: iconColor,
        icon: Padding(
          padding: iconPadding,
          child: child,
        ),
        onPressed: onPressed,
        iconSize: iconSize,
        padding: buttonPadding,
        visualDensity: _visualDensity(visualSize),
      ),
      _Type.fill => IconButton.filled(
        style: IconButton.styleFrom(backgroundColor: color),
        color: iconColor,
        icon: Padding(
          padding: iconPadding,
          child: child,
        ),
        onPressed: onPressed,
        iconSize: iconSize,
        padding: buttonPadding,
        visualDensity: _visualDensity(visualSize),
      ),
    };
  }

  /// Apple platform button
  Widget _appleButton(WidgetRef ref) {
    final child =
        this.child ??
        Icon(
          iconData,
          color: onPressed != null ? iconColor : LiveData.themeData(ref).disabledColor,
          size: iconSize,
        );

    final padding = const EdgeInsets.all(4.0);

    return switch (_type) {
      null => _cupertinoButton(
        child: child,
        padding: padding,
      ),
      _Type.outline => _outlinedCupertinoButton(
        ref: ref,
        child: child,
        padding: padding,
      ),
      _Type.tinted => _tintedCupertinoButton(
        child: child,
        padding: padding,
      ),
      _Type.fill => _filledCupertinoButton(
        child: child,
        padding: padding,
      ),
    };
  }

  Widget _cupertinoButton({
    required Widget child,
    required EdgeInsets padding,
  }) {
    final cupertinoButton = CupertinoButton(
      color: color,
      padding: padding,
      // minSize: 0,
      onPressed: onPressed,
      sizeStyle: _buttonSize(visualSize),
      child: child,
    );

    return forceCircularShapeOnApple
        ? Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: cupertinoButton,
          )
        : cupertinoButton;
  }

  Widget _outlinedCupertinoButton({
    required WidgetRef ref,
    required Widget child,
    required EdgeInsets padding,
  }) {
    final borderSide = BorderSide(
      // color: color ?? AppStyle.colors.adaptivePrimary(ref),
      color: color ?? LiveData.themeData(ref).colorScheme.primary,
    );
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // minSize: 0,
      onPressed: onPressed,
      sizeStyle: _buttonSize(visualSize),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: forceCircularShapeOnApple
              ? CircleBorder(side: borderSide)
              : RoundedSuperellipseBorder(
                  borderRadius: kCupertinoButtonSizeBorderRadius[_buttonSize(visualSize)],
                  side: borderSide,
                ),
        ),

        /// Just put there as placeholder in order for the decoration to
        /// have the tap effect when the upper CupertinoButton is tapped
        /// otherwise the decoration box will be as small as possible.
        child: IgnorePointer(
          child: CupertinoButton(
            padding: padding,
            // minSize: 0,
            onPressed: () {},
            // onPressed: onPressed,
            sizeStyle: _buttonSize(visualSize),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _tintedCupertinoButton({
    required Widget child,
    required EdgeInsets padding,
  }) {
    final cupertinoButton = CupertinoButton.tinted(
      color: color,
      padding: padding,
      // minSize: 0,
      onPressed: onPressed,
      sizeStyle: _buttonSize(visualSize),
      child: child,
    );
    return forceCircularShapeOnApple
        ? Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: cupertinoButton,
          )
        : cupertinoButton;
  }

  Widget _filledCupertinoButton({
    required Widget child,
    required EdgeInsets padding,
  }) {
    var cupertinoButton = CupertinoButton.filled(
      color: color,
      padding: padding,
      // minSize: 0,
      onPressed: onPressed,
      sizeStyle: _buttonSize(visualSize),
      child: child,
    );

    return forceCircularShapeOnApple
        ? Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: cupertinoButton,
          )
        : cupertinoButton;
  }
}

class TestingAdaptiveIconButton extends ConsumerWidget {
  const TestingAdaptiveIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 10,
      children: [
        Row(
          children: [
            const Text('Cupertino'),
            const Spacer(),
            AdaptiveIconButton(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.iOS,
            ),
            AdaptiveIconButton.outlined(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.iOS,
            ),
            AdaptiveIconButton.tinted(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.iOS,
            ),
            AdaptiveIconButton.fill(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.iOS,
            ),
          ],
        ),
        Row(
          children: [
            const Text('Cupertino Custom (Circular)'),
            const Spacer(),
            AdaptiveIconButton(
              onPressed: () {},
              iconColor: Colors.purpleAccent,
              forceCircularShapeOnApple: true,
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.iOS,
            ),
            AdaptiveIconButton.outlined(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              forceCircularShapeOnApple: true,
              iconSize: 35,
              iconColor: Colors.tealAccent,
              color: Colors.white,
              platform: DevicePlatform.iOS,
            ),
            AdaptiveIconButton.tinted(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              forceCircularShapeOnApple: true,
              iconColor: Colors.yellow,
              color: Colors.greenAccent,
              platform: DevicePlatform.iOS,
            ),
            AdaptiveIconButton.fill(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              iconColor: Colors.black,
              color: Colors.greenAccent,
              forceCircularShapeOnApple: true,
              platform: DevicePlatform.iOS,
            ),
          ],
        ),
        Row(
          children: [
            const Text('Material'),
            const Spacer(),
            AdaptiveIconButton(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.android,
            ),
            AdaptiveIconButton.outlined(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.android,
            ),
            AdaptiveIconButton.tinted(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.android,
            ),
            AdaptiveIconButton.fill(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.android,
            ),
          ],
        ),
        Row(
          children: [
            const Text('Material Custom'),
            const Spacer(),
            AdaptiveIconButton(
              onPressed: () {},
              iconColor: Colors.purpleAccent,
              forceCircularShapeOnApple: true,
              iconData: AppStyle.icons.bolt,
              platform: DevicePlatform.android,
            ),
            AdaptiveIconButton.outlined(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              forceCircularShapeOnApple: true,
              iconSize: 35,
              iconColor: Colors.tealAccent,
              color: Colors.white,
              platform: DevicePlatform.android,
            ),
            AdaptiveIconButton.tinted(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              forceCircularShapeOnApple: true,
              iconColor: Colors.yellow,
              color: Colors.greenAccent,
              platform: DevicePlatform.android,
            ),
            AdaptiveIconButton.fill(
              onPressed: () {},
              iconData: AppStyle.icons.bolt,
              color: Colors.greenAccent,
              iconColor: Colors.black,
              forceCircularShapeOnApple: true,
              platform: DevicePlatform.android,
            ),
          ],
        ),
      ],
    );
    // return Table(
    //   // defaultColumnWidth: const FlexColumnWidth(),
    //   defaultColumnWidth: const IntrinsicColumnWidth(),
    //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    //   border: TableBorder.all(color: AppStyle.colors.adaptivePrimary(ref)),
    //   // columnWidths: const {
    //   //   0: FlexColumnWidth(),
    //   //   1: FlexColumnWidth(),
    //   //   2: FlexColumnWidth(),
    //   //   3: FlexColumnWidth(),
    //   //   4: FlexColumnWidth(),
    //   // },
    //   children: [
    //     TableRow(
    //       children: [
    //         const Text('Apple'),
    //         AdaptiveIconButton(
    //           onPressed: () {},
    //           iconData: Icons.add,
    //           platform: DevicePlatform.iOS,
    //         ),
    //         AdaptiveIconButton.outlined(
    //           onPressed: () {},
    //           iconData: Icons.add,
    //           platform: DevicePlatform.iOS,
    //         ),
    //         AdaptiveIconButton.tinted(
    //           onPressed: () {},
    //           iconData: Icons.add,
    //           platform: DevicePlatform.iOS,
    //         ),
    //         AdaptiveIconButton.fill(
    //           onPressed: () {},
    //           iconData: Icons.add,
    //           platform: DevicePlatform.iOS,
    //         ),
    //       ],
    //     ),
    //     TableRow(
    //       children: [
    //         const Text('Android & Others'),
    //         AdaptiveIconButton(
    //           onPressed: () {},
    //           iconData: Icons.add,
    //           platform: DevicePlatform.android,
    //         ),
    //         AdaptiveIconButton.outlined(
    //           onPressed: () {},
    //           iconData: Icons.add,
    //           platform: DevicePlatform.android,
    //         ),
    //         AdaptiveIconButton.tinted(
    //           onPressed: () {},
    //           iconData: Icons.add,
    //           platform: DevicePlatform.android,
    //         ),
    //         AdaptiveIconButton.fill(
    //           onPressed: () {},
    //           iconData: Icons.add,
    //           platform: DevicePlatform.android,
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}

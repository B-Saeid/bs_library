import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../bs_widgets.dart';

// /// An item in a Material Design popup menu.
// ///
// /// To show a popup menu, use the [showMenu] function. To create a button that
// /// shows a popup menu, consider using [PopupMenuButton].
// ///
// /// To show a checkmark next to a popup menu item, consider using
// /// [AdaptivePopupItem.checked].
// ///
// /// Typically the [child] of a [AdaptivePopupItem] is a [Text] widget. More
// /// elaborate menus with icons can use a [ListTile]. By default, a
// /// [AdaptivePopupItem] is [kMinInteractiveDimension] pixels high. If you use a widget
// /// with a different height, it must be specified in the [height] property.
// ///
// /// {@tool snippet}
// ///
// /// Here, a [Text] widget is used with a popup menu item. The `Menu` type
// /// is an enum, not shown here.
// ///
// /// ```dart
// /// const PopupMenuItem<Menu>(
// ///   value: Menu.itemOne,
// ///   child: Text('Item 1'),
// /// )
// /// ```
// /// {@end-tool}
// ///
// /// See the example at [PopupMenuButton] for how this example could be used in a
// /// complete menu, and see the example at [AdaptivePopupItem.checked] for one way to
// /// keep the text of [AdaptivePopupItem]s that use [Text] widgets in their [child]
// /// slot aligned with the text of [AdaptivePopupItem.checked]s or of [AdaptivePopupItem]
// /// that use a [ListTile] in their [child] slot.
// ///
// /// See also:
// ///
// ///  * [PopupMenuDivider], which can be used to divide items from each other.
// ///  * [AdaptivePopupItem.checked], a variant of [AdaptivePopupItem] with a checkmark.
// ///  * [showMenu], a method to dynamically show a popup menu at a given location.
// ///  * [PopupMenuButton], an [IconButton] that automatically shows a menu when
// ///    it is tapped.
// class AdaptivePopupItem<T> extends PopupMenuEntry<T> {
//   /// Creates an item for a popup menu.
//   ///
//   /// By default, the item is [enabled].
//   const AdaptivePopupItem({
//     super.key,
//     this.value,
//     this.onTap,
//     this.enabled = true,
//     this.height = kMinInteractiveDimension,
//     this.padding,
//     this.textStyle,
//     this.labelTextStyle,
//     this.mouseCursor,
//     required this.child,
//   }) : checked = null;
//
//   const AdaptivePopupItem.checked({
//     super.key,
//     this.value,
//     this.onTap,
//     required bool this.checked,
//     this.enabled = true,
//     this.height = kMinInteractiveDimension,
//     this.padding,
//     this.textStyle,
//     this.labelTextStyle,
//     this.mouseCursor,
//     required this.child,
//   });
//
//   final bool? checked;
//
//   /// The value that will be returned by [showMenu] if this entry is selected.
//   final T? value;
//
//   /// Called when the menu item is tapped.
//   final VoidCallback? onTap;
//
//   /// Whether the user is permitted to select this item.
//   ///
//   /// Defaults to true. If this is false, then the item will not react to
//   /// touches.
//   final bool enabled;
//
//   /// The minimum height of the menu item.
//   ///
//   /// Defaults to [kMinInteractiveDimension] pixels.
//   @override
//   final double height;
//
//   /// The padding of the menu item.
//   ///
//   /// The [height] property may interact with the applied padding. For example,
//   /// If a [height] greater than the height of the sum of the padding and [child]
//   /// is provided, then the padding's effect will not be visible.
//   ///
//   /// If this is null and [ThemeData.useMaterial3] is true, the horizontal padding
//   /// defaults to 12.0 on both sides.
//   ///
//   /// If this is null and [ThemeData.useMaterial3] is false, the horizontal padding
//   /// defaults to 16.0 on both sides.
//   final EdgeInsets? padding;
//
//   /// The text style of the popup menu item.
//   ///
//   /// If this property is null, then [PopupMenuThemeData.textStyle] is used.
//   /// If [PopupMenuThemeData.textStyle] is also null, then [TextTheme.titleMedium]
//   /// of [ThemeData.textTheme] is used.
//   final TextStyle? textStyle;
//
//   /// The label style of the popup menu item.
//   ///
//   /// When [ThemeData.useMaterial3] is true, this styles the text of the popup menu item.
//   ///
//   /// If this property is null, then [PopupMenuThemeData.labelTextStyle] is used.
//   /// If [PopupMenuThemeData.labelTextStyle] is also null, then [TextTheme.labelLarge]
//   /// is used with the [ColorScheme.onSurface] color when popup menu item is enabled and
//   /// the [ColorScheme.onSurface] color with 0.38 opacity when the popup menu item is disabled.
//   final WidgetStateProperty<TextStyle?>? labelTextStyle;
//
//   /// {@template flutter.material.popupmenu.mouseCursor}
//   /// The cursor for a mouse pointer when it enters or is hovering over the
//   /// widget.
//   ///
//   /// If [mouseCursor] is a [WidgetStateMouseCursor],
//   /// [WidgetStateProperty.resolve] is used for the following [WidgetState]s:
//   ///
//   ///  * [WidgetState.hovered].
//   ///  * [WidgetState.focused].
//   ///  * [WidgetState.disabled].
//   /// {@endtemplate}
//   ///
//   /// If null, then the value of [PopupMenuThemeData.mouseCursor] is used. If
//   /// that is also null, then [WidgetStateMouseCursor.clickable] is used.
//   final MouseCursor? mouseCursor;
//
//   /// The widget below this widget in the tree.
//   ///
//   /// Typically a single-line [ListTile] (for menus with icons) or a [Text]. An
//   /// appropriate [DefaultTextStyle] is put in scope for the child. In either
//   /// case, the text should be short enough that it won't wrap.
//   final Widget? child;
//
//   @override
//   bool represents(T? value) => value == this.value;
//
//   @override
//   AdaptivePopupItemState<T, AdaptivePopupItem<T>> createState() =>
//       AdaptivePopupItemState<T, AdaptivePopupItem<T>>();
// }
//
// /// The [State] for [AdaptivePopupItem] subclasses.
// ///
// /// By default this implements the basic styling and layout of Material Design
// /// popup menu items.
// ///
// /// The [buildChild] method can be overridden to adjust exactly what gets placed
// /// in the menu. By default it returns [AdaptivePopupItem.child].
// ///
// /// The [handleTap] method can be overridden to adjust exactly what happens when
// /// the item is tapped. By default, it uses [Navigator.pop] to return the
// /// [AdaptivePopupItem.value] from the menu route.
// ///
// /// This class takes two type arguments. The second, `W`, is the exact type of
// /// the [Widget] that is using this [State]. It must be a subclass of
// /// [AdaptivePopupItem]. The first, `T`, must match the type argument of that widget
// /// class, and is the type of values returned from this menu.
// class AdaptivePopupItemState<T, W extends AdaptivePopupItem<T>> extends State<W> {
//   /// The menu item contents.
//   ///
//   /// Used by the [build] method.
//   ///
//   /// By default, this returns [AdaptivePopupItem.child]. Override this to put
//   /// something else in the menu entry.
//   @protected
//   Widget? buildChild() => widget.child;
//
//   /// The handler for when the user selects the menu item.
//   ///
//   /// Used by the [InkWell] inserted by the [build] method.
//   ///
//   /// By default, uses [Navigator.pop] to return the [AdaptivePopupItem.value] from
//   /// the menu route.
//   @protected
//   void handleTap() {
//     /// Need to pop the navigator first in case onTap may push new route onto navigator.
//     Navigator.pop<T>(context, widget.value);
//
//     widget.onTap?.call();
//   }
//
//   @override
//   @protected
//   Widget build(BuildContext context) => widget.checked != null
//       ? StaticData.targetPlatform.isApple
//             ? CheckedCupertinoPopupMenuItem(
//                 value: widget.value,
//                 checked: widget.checked!,
//                 onTap: widget.onTap,
//                 enabled: widget.enabled,
//                 height: widget.height,
//                 padding: widget.padding,
//                 labelTextStyle: widget.labelTextStyle,
//                 mouseCursor: widget.mouseCursor,
//                 child: widget.child,
//               )
//             : CheckedMaterialPopupMenuItem(
//                 value: widget.value,
//                 checked: widget.checked!,
//                 onTap: widget.onTap,
//                 enabled: widget.enabled,
//                 height: widget.height,
//                 padding: widget.padding,
//                 labelTextStyle: widget.labelTextStyle,
//                 mouseCursor: widget.mouseCursor,
//                 child: widget.child,
//               )
//       : StaticData.targetPlatform.isApple
//       ? CupertinoPopupItem(
//           value: widget.value,
//           onTap: widget.onTap,
//           enabled: widget.enabled,
//           height: widget.height,
//           padding: widget.padding,
//           textStyle: widget.textStyle,
//           labelTextStyle: widget.labelTextStyle,
//           mouseCursor: widget.mouseCursor,
//           child: widget.child,
//         )
//       : MaterialPopupMenuItem(
//           value: widget.value,
//           onTap: widget.onTap,
//           enabled: widget.enabled,
//           height: widget.height,
//           padding: widget.padding,
//           textStyle: widget.textStyle,
//           labelTextStyle: widget.labelTextStyle,
//           mouseCursor: widget.mouseCursor,
//           child: widget.child,
//         );
// }

class AdaptivePopupMenuItem<T> extends PopupMenuEntry<T> {
  const AdaptivePopupMenuItem({
    super.key,
    this.value,
    this.onTap,
    this.autoPop = true,
    this.enabled = true,
    this.checked,
    this.selected,
    double? height,
    // this.padding,
    // this.textStyle,
    // this.labelTextStyle,
    // this.mouseCursor,
    required this.child,
    this.platform,
  }) : _height = height;

  @override
  State<StatefulWidget> createState() => _AdaptivePopupMenuItemState<T>();

  final bool? checked;
  final bool? selected;
  final bool autoPop;

  /// The value that will be returned by [showMenu] if this entry is selected.
  final T? value;

  /// Called when the menu item is tapped.
  final VoidCallback? onTap;

  /// Whether the user is permitted to select this item.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches.
  final bool enabled;

  final double? _height;

  /// The minimum height of the menu item.
  ///
  /// If height is not provided in the constructor, this defaults to:
  ///  - [kMinInteractiveDimensionCupertino] pixels on iOS
  ///  - [kMinInteractiveDimension] pixels on Android.
  @override
  double get height =>
      _height ??
      (StaticData.targetPlatform.isApple
          ? kMinInteractiveDimensionCupertino
          : kMinInteractiveDimension);

  // /// The padding of the menu item.
  // ///
  // /// The [height] property may interact with the applied padding. For example,
  // /// If a [height] greater than the height of the sum of the padding and [child]
  // /// is provided, then the padding's effect will not be visible.
  // ///
  // /// If this is null and [ThemeData.useMaterial3] is true, the horizontal padding
  // /// defaults to 12.0 on both sides.
  // ///
  // /// If this is null and [ThemeData.useMaterial3] is false, the horizontal padding
  // /// defaults to 16.0 on both sides.
  // final EdgeInsets? padding;

  // /// The text style of the popup menu item.
  // ///
  // /// If this property is null, then [PopupMenuThemeData.textStyle] is used.
  // /// If [PopupMenuThemeData.textStyle] is also null, then [TextTheme.titleMedium]
  // /// of [ThemeData.textTheme] is used.
  // final TextStyle? textStyle;

  // /// The label style of the popup menu item.
  // ///
  // /// When [ThemeData.useMaterial3] is true, this styles the text of the popup menu item.
  // ///
  // /// If this property is null, then [PopupMenuThemeData.labelTextStyle] is used.
  // /// If [PopupMenuThemeData.labelTextStyle] is also null, then [TextTheme.labelLarge]
  // /// is used with the [ColorScheme.onSurface] color when popup menu item is enabled and
  // /// the [ColorScheme.onSurface] color with 0.38 opacity when the popup menu item is disabled.
  // final WidgetStateProperty<TextStyle?>? labelTextStyle;

  // /// {@template flutter.material.popupmenu.mouseCursor}
  // /// The cursor for a mouse pointer when it enters or is hovering over the
  // /// widget.
  // ///
  // /// If [mouseCursor] is a [WidgetStateMouseCursor],
  // /// [WidgetStateProperty.resolve] is used for the following [WidgetState]s:
  // ///
  // ///  * [WidgetState.hovered].
  // ///  * [WidgetState.focused].
  // ///  * [WidgetState.disabled].
  // /// {@endtemplate}
  // ///
  // /// If null, then the value of [PopupMenuThemeData.mouseCursor] is used. If
  // /// that is also null, then [WidgetStateMouseCursor.clickable] is used.
  // final MouseCursor? mouseCursor;

  /// The widget below this widget in the tree.
  ///
  /// Typically a single-line [ListTile] (for menus with icons) or a [Text]. An
  /// appropriate [DefaultTextStyle] is put in scope for the child. In either
  /// case, the text should be short enough that it won't wrap.
  final Widget child;

  /// When passed, it will override the target platform to use for the menu item.
  final TargetPlatform? platform;

  @override
  bool represents(T? value) => value == this.value;
}

class _AdaptivePopupMenuItemState<T> extends State<AdaptivePopupMenuItem<T>> {
  /// The handler for when the user selects the menu item.
  ///
  /// Used by the [InkWell] inserted by the [build] method.
  ///
  /// By default, uses [Navigator.pop] to return the [MaterialPopupMenuItem.value] from
  /// the menu route.
  @protected
  void handleTap() {
    /// Need to pop the navigator first in case onTap may push new route onto navigator.
    if (widget.autoPop) Navigator.pop<T>(context, widget.value);

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ConsumerOrStateless(
      builder: (context, ref, child) {
        final leading = widget.checked == true
            ? Icon(
                AppStyle.icons.check,
                size: 24.scalableFlexible(
                  ref: ref,
                  context: context,
                  maxFactor: 1.2,
                  allowBelow: false,
                ),
              )
            : null;

        final themeData = LiveDataOrQuery.themeData(ref: ref, context: context);
        final selected = widget.selected == true;
        final appleTile = CupertinoButton(
          color: selected ? themeData.highlightColor : null,
          sizeStyle: CupertinoButtonSize.medium,
          onPressed: handleTap,
          child: Row(
            spacing: 12,
            children: [
              ?leading,
              DefaultTextStyle.merge(
                style: themeData.textTheme.bodyLarge?.copyWith(
                  color: selected ? themeData.colorScheme.primary : themeData.colorScheme.onSurface,
                ),
                child: Expanded(child: widget.child),
              ),
            ],
          ),
        );
        final othersTile = ListTile(
          leading: leading,
          title: widget.child,
          tileColor: selected ? themeData.highlightColor : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          onTap: handleTap,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: (widget.platform ?? StaticData.targetPlatform).isApple ? appleTile : othersTile,
        );
      },
    );

    // return AdaptiveListTile(
    //   title: widget.child ?? const SizedBox(),
    //   onPressed: widget.onTap,
    //   enabled: widget.enabled,
    // );
  }
}

// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'custom_animated_size.dart';
//
// class _CupertinoMenuPopUpData<T> extends InheritedWidget {
//   const _CupertinoMenuPopUpData({
//     super.key,
//     required super.child,
//     required this.completer,
//     required this.closeHandler,
//   });
//
//   final Completer<T> completer;
//   final VoidCallback closeHandler;
//
//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
// }
//
// class CupertinoMenuPopUp<T> extends StatefulWidget {
//   const CupertinoMenuPopUp({
//     super.key,
//     required this.items,
//     required this.completer,
//     this.position = Offset.zero,
//   });
//
//   static _CupertinoMenuPopUpData _of<T>(BuildContext context) =>
//       context.dependOnInheritedWidgetOfExactType<_CupertinoMenuPopUpData>()!;
//
//   final Completer completer;
//   final List<CupertinoMenuPopUpItem> items;
//   final Offset position;
//
//   @override
//   State createState() => _CupertinoMenuPopUpState();
// }
//
// class _CupertinoMenuPopUpState extends State<CupertinoMenuPopUp> {
//   // late final AnimationController _controller;
//   // late final Animation<Offset> _animation;
//
//   bool opened = false;
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() => opened = true);
//   }
//
//   @override
//   Widget build(BuildContext context) => _CupertinoMenuPopUpData(
//         completer: widget.completer,
//         closeHandler: () => setState(() => opened = false),
//         child: CustomAnimatedSize(
//           child: !opened
//               ? SizedBox()
//               : SingleChildScrollView(
//                   child: CupertinoListSection.insetGrouped(
//                     children: widget.items,
//                   ),
//                 ),
//         ),
//       );
// }
//
// class CupertinoMenuPopUpItem<T> extends StatelessWidget {
//   final T? value;
//   final Widget child;
//   final VoidCallback? onPressed;
//
//   const CupertinoMenuPopUpItem({
//     super.key,
//     this.value,
//     this.onPressed,
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) => CupertinoListTile(
//         title: child,
//         onTap: () {
//           onPressed?.call();
//           final data = CupertinoMenuPopUp._of(context);
//           data.completer.complete(value);
//           data.closeHandler;
//         },
//       );
// }
// ///
// ///
// ///
// class CupertinoMenuItem<T> extends PopupMenuEntry<T> {
//   /// Abstract const constructor. This constructor enables subclasses to provide
//   /// const constructors so that they can be used in const expressions.
//   const CupertinoMenuItem({
//     this.value,
//     this.onTap,
//     this.enabled = true,
//     this.height = 44.0,
//     this.padding,
//     this.textStyle,
//     // this.labelTextStyle,
//     this.mouseCursor,
//     required this.child,
//     super.key,
//   });
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
//   // /// The label style of the popup menu item.
//   // ///
//   // /// When [ThemeData.useMaterial3] is true, this styles the text of the popup menu item.
//   // ///
//   // /// If this property is null, then [PopupMenuThemeData.labelTextStyle] is used.
//   // /// If [PopupMenuThemeData.labelTextStyle] is also null, then [TextTheme.labelLarge]
//   // /// is used with the [ColorScheme.onSurface] color when popup menu item is enabled and
//   // /// the [ColorScheme.onSurface] color with 0.38 opacity when the popup menu item is disabled.
//   // final MaterialStateProperty<TextStyle?>? labelTextStyle;
//
//   /// {@template flutter.material.popupmenu.mouseCursor}
//   /// The cursor for a mouse pointer when it enters or is hovering over the
//   /// widget.
//   ///
//   /// If [mouseCursor] is a [WidgetStateProperty<MouseCursor>],
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
//   final Widget child;
//
//   // /// The amount of vertical space occupied by this entry.
//   // ///
//   // /// This value is used at the time the [showMenu] method is called, if the
//   // /// `initialValue` argument is provided, to determine the position of this
//   // /// entry when aligning the selected entry over the given `position`. It is
//   // /// otherwise ignored.
//   // @override
//   // double get height => 44.0;
//
//   /// Whether this entry represents a particular value.
//   ///
//   /// This method is used by [showMenu], when it is called, to align the entry
//   /// representing the `initialValue`, if any, to the given `position`, and then
//   /// later is called on each entry to determine if it should be highlighted (if
//   /// the method returns true, the entry will have its background color set to
//   /// the ambient [ThemeData.highlightColor]). If `initialValue` is null, then
//   /// this method is not called.
//   ///
//   /// If the [PopupMenuEntry] represents a single value, this should return true
//   /// if the argument matches that value. If it represents multiple values, it
//   /// should return true if the argument matches any of them.
//   @override
//   bool represents(T? value) => this.value == value;
//
//   @override
//   State<StatefulWidget> createState() => _CupertinoMenuItemState();
// }
//
// class _CupertinoMenuItemState<T> extends State<CupertinoMenuItem<T>> {
//   void handleTap() {
//     // Need to pop the navigator first in case onTap may push new route onto navigator.
//     Navigator.pop<T>(context, widget.value);
//
//     widget.onTap?.call();
//   }
//   @override
//   Widget build(BuildContext context) {
//     // final theme = CupertinoTheme.of(context);
//     return CupertinoListTile.notched(
//       title: widget.child,
//       padding: widget.padding,
//       onTap: widget.enabled ? handleTap : null,
//       // leading: widget.value != null ? const Icon(CupertinoIcons.checkmark) : null,
//       // trailing: widget.value != null ? const Icon(CupertinoIcons.chevron_forward) : null,
//     );
//   }
// }
// //
// // ///
// // ///
// // ///
// // ///
// // /// An item in a Material Design popup menu.
// // ///
// // /// To show a popup menu, use the [showMenu] function. To create a button that
// // /// shows a popup menu, consider using [PopupMenuButton].
// // ///
// // /// To show a checkmark next to a popup menu item, consider using
// // /// [CheckedPopupMenuItem].
// // ///
// // /// Typically the [child] of a [PopupMenuItem] is a [Text] widget. More
// // /// elaborate menus with icons can use a [ListTile]. By default, a
// // /// [PopupMenuItem] is [kMinInteractiveDimension] pixels high. If you use a widget
// // /// with a different height, it must be specified in the [height] property.
// // ///
// // /// {@tool snippet}
// // ///
// // /// Here, a [Text] widget is used with a popup menu item. The `Menu` type
// // /// is an enum, not shown here.
// // ///
// // /// ```dart
// // /// const PopupMenuItem<Menu>(
// // ///   value: Menu.itemOne,
// // ///   child: Text('Item 1'),
// // /// )
// // /// ```
// // /// {@end-tool}
// // ///
// // /// See the example at [PopupMenuButton] for how this example could be used in a
// // /// complete menu, and see the example at [CheckedPopupMenuItem] for one way to
// // /// keep the text of [PopupMenuItem]s that use [Text] widgets in their [child]
// // /// slot aligned with the text of [CheckedPopupMenuItem]s or of [PopupMenuItem]
// // /// that use a [ListTile] in their [child] slot.
// // ///
// // /// See also:
// // ///
// // ///  * [PopupMenuDivider], which can be used to divide items from each other.
// // ///  * [CheckedPopupMenuItem], a variant of [PopupMenuItem] with a checkmark.
// // ///  * [showMenu], a method to dynamically show a popup menu at a given location.
// // ///  * [PopupMenuButton], an [IconButton] that automatically shows a menu when
// // ///    it is tapped.
// // class PopupMenuItem<T> extends PopupMenuEntry<T> {
// //   /// Creates an item for a popup menu.
// //   ///
// //   /// By default, the item is [enabled].
// //   const PopupMenuItem({
// //     super.key,
// //     this.value,
// //     this.onTap,
// //     this.enabled = true,
// //     this.height = kMinInteractiveDimension,
// //     this.padding,
// //     this.textStyle,
// //     this.labelTextStyle,
// //     this.mouseCursor,
// //     required this.child,
// //   });
// //
// //   /// The value that will be returned by [showMenu] if this entry is selected.
// //   final T? value;
// //
// //   /// Called when the menu item is tapped.
// //   final VoidCallback? onTap;
// //
// //   /// Whether the user is permitted to select this item.
// //   ///
// //   /// Defaults to true. If this is false, then the item will not react to
// //   /// touches.
// //   final bool enabled;
// //
// //   /// The minimum height of the menu item.
// //   ///
// //   /// Defaults to [kMinInteractiveDimension] pixels.
// //   @override
// //   final double height;
// //
// //   /// The padding of the menu item.
// //   ///
// //   /// The [height] property may interact with the applied padding. For example,
// //   /// If a [height] greater than the height of the sum of the padding and [child]
// //   /// is provided, then the padding's effect will not be visible.
// //   ///
// //   /// If this is null and [ThemeData.useMaterial3] is true, the horizontal padding
// //   /// defaults to 12.0 on both sides.
// //   ///
// //   /// If this is null and [ThemeData.useMaterial3] is false, the horizontal padding
// //   /// defaults to 16.0 on both sides.
// //   final EdgeInsets? padding;
// //
// //   /// The text style of the popup menu item.
// //   ///
// //   /// If this property is null, then [PopupMenuThemeData.textStyle] is used.
// //   /// If [PopupMenuThemeData.textStyle] is also null, then [TextTheme.titleMedium]
// //   /// of [ThemeData.textTheme] is used.
// //   final TextStyle? textStyle;
// //
// //   /// The label style of the popup menu item.
// //   ///
// //   /// When [ThemeData.useMaterial3] is true, this styles the text of the popup menu item.
// //   ///
// //   /// If this property is null, then [PopupMenuThemeData.labelTextStyle] is used.
// //   /// If [PopupMenuThemeData.labelTextStyle] is also null, then [TextTheme.labelLarge]
// //   /// is used with the [ColorScheme.onSurface] color when popup menu item is enabled and
// //   /// the [ColorScheme.onSurface] color with 0.38 opacity when the popup menu item is disabled.
// //   final MaterialStateProperty<TextStyle?>? labelTextStyle;
// //
// //   /// {@template flutter.material.popupmenu.mouseCursor}
// //   /// The cursor for a mouse pointer when it enters or is hovering over the
// //   /// widget.
// //   ///
// //   /// If [mouseCursor] is a [WidgetStateProperty<MouseCursor>],
// //   /// [WidgetStateProperty.resolve] is used for the following [WidgetState]s:
// //   ///
// //   ///  * [WidgetState.hovered].
// //   ///  * [WidgetState.focused].
// //   ///  * [WidgetState.disabled].
// //   /// {@endtemplate}
// //   ///
// //   /// If null, then the value of [PopupMenuThemeData.mouseCursor] is used. If
// //   /// that is also null, then [WidgetStateMouseCursor.clickable] is used.
// //   final MouseCursor? mouseCursor;
// //
// //   /// The widget below this widget in the tree.
// //   ///
// //   /// Typically a single-line [ListTile] (for menus with icons) or a [Text]. An
// //   /// appropriate [DefaultTextStyle] is put in scope for the child. In either
// //   /// case, the text should be short enough that it won't wrap.
// //   final Widget? child;
// //
// //   @override
// //   bool represents(T? value) => value == this.value;
// //
// //   @override
// //   PopupMenuItemState<T, PopupMenuItem<T>> createState() => PopupMenuItemState<T, PopupMenuItem<T>>();
// // }
// //
// // /// The [State] for [PopupMenuItem] subclasses.
// // ///
// // /// By default this implements the basic styling and layout of Material Design
// // /// popup menu items.
// // ///
// // /// The [buildChild] method can be overridden to adjust exactly what gets placed
// // /// in the menu. By default it returns [PopupMenuItem.child].
// // ///
// // /// The [handleTap] method can be overridden to adjust exactly what happens when
// // /// the item is tapped. By default, it uses [Navigator.pop] to return the
// // /// [PopupMenuItem.value] from the menu route.
// // ///
// // /// This class takes two type arguments. The second, `W`, is the exact type of
// // /// the [Widget] that is using this [State]. It must be a subclass of
// // /// [PopupMenuItem]. The first, `T`, must match the type argument of that widget
// // /// class, and is the type of values returned from this menu.
// // class PopupMenuItemState<T, W extends PopupMenuItem<T>> extends State<W> {
// //   /// The menu item contents.
// //   ///
// //   /// Used by the [build] method.
// //   ///
// //   /// By default, this returns [PopupMenuItem.child]. Override this to put
// //   /// something else in the menu entry.
// //   @protected
// //   Widget? buildChild() => widget.child;
// //
// //   /// The handler for when the user selects the menu item.
// //   ///
// //   /// Used by the [InkWell] inserted by the [build] method.
// //   ///
// //   /// By default, uses [Navigator.pop] to return the [PopupMenuItem.value] from
// //   /// the menu route.
// //   @protected
// //   void handleTap() {
// //     // Need to pop the navigator first in case onTap may push new route onto navigator.
// //     Navigator.pop<T>(context, widget.value);
// //
// //     widget.onTap?.call();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final ThemeData theme = Theme.of(context);
// //     final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
// //     final PopupMenuThemeData defaults = theme.useMaterial3 ? _PopupMenuDefaultsM3(context) : _PopupMenuDefaultsM2(context);
// //     final Set<MaterialState> states = <MaterialState>{
// //       if (!widget.enabled) MaterialState.disabled,
// //     };
// //
// //     TextStyle style = theme.useMaterial3
// //         ? (widget.labelTextStyle?.resolve(states)
// //         ?? popupMenuTheme.labelTextStyle?.resolve(states)!
// //         ?? defaults.labelTextStyle!.resolve(states)!)
// //         : (widget.textStyle
// //         ?? popupMenuTheme.textStyle
// //         ?? defaults.textStyle!);
// //
// //     if (!widget.enabled && !theme.useMaterial3) {
// //       style = style.copyWith(color: theme.disabledColor);
// //     }
// //     final EdgeInsetsGeometry padding = widget.padding
// //         ?? (theme.useMaterial3 ? _PopupMenuDefaultsM3.menuItemPadding : _PopupMenuDefaultsM2.menuItemPadding);
// //
// //     Widget item = AnimatedDefaultTextStyle(
// //       style: style,
// //       duration: kThemeChangeDuration,
// //       child: ConstrainedBox(
// //         constraints: BoxConstraints(minHeight: widget.height),
// //         child: Padding(
// //           key: const Key('menu item padding'),
// //           padding: padding,
// //           child: Align(
// //             alignment: AlignmentDirectional.centerStart,
// //             child: buildChild(),
// //           ),
// //         ),
// //       ),
// //     );
// //
// //     if (!widget.enabled) {
// //       final bool isDark = theme.brightness == Brightness.dark;
// //       item = IconTheme.merge(
// //         data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
// //         child: item,
// //       );
// //     }
// //
// //     return MergeSemantics(
// //       child: Semantics(
// //         enabled: widget.enabled,
// //         button: true,
// //         child: InkWell(
// //           onTap: widget.enabled ? handleTap : null,
// //           canRequestFocus: widget.enabled,
// //           mouseCursor: _EffectiveMouseCursor(widget.mouseCursor, popupMenuTheme.mouseCursor),
// //           child: ListTileTheme.merge(
// //             contentPadding: EdgeInsets.zero,
// //             titleTextStyle: style,
// //             child: item,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

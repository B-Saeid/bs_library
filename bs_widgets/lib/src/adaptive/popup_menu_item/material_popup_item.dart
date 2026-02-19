// import 'dart:ui';
//
// import 'package:bs_styles/bs_styles.dart';
// import 'package:flutter/material.dart';
//
// /// An item in a Material Design popup menu.
// ///
// /// To show a popup menu, use the [showMenu] function. To create a button that
// /// shows a popup menu, consider using [PopupMenuButton].
// ///
// /// To show a checkmark next to a popup menu item, consider using
// /// [CheckedMaterialPopupMenuItem].
// ///
// /// Typically the [child] of a [MaterialPopupMenuItem] is a [Text] widget. More
// /// elaborate menus with icons can use a [ListTile]. By default, a
// /// [MaterialPopupMenuItem] is [kMinInteractiveDimension] pixels high. If you use a widget
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
// /// complete menu, and see the example at [CheckedMaterialPopupMenuItem] for one way to
// /// keep the text of [MaterialPopupMenuItem]s that use [Text] widgets in their [child]
// /// slot aligned with the text of [CheckedMaterialPopupMenuItem]s or of [MaterialPopupMenuItem]
// /// that use a [ListTile] in their [child] slot.
// ///
// /// See also:
// ///
// ///  * [PopupMenuDivider], which can be used to divide items from each other.
// ///  * [CheckedMaterialPopupMenuItem], a variant of [MaterialPopupMenuItem] with a checkmark.
// ///  * [showMenu], a method to dynamically show a popup menu at a given location.
// ///  * [PopupMenuButton], an [IconButton] that automatically shows a menu when
// ///    it is tapped.
//
// class MaterialPopupMenuItem<T> extends PopupMenuEntry<T> {
//   /// Creates an item for a popup menu.
//   ///
//   /// By default, the item is [enabled].
//   const MaterialPopupMenuItem({
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
//   MaterialPopupMenuItemState<T, MaterialPopupMenuItem<T>> createState() =>
//       MaterialPopupMenuItemState<T, MaterialPopupMenuItem<T>>();
// }
//
// /// The [State] for [MaterialPopupMenuItem] subclasses.
// ///
// /// By default this implements the basic styling and layout of Material Design
// /// popup menu items.
// ///
// /// The [buildChild] method can be overridden to adjust exactly what gets placed
// /// in the menu. By default it returns [MaterialPopupMenuItem.child].
// ///
// /// The [handleTap] method can be overridden to adjust exactly what happens when
// /// the item is tapped. By default, it uses [Navigator.pop] to return the
// /// [MaterialPopupMenuItem.value] from the menu route.
// ///
// /// This class takes two type arguments. The second, `W`, is the exact type of
// /// the [Widget] that is using this [State]. It must be a subclass of
// /// [MaterialPopupMenuItem]. The first, `T`, must match the type argument of that widget
// /// class, and is the type of values returned from this menu.
// class MaterialPopupMenuItemState<T, W extends MaterialPopupMenuItem<T>> extends State<W> {
//   /// The menu item contents.
//   ///
//   /// Used by the [build] method.
//   ///
//   /// By default, this returns [MaterialPopupMenuItem.child]. Override this to put
//   /// something else in the menu entry.
//   @protected
//   Widget? buildChild() => widget.child;
//
//   /// The handler for when the user selects the menu item.
//   ///
//   /// Used by the [InkWell] inserted by the [build] method.
//   ///
//   /// By default, uses [Navigator.pop] to return the [MaterialPopupMenuItem.value] from
//   /// the menu route.
//   @protected
//   void handleTap() {
//     /// Need to pop the navigator first in case onTap may push new route onto navigator.
//     Navigator.pop<T>(context, widget.value);
//
//     widget.onTap?.call();
//   }
//
//   @protected
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final popupMenuTheme = PopupMenuTheme.of(context);
//     final defaults = theme.useMaterial3
//         ? _PopupMenuDefaultsM3(context)
//         : _PopupMenuDefaultsM2(context);
//     final states = <WidgetState>{if (!widget.enabled) WidgetState.disabled};
//
//     var style = theme.useMaterial3
//         ? (widget.labelTextStyle?.resolve(states) ??
//               popupMenuTheme.labelTextStyle?.resolve(states)! ??
//               defaults.labelTextStyle!.resolve(states)!)
//         : (widget.textStyle ?? popupMenuTheme.textStyle ?? defaults.textStyle!);
//
//     if (!widget.enabled && !theme.useMaterial3) {
//       style = style.copyWith(color: theme.disabledColor);
//     }
//     final EdgeInsetsGeometry padding =
//         widget.padding ??
//         (theme.useMaterial3
//             ? _PopupMenuDefaultsM3.menuItemPadding
//             : _PopupMenuDefaultsM2.menuItemPadding);
//
//     Widget item = AnimatedDefaultTextStyle(
//       style: style,
//       duration: kThemeChangeDuration,
//       child: ConstrainedBox(
//         constraints: BoxConstraints(minHeight: widget.height),
//         child: Padding(
//           padding: padding,
//           child: Align(alignment: AlignmentDirectional.centerStart, child: buildChild()),
//         ),
//       ),
//     );
//
//     if (!widget.enabled) {
//       final isDark = theme.brightness == Brightness.dark;
//       item = IconTheme.merge(
//         data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
//         child: item,
//       );
//     }
//
//     return MergeSemantics(
//       child: buildSemantics(
//         child: InkWell(
//           onTap: widget.enabled ? handleTap : null,
//           canRequestFocus: widget.enabled,
//           mouseCursor: _EffectiveMouseCursor(widget.mouseCursor, popupMenuTheme.mouseCursor),
//           child: ListTileTheme.merge(
//             contentPadding: EdgeInsets.zero,
//             titleTextStyle: style,
//             child: item,
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Builds the semantic wrapper for the popup menu item.
//   ///
//   /// This method creates the [Semantics] widget that provides accessibility
//   /// information for the menu item. By default, it sets the semantic role to
//   /// [SemanticsRole.menuItem] and includes the enabled state and button flag.
//   ///
//   /// Subclasses can override this method to customize the semantic properties.
//   /// For example, [CheckedMaterialPopupMenuItem] overrides this to use
//   /// [SemanticsRole.menuItemCheckbox] and include checked state information.
//   @protected
//   Widget buildSemantics({required Widget child}) {
//     return Semantics(
//       role: SemanticsRole.menuItem,
//       enabled: widget.enabled,
//       button: true,
//       child: child,
//     );
//   }
// }
//
// /// An item with a checkmark in a Material Design popup menu.
// ///
// /// To show a popup menu, use the [showMenu] function. To create a button that
// /// shows a popup menu, consider using [PopupMenuButton].
// ///
// /// A [CheckedMaterialPopupMenuItem] is kMinInteractiveDimension pixels high, which
// /// matches the default minimum height of a [PopupMenuItem]. The horizontal
// /// layout uses [ListTile]; the checkmark is an [Icons.done] icon, shown in the
// /// [ListTile.leading] position.
// ///
// /// {@tool snippet}
// ///
// /// Suppose a `Commands` enum exists that lists the possible commands from a
// /// particular popup menu, including `Commands.heroAndScholar` and
// /// `Commands.hurricaneCame`, and further suppose that there is a
// /// `_heroAndScholar` member field which is a boolean. The example below shows a
// /// menu with one menu item with a checkmark that can toggle the boolean, and
// /// one menu item without a checkmark for selecting the second option. (It also
// /// shows a divider placed between the two menu items.)
// ///
// /// ```dart
// /// PopupMenuButton<Commands>(
// ///   onSelected: (Commands result) {
// ///     switch (result) {
// ///       case Commands.heroAndScholar:
// ///         setState(() { _heroAndScholar = !_heroAndScholar; });
// ///       case Commands.hurricaneCame:
// ///         /// ...handle hurricane option
// ///         break;
// ///       /// ...other items handled here
// ///     }
// ///   },
// ///   itemBuilder: (BuildContext context) => <PopupMenuEntry<Commands>>[
// ///     CheckedPopupMenuItem<Commands>(
// ///       checked: _heroAndScholar,
// ///       value: Commands.heroAndScholar,
// ///       child: const Text('Hero and scholar'),
// ///     ),
// ///     const PopupMenuDivider(),
// ///     const PopupMenuItem<Commands>(
// ///       value: Commands.hurricaneCame,
// ///       child: ListTile(leading: Icon(null), title: Text('Bring hurricane')),
// ///     ),
// ///     /// ...other items listed here
// ///   ],
// /// )
// /// ```
// /// {@end-tool}
// ///
// /// In particular, observe how the second menu item uses a [ListTile] with a
// /// blank [Icon] in the [ListTile.leading] position to get the same alignment as
// /// the item with the checkmark.
// ///
// /// See also:
// ///
// ///  * [PopupMenuItem], a popup menu entry for picking a command (as opposed to
// ///    toggling a value).
// ///  * [PopupMenuDivider], a popup menu entry that is just a horizontal line.
// ///  * [showMenu], a method to dynamically show a popup menu at a given location.
// ///  * [PopupMenuButton], an [IconButton] that automatically shows a menu when
// ///    it is tapped.
// class CheckedMaterialPopupMenuItem<T> extends MaterialPopupMenuItem<T> {
//   /// Creates a popup menu item with a checkmark.
//   ///
//   /// By default, the menu item is [enabled] but unchecked. To mark the item as
//   /// checked, set [checked] to true.
//   const CheckedMaterialPopupMenuItem({
//     super.key,
//     super.value,
//     this.checked = false,
//     super.enabled,
//     super.padding,
//     super.height,
//     super.labelTextStyle,
//     super.mouseCursor,
//     super.child,
//     super.onTap,
//   });
//
//   /// Whether to display a checkmark next to the menu item.
//   ///
//   /// Defaults to false.
//   ///
//   /// When true, an [Icons.done] checkmark is displayed.
//   ///
//   /// When this popup menu item is selected, the checkmark will fade in or out
//   /// as appropriate to represent the implied new state.
//   final bool checked;
//
//   /// The widget below this widget in the tree.
//   ///
//   /// Typically a [Text]. An appropriate [DefaultTextStyle] is put in scope for
//   /// the child. The text should be short enough that it won't wrap.
//   ///
//   /// This widget is placed in the [ListTile.title] slot of a [ListTile] whose
//   /// [ListTile.leading] slot is an [Icons.done] icon.
//   @override
//   /// ignore: unnecessary_overrides
//   Widget? get child => super.child;
//
//   @override
//   MaterialPopupMenuItemState<T, CheckedMaterialPopupMenuItem<T>> createState() =>
//       _CheckedMaterialPopupMenuItemState<T>();
// }
//
// class _CheckedMaterialPopupMenuItemState<T>
//     extends MaterialPopupMenuItemState<T, CheckedMaterialPopupMenuItem<T>>
//     with SingleTickerProviderStateMixin {
//   static const Duration _fadeDuration = Duration(milliseconds: 150);
//   late AnimationController _controller;
//
//   Animation<double> get _opacity => _controller.view;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(duration: _fadeDuration, vsync: this)
//       ..value = widget.checked ? 1.0 : 0.0
//       ..addListener(
//         () => setState(() {
//           /* animation changed */
//         }),
//       );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   void handleTap() {
//     /// This fades the checkmark in or out when tapped.
//     if (widget.checked) {
//       _controller.reverse();
//     } else {
//       _controller.forward();
//     }
//     super.handleTap();
//   }
//
//   @override
//   Widget buildSemantics({required Widget child}) {
//     return Semantics(
//       role: SemanticsRole.menuItemCheckbox,
//       enabled: widget.enabled,
//       checked: widget.checked,
//       button: true,
//       child: child,
//     );
//   }
//
//   @override
//   Widget buildChild() {
//     final theme = Theme.of(context);
//     final popupMenuTheme = PopupMenuTheme.of(context);
//     final defaults = theme.useMaterial3
//         ? _PopupMenuDefaultsM3(context)
//         : _PopupMenuDefaultsM2(context);
//     final states = <WidgetState>{if (widget.checked) WidgetState.selected};
//     final effectiveLabelTextStyle =
//         widget.labelTextStyle ?? popupMenuTheme.labelTextStyle ?? defaults.labelTextStyle;
//     return IgnorePointer(
//       child: ListTileTheme.merge(
//         contentPadding: EdgeInsets.zero,
//         child: ListTile(
//           enabled: widget.enabled,
//           titleTextStyle: effectiveLabelTextStyle?.resolve(states),
//           leading: FadeTransition(
//             opacity: _opacity,
//             child: Icon(_controller.isDismissed ? null : Icons.done),
//           ),
//           title: widget.child,
//         ),
//       ),
//     );
//   }
// }
//
// class _EffectiveMouseCursor extends WidgetStateMouseCursor {
//   const _EffectiveMouseCursor(this.widgetCursor, this.themeCursor);
//
//   final MouseCursor? widgetCursor;
//   final WidgetStateProperty<MouseCursor?>? themeCursor;
//
//   @override
//   MouseCursor resolve(Set<WidgetState> states) {
//     return WidgetStateProperty.resolveAs<MouseCursor?>(widgetCursor, states) ??
//         themeCursor?.resolve(states) ??
//         WidgetStateMouseCursor.clickable.resolve(states);
//   }
//
//   @override
//   String get debugDescription => 'WidgetStateMouseCursor(PopupMenuItemState)';
// }
//
// class _PopupMenuDefaultsM2 extends PopupMenuThemeData {
//   _PopupMenuDefaultsM2(this.context) : super(elevation: 8.0);
//
//   final BuildContext context;
//   late final ThemeData _theme = Theme.of(context);
//   late final TextTheme _textTheme = _theme.textTheme;
//
//   @override
//   TextStyle? get textStyle => _textTheme.titleMedium;
//
//   @override
//   EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 8.0);
//
//   static EdgeInsets menuItemPadding = const EdgeInsets.symmetric(horizontal: 16.0);
// }
//
// /// BEGIN GENERATED TOKEN PROPERTIES - PopupMenu
//
// /// Do not edit by hand. The code between the "BEGIN GENERATED" and
// /// "END GENERATED" comments are generated from data in the Material
// /// Design token database by the script:
// ///   dev/tools/gen_defaults/bin/gen_defaults.dart.
//
// /// dart format off
// class _PopupMenuDefaultsM3 extends PopupMenuThemeData {
//   _PopupMenuDefaultsM3(this.context) : super(elevation: 3.0);
//
//   final BuildContext context;
//   late final ThemeData _theme = Theme.of(context);
//   late final ColorScheme _colors = _theme.colorScheme;
//   late final TextTheme _textTheme = _theme.textTheme;
//
//   @override
//   WidgetStateProperty<TextStyle?>? get labelTextStyle {
//     return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
//       /// TODO(quncheng): Update this hard-coded value to use the latest tokens.
//       final style = _textTheme.labelLarge!;
//       if (states.contains(WidgetState.disabled)) {
//         return style.apply(color: _colors.onSurface.withAlphaFraction(0.38));
//       }
//       return style.apply(color: _colors.onSurface);
//     });
//   }
//
//   @override
//   Color? get color => _colors.surfaceContainer;
//
//   @override
//   Color? get shadowColor => _colors.shadow;
//
//   @override
//   Color? get surfaceTintColor => Colors.transparent;
//
//   @override
//   ShapeBorder? get shape =>
//       const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));
//
//   /// TODO(bleroux): This is taken from https:///m3.material.io/components/menus/specs
//   /// Update this when the token is available.
//   @override
//   EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 8.0);
//
//   /// TODO(tahatesser): This is taken from https:///m3.material.io/components/menus/specs
//   /// Update this when the token is available.
//   static EdgeInsets menuItemPadding = const EdgeInsets.symmetric(horizontal: 12.0);
// }
//
// /// dart format on
//
// /// END GENERATED TOKEN PROPERTIES - PopupMenu

import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';

import 'dimmer_wrapper.dart';
import 'enums.dart';
import 'logic.dart';

typedef CloseOverlayCallback = void Function({BuildContext? context, bool manualDismiss});

abstract final class BsOverlay {
  /// Removes currently shown overlay and clears the other enqueued overlays
  /// ###### Note: This only applies to overlays shown with [showTimed] NOT [show]
  static void clearAllEnqueuedOverlays() => BsOverlayLogic.clearAllEnqueuedOverlays();

  /// If you need to be able to show overlays without passing
  /// the context you have to call this setter before doing so.
  ///
  /// Note: This `navigatorKey` is not a hack it is genuinely used
  /// by flutter to monitor the navigator stack, navigation notifications, etc.
  /// The benefit of it is that it holds the current active BuildContext within.
  ///
  /// See this: [https://medium.com/@moeinmoradi.dev/navigatorkey-in-flutter-ecbb81b8ad34]
  ///
  /// Using GoRouter! Simply use it like this: [https://stackoverflow.com/a/77241743]
  ///
  /// Ex:
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   static final navigatorKey = GlobalKey<NavigatorState>();
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       ...
  ///       navigatorKey: navigatorKey, // Attach it to your root widget
  ///       builder: (context, child) {
  ///         BSOverlay.setNavigatorKey(navigatorKey); // Now you can omit context
  ///         return child!;
  ///       },
  ///       home: const MyHomePage(title: 'Flutter Demo Home Page'),
  ///       ...
  ///     );
  ///   }
  /// }
  /// ```
  ///
  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) =>
      BsOverlayLogic.setNavigatorKey(navigatorKey);

  /// {@template contextAndNavigatorKey}
  /// If you call this function without passing the context
  /// it will assume that you have already set the navigator key
  /// by calling [BsOverlay.setNavigatorKey]. Otherwise it will throw an error.
  ///
  /// Note: If you pass in [context], it will will use the nearest overlay to this context instead
  /// of the [navigatorKey]'s overlay.
  /// {@endtemplate}
  ///
  /// {@template parameters}
  /// ##### Parameters
  /// - [content] is centered inside a dimmed container,
  ///   if not omitted It can only be `String` or `Widget`.
  /// - [child] is passed as it is, Cannot be used with [content].
  /// - [dismissOnTap] dismiss when tap on the overlay NOT the area around it.
  /// - [barrierDismissible] dismiss when tap on the area around the overlay
  ///   **or when ESC is pressed on the keyboard**.
  /// - [dismissOnBack] dismiss when back button is pressed
  ///   This shall work with devices with back button e.g. Android.
  /// - [gravity] controls the positioning of the overlay, If it does not take the entire space.
  /// - [id] is a way to identify a toast being shown, useful for [priority]s like
  ///   [BsPriority.nowNoRepeat] and [BsPriority.noRepeat], if omitted the hashcode
  ///   of the passed widget will be used either [child] or [content].
  /// - [onDismiss] is a callback parameter that can be set to clear resources on end,
  ///   It has a `bool` passed in that indicated if the user manually dismissed the overlay.
  /// - [barrier] is a flag that sets a barrier between the overlay and the layers below it
  ///   By default it is `true`, but [Toast] for example sets it false to explicitly allow
  ///   hit testing in other areas of the screen around the toast.
  /// - [barrierDismissible] when set to true, tapping outside the overlay dismisses it
  ///   Also **when ESC is pressed on the keyboard**. Must not be used without [barrier].
  /// - [ignorePointer] to totally prevent interactions WITHIN your [child] or [content],
  ///   this does NOT affect the area around your [child] or [content] EXCEPT if it covers
  ///   the entire screen. Also note that if [dismissOnTap] is true this will be ignored.
  /// - [showCloseIcon] Shows an [AdaptiveIconButton] with close icon to manually dismiss
  ///   your overlay. **NOTE:** It doesn't work with `child` since it is passed as is.
  /// {@endtemplate}
  /// - [priority] is a way to control the urgency of the overlay,
  ///   e.g. [BsPriority.now] will cancel any current overlay and show itself instead,
  ///   [BsPriority.nowNoRepeat] will do the same except that it will NOT cancel itself
  ///   nor repeat until the set [duration] is up or it is dismissed.
  /// - [duration] is the time to hold the overlay visible,
  ///   a fadeDuration of [CoreWidget.fadeDurations] is implicitly added to [duration].
  ///
  ///
  /// {@template dialogs_note}
  /// ###### Note: When you pass `BsDialogue` or other `AlertDialog`s to [child]:
  /// [barrierDismissible] and [gravity] don't work seamlessly in this case,
  /// because `AlertDialog` internally uses `Align` to center the dialogue content
  /// which takes up *almost* the entire screen, the thing that makes the
  /// `GestureDetector` behind unreachable. So you should avoid this combination.
  ///
  /// If you want a workaround without editing
  /// the dialog source code you can set `dismissOnTap` to `true` but
  /// be aware that not only the surroundings but also the dialogue content
  /// will close the overlay when it is tapped **except for** action buttons
  /// or other gesture receiving widget.
  ///
  /// {@endtemplate}
  ///
  /// ###### Returns a [VoidCallback] that will dismiss the overlay when called.
  static VoidCallback showTimed({
    int? id,
    BuildContext? context,
    Object? content,
    Widget? child,
    BsGravity? gravity,
    BsPriority priority = BsPriority.nowNoRepeat,
    Duration duration = const Duration(seconds: 2),
    bool ignorePointer = false,
    bool dismissOnTap = false,
    ValueSetter<bool>? onDismiss,
    bool showCloseIcon = false,
    bool dismissOnBack = false,
    bool barrierDismissible = false,
    bool barrier = true,
  }) {
    _commonAssertions(
      child,
      content,
      barrier,
      barrierDismissible,
      showCloseIcon,
      ignorePointer,
      dismissOnTap,
    );

    final uuid = const UuidV4().generate();
    BsOverlayLogic.showOverlay(
      id: id ?? child?.hashCode ?? content!.hashCode,
      uuid: uuid,
      context: context,
      child:
          child ??
          DimmedWrapper(
            content!,
            showCloseIcon: showCloseIcon,
            barrierDismissible: barrierDismissible,
            dismissOnTap: dismissOnTap,
            ignorePointer: ignorePointer,
          ),
      gravity: gravity,
      priority: priority,
      duration: duration,
      ignorePointer: child == null ? false : ignorePointer,

      /// This is to prevent multiple handling when dismissOnTap is true
      /// we check if [child == null] then _DimmedWrapper has handled it
      /// so we don't want to handle it again in _CoreWidget therefore
      /// we set dismissOnTap to false otherwise we pass its value as it is
      dismissOnTap: child == null ? false : dismissOnTap,
      onDismiss: onDismiss,
      dismissOnBack: dismissOnBack,
      barrierDismissible: child == null ? false : barrierDismissible,
      barrier: barrier,
    );

    return () => BsOverlayLogic.resetAndGoToNext(
      context: context,
      manualDismiss: true,
      uuid: uuid,
    );
  }

  /// {@macro contextAndNavigatorKey}
  ///
  /// This method is used to show overlay without automatic dismiss
  /// you are to handle the dismissal by any of these ways:
  /// - calling the returned `VoidCallback`.
  /// - pass [showCloseIcon] with `true` in order to show a close button.
  /// - pass [dismissOnTap] with `true` in order to dismiss when `content` or `child` is tapped.
  /// - pass [barrierDismissible] with `true` in order to dismiss when
  ///   tapped outside the overlay or **when ESC is pressed on the keyboard**.
  /// - pass [dismissOnBack] with true in order to dismiss when
  ///   back button is pressed. This shall work with devices with back button
  ///   e.g. Android.
  ///
  /// {@macro parameters}
  /// {@macro dialogs_note}
  ///
  /// ###### Returns a [VoidCallback] that will dismiss the overlay when called.
  static VoidCallback show({
    int? id,
    BuildContext? context,
    Object? content,
    Widget? child,
    BsGravity? gravity,
    bool avoidKeyboard = false,
    bool ignorePointer = false,
    bool dismissOnTap = false,
    ValueSetter<bool>? onDismiss,
    bool showCloseIcon = false,
    bool dismissOnBack = false,
    bool barrierDismissible = false,
    bool barrier = true,
  }) {
    _commonAssertions(
      child,
      content,
      barrier,
      barrierDismissible,
      showCloseIcon,
      ignorePointer,
      dismissOnTap,
    );
    assert(
      avoidKeyboard ? gravity == null : true,
      'avoidKeyboard cannot be set to true while passing gravity'
      'If you want to avoid keyboard pass gravity with BsGravity.bottomSafe',
    );
    final uuid = const UuidV4().generate();
    BsOverlayLogic.showOverlay(
      id: id ?? child?.hashCode ?? content!.hashCode,
      uuid: uuid,
      context: context,
      child:
          child ??
          DimmedWrapper(
            content!,
            showCloseIcon: showCloseIcon,
            barrierDismissible: barrierDismissible,
            dismissOnTap: dismissOnTap,
            ignorePointer: ignorePointer,
            isOverall: true,
          ),
      gravity: gravity,
      priority: BsPriority.overall,
      ignorePointer: child == null ? false : ignorePointer,
      dismissOnTap: child == null ? false : dismissOnTap,
      onDismiss: onDismiss,
      dismissOnBack: dismissOnBack,
      barrierDismissible: child == null ? false : barrierDismissible,
      barrier: barrier,
      avoidKeyboard: avoidKeyboard,
    );

    return () => BsOverlayLogic.removeOverallEntry(uuid);
  }

  static void _commonAssertions(
    Widget? child,
    Object? content,
    bool barrier,
    bool barrierDismissible,
    bool showCloseIcon,
    bool ignorePointer,
    bool dismissOnTap,
  ) {
    assert(
      (child != null) ^ (content != null),
      'Only one of child and content must be passed, '
      '${child == null && child == null ? 'Neither was passed' : 'NOT BOTH'}.',
    );
    assert(
      content == null || content is String || content is Widget,
      'Content must be String or Widget',
    );
    assert(
      !showCloseIcon || child == null,
      'showCloseIcon does not work when child is used. Instead use content to show it',
    );
    assert(
      child != null || barrier,
      'You can\'t have no barrier while using content',
    );
    assert(
      barrierDismissible ? barrier : true,
      // !barrierDismissible || barrier, // Same but above is MORE readable
      'You can\'t have no barrier while using barrierDismissible',
    );
    assert(
      !ignorePointer || !dismissOnTap,
      // !barrierDismissible || barrier, // Same but above is MORE readable
      'You can not set dismissOnTap to true while using ignorePointer.',
    );
  }
}

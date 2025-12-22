import 'package:flutter/material.dart';

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
  /// ##### Parameters
  /// - [content] is centered inside a dimmed container,
  ///   if not omitted It can only be `String` or `Widget`.
  /// - [child] is passed as it is, Cannot be used with [content].
  /// - [dismissOnTap] dismiss when tap on the overlay NOT the area around it.
  /// - [barrierDismissible] dismiss when tap on the area around the overlay
  ///   **or when ESC is pressed on the keyboard**.
  /// - [dismissOnBack] dismiss when back button is pressed
  ///   This shall work with devices with back button e.g. Android.
  /// - [priority] is a way to control the urgency of the overlay,
  ///   e.g. [BsPriority.now] will cancel any current overlay and show itself instead,
  ///   [BsPriority.nowNoRepeat] will do the same except that it will NOT cancel itself
  ///   nor repeat until the set [duration] is up or it is dismissed.
  /// - [gravity] controls the positioning of the overlay, If it does not take the entire space.
  /// - [id] is a way to indentify a toast being shown, useful for [priority]s like
  ///   [BsPriority.nowNoRepeat] and [BsPriority.noRepeat], if omitted the hashcode
  ///   of the passed widget will be used either [child] or [content].
  /// - [duration] is the time to hold the overlay visible,
  ///   a fadeDuration of [CoreWidget.fadeDurations] is implicitly added to [duration].
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
  ///   your overlay.
  ///
  /// {@template dialogs_note}
  /// ##### Note: `barrierDismissible` does not work with [BsDialogue] or other [AlertDialog]s when passed to child.
  /// Because they internally uses `Align` to center the dialogue content
  /// which takes up almost the entire screen making the gesture detector
  /// behind unreachable. If you want a workaround without editing
  /// the dialog source code you can set `dismissOnTap` to true but
  /// be aware not only the surroundings but also the dialogue content
  /// -except for the action buttons and any other gesture receiving widget-
  /// will close when any of them are tapped.
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
    assert(
      (content != null) ^ (child != null),
      'Only one of content and child must be passed, '
      '${content == null && content == null ? 'Neither was passed' : 'NOT BOTH'}.',
    );
    assert(
      content == null || content is String || content is Widget,
      'Content must be String or Widget',
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

    BsOverlayLogic.showOverlay(
      context: context,
      child:
          child ??
          DimmedWrapper(
            content!,
            showCloseIcon: showCloseIcon,
            barrierDismissible: barrierDismissible,
            dismissOnTap: dismissOnTap,
          ),
      gravity: gravity,
      id: id ?? child?.hashCode ?? content!.hashCode,
      duration: duration,
      priority: priority,
      ignorePointer: ignorePointer,

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
    return () => BsOverlayLogic.resetAndGoToNext(context: context, manualDismiss: true);
  }

  /// {@macro contextAndNavigatorKey}
  ///
  /// This method is used to show overlay without automatic dismiss
  /// you are to handle the dismiss manually by any of these ways:
  /// - calling the returned VoidCallback.
  /// - pass [showCloseIcon] with true in order to show a close button.
  /// - pass [dismissOnTap] with true in order to dismiss when
  ///   tap on the overlay.
  /// - pass [barrierDismissible] with true in order to dismiss when
  ///   tap outside the overlay or **when ESC is pressed on the keyboard**.
  /// - pass [dismissOnBack] with true in order to dismiss when
  ///   back button is pressed This shall work with devices with back button
  ///   e.g. Android.
  ///
  /// {@macro dialogs_note}
  ///
  /// ##### Parameters
  /// - [content] is centered inside a dimmed container,
  ///   if not omitted It can only be `String` or `Widget`.
  /// - [child] is passed as it is, Cannot be used with [content].
  /// - [dismissOnTap] dismiss when tap on the overlay NOT the area around it.
  /// - [barrierDismissible] dismiss when tap on the area around the overlay
  ///   **or when ESC is pressed on the keyboard**.
  /// - [dismissOnBack] dismiss when back button is pressed
  ///   This shall work with devices with back button e.g. Android.
  /// - [priority] is a way to control the urgency of the overlay,
  ///   e.g. [BsPriority.now] will cancel any current overlay and show itself instead,
  ///   [BsPriority.nowNoRepeat] will do the same except that it will NOT cancel itself
  ///   nor repeat until it the set [duration] is up or it is dismissed.
  /// - [gravity] controls the positioning of the overlay, If it does not take the entire space.
  /// - [avoidKeyboard] can be used to act as [BsGravity.bottomSafe] but without
  ///   internally wrapping your [child] or [content] with a [Positioned] widget.
  /// - [id] is a way to indentify a toast being shown, useful for [priority]s like
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
  ///   your overlay.
  ///
  /// ###### Returns a [VoidCallback] that will dismiss the overlay when called.
  static VoidCallback show({
    BuildContext? context,
    Object? content,
    Widget? child,
    int? id,
    bool ignorePointer = false,
    bool dismissOnTap = false,
    bool showCloseIcon = false,
    ValueSetter<bool>? onDismiss,
    BsGravity? gravity,
    bool avoidKeyboard = false,
    bool barrierDismissible = false,
    bool dismissOnBack = false,
    bool barrier = true,
  }) {
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
      avoidKeyboard ? gravity == null : true,
      'avoidKeyboard cannot be set to true while passing gravity'
      'If you want to avoid keyboard pass gravity with BsGravity.bottomSafe',
    );
    BsOverlayLogic.showOverlay(
      context: context,
      child:
          child ??
          DimmedWrapper(
            content!,
            showCloseIcon: showCloseIcon,
            barrierDismissible: barrierDismissible,
            dismissOnTap: dismissOnTap,
            isOverall: true,
          ),
      id: id ?? child?.hashCode ?? content!.hashCode,
      priority: BsPriority.overall,
      ignorePointer: ignorePointer,
      dismissOnTap: child == null ? false : dismissOnTap,
      onDismiss: onDismiss,
      avoidKeyboard: avoidKeyboard,
      barrierDismissible: child == null ? false : barrierDismissible,
      barrier: barrier,
      gravity: gravity,
      dismissOnBack: dismissOnBack,
    );

    return BsOverlayLogic.removeOverallEntry;
  }
}

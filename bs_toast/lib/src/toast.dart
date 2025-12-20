import 'package:bs_overlay/bs_overlay.dart';
import 'package:flutter/material.dart';

import 'parts/enum.dart';
import 'parts/message_wrapper.dart';

/// TODO: Only export enum when you combine all the packages in one repo/
export 'package:bs_overlay/bs_overlay.dart';

abstract final class Toast {
  /// If you need to be able to show toasts without passing
  /// the context you have to call this setter before doing so.
  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) =>
      BsOverlay.setNavigatorKey(navigatorKey);

  static VoidCallback? _show({
    required Object message,
    required BuildContext? context,
    required Duration? duration,
    required BsGravity gravity,
    required ToastState toastState,
    required Color? color,
    required bool dismissOnTap,
    required ValueSetter<bool>? onDismiss,
    required BsPriority? priority,
  }) {
    try {
      return duration == null || priority == null
          ? BsOverlay.show(
              id: message.hashCode,
              context: context,
              child: MessageWrapper(
                toastState: toastState,
                message: message,
                color: color,
              ),
              gravity: gravity,
              avoidKeyboard: false, // gravity takes control
              dismissOnTap: dismissOnTap,
              onDismiss: onDismiss,

              /// to explicitly allow hit testing in other areas of the screen
              barrier: false,
            )
          : BsOverlay.showTimed(
              id: message.hashCode,
              context: context,
              child: MessageWrapper(
                toastState: toastState,
                message: message,
                color: color,
              ),
              duration: duration,
              gravity: gravity,
              dismissOnTap: dismissOnTap,
              onDismiss: onDismiss,
              priority: priority,

              /// to explicitly allow hit testing in other areas of the screen
              barrier: false,
            );
      // }
    } catch (error, stackTrace) {
      print(
        '===== TOAST ^ & & & & ^ ERROR ====== ${error.toString()}\n'
        'With Trace >> : $stackTrace',
      );
      return null;
    }
  }

  /// [showLive] is used to show a lively updating text on the toast
  /// using [ValueNotifier<String>] as the message instead of `String`.
  ///
  /// It's useful when you want to show to the user continuous updates
  /// e.g. Speech Recognition output.
  ///
  /// **NOTE**: This toast will NOT dismiss automatically until
  /// you trigger the returned callback.
  ///
  /// {@template contextAndNavigatorKey}
  /// If you call this function without passing the context
  /// it will assume that you have already set the navigator key
  /// by calling [Toast.setNavigatorKey]. Otherwise it will throw an error.
  ///
  /// Note: This navigatorKey is not a hack it is genuinely used
  /// by flutter to monitor the navigator stack, navigation notifications, etc.
  /// The benefit of it is that it holds the current active BuildContext within.
  ///
  /// See this: [https://medium.com/@moeinmoradi.dev/navigatorkey-in-flutter-ecbb81b8ad34]
  ///
  /// Using GoRouter! Simply use it like this: [https://stackoverflow.com/a/77241743]
  ///
  /// Note: If you pass in [context], it will will use the nearest overlay to this context instead
  /// of the [navigatorKey]'s overlay.
  /// {@endtemplate}
  ///
  /// {@template common_parameters}
  /// ##### Parameters
  /// - [gravity] controls the positioning of the toast.
  /// - [dismissOnTap] dismiss the toast if it is tapped.
  /// - [onDismiss] is a callback parameter that can be set to clear resources on end,
  ///   It has a `bool` passed in that indicated if the user manually dismissed the toast,
  ///   always true for live toasts.
  /// {@endtemplate}
  /// - [toastState] Only controls the color of the toast when color is omitted.
  /// - [color] sets the background color of the toast,
  ///   if omitted it will use the color of the [toastState].
  static VoidCallback? showLive(
    ValueNotifier<String> message, {
    BuildContext? context,
    BsGravity gravity = BsGravity.bottomSafe,
    ValueSetter<bool>? onDismiss,
    bool dismissOnTap = false,
    ToastState toastState = ToastState.regular,
    Color? color,
  }) => _show(
    context: context,
    message: message,
    gravity: gravity,
    dismissOnTap: dismissOnTap,
    onDismiss: onDismiss,
    toastState: toastState,
    color: color,
    priority: null,
    duration: null,
  );

  /// {@macro contextAndNavigatorKey}
  /// {@macro common_parameters}
  /// {@template other_parameters}
  /// - [priority] is a way to control the urgency of the toast,
  ///   e.g. [BsPriority.now] will cancel any current toast and show this toast instead,
  ///   [BsPriority.nowNoRepeat] will do the same except that it will NOT cancel itself
  ///   nor repeat until the set [duration] is up or it is dismissed.
  /// - [duration] is the time to hold the toast visible,
  ///   a fadeDuration of approx half a second is implicitly added to [duration].
  /// {@endtemplate}
  /// - [color] sets the background color of the toast,
  ///   if omitted it will use the color [ToastState.regular].
  static void show(
    String message, {
    BuildContext? context,
    BsGravity gravity = BsGravity.bottomSafe,
    bool dismissOnTap = true,
    ValueSetter<bool>? onDismiss,
    Color? color,
    BsPriority priority = BsPriority.nowNoRepeat,
    Duration duration = const Duration(seconds: 2),
  }) => _show(
    context: context,
    message: message,
    gravity: gravity,
    dismissOnTap: dismissOnTap,
    onDismiss: onDismiss,
    toastState: ToastState.regular,
    color: color,
    priority: priority,
    duration: duration,
  );

  /// {@macro contextAndNavigatorKey}
  /// {@macro common_parameters}
  /// {@macro other_parameters}
  /// - [color] sets the background color of the toast,
  ///   if omitted it will use the color [ToastState.warning].
  static void showWarning(
    String message, {
    BuildContext? context,
    BsGravity gravity = BsGravity.bottomSafe,
    bool dismissOnTap = true,
    ValueSetter<bool>? onDismiss,
    Color? color,
    BsPriority priority = BsPriority.now,
    Duration duration = const Duration(seconds: 3),
  }) => _show(
    context: context,
    message: message,
    gravity: gravity,
    dismissOnTap: dismissOnTap,
    onDismiss: onDismiss,
    toastState: ToastState.warning,
    color: color,
    priority: priority,
    duration: duration,
  );

  /// {@macro contextAndNavigatorKey}
  /// {@macro common_parameters}
  /// {@macro other_parameters}
  /// - [color] sets the background color of the toast,
  ///   if omitted it will use the color [ToastState.error].
  static void showError(
    String message, {
    BuildContext? context,
    BsGravity gravity = BsGravity.bottomSafe,
    bool dismissOnTap = true,
    ValueSetter<bool>? onDismiss,
    Color? color,
    BsPriority priority = BsPriority.now,
    Duration duration = const Duration(seconds: 3),
  }) => _show(
    context: context,
    message: message,
    gravity: gravity,
    dismissOnTap: dismissOnTap,
    onDismiss: onDismiss,
    toastState: ToastState.error,
    color: color,
    priority: priority,
    duration: duration,
  );

  /// {@macro contextAndNavigatorKey}
  /// {@macro common_parameters}
  /// {@macro other_parameters}
  static void showSuccess(
    String message, {
    BuildContext? context,
    BsGravity gravity = BsGravity.bottomSafe,
    bool dismissOnTap = true,
    ValueSetter<bool>? onDismiss,
    Color? color,
    BsPriority priority = BsPriority.nowNoRepeat,
    Duration duration = const Duration(seconds: 2),
  }) => _show(
    context: context,
    message: message,
    gravity: gravity,
    dismissOnTap: dismissOnTap,
    onDismiss: onDismiss,
    toastState: ToastState.success,
    color: color,
    priority: priority,
    duration: duration,
  );

  /// Removes current toast and clears all queued toasts.
  static void clearQueue() => BsOverlay.clearAllEnqueuedOverlays();
}

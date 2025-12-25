import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'core_widget.dart';
import 'entry.dart';
import 'enums.dart';

abstract final class BsOverlayLogic {
  static GlobalKey<NavigatorState>? _navigatorKey;

  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) =>
      _navigatorKey = navigatorKey;

  static Entry? current;
  static final List<Entry> _overlayQueue = [];
  static Timer? _timer;
  static Timer? _animationTimer;
  static final Duration _animationDuration = CoreWidget.fadeDurations;

  /// This is added to handle an overlay that is not to be in the queue
  static final List<Entry> topEntries = [];

  static void removeOverallEntry([String? uuid]) {
    final Entry entry;

    /// Internal use - SAFE
    if (uuid == null) {
      entry = topEntries.last;
    }
    /// Developers calling a returned VoidCallback - Unsafe
    else {
      final matchingEntry = topEntries.firstWhereOrNull((entry) => entry.uuid == uuid);
      if (matchingEntry == null) return;
      entry = matchingEntry;
    }

    void harshRemove() {
      entry.onDismiss?.call(true);

      /// This line harshly removes the overlay But It is hidden
      /// with animation above by calling [entry.animatedHide!].
      entry.entry.remove();
      final removed = topEntries.remove(entry);
      print('removed = $removed');
      if (!removed) throw (FlutterError('Failed to remove entry'));
    }

    /// T O D O  : DONE / try to reach hideIt function or something to avoid harsh hiding
    if (entry.animatedHide != null) {
      entry.animatedHide!.call().then((_) => harshRemove());
    } else {
      harshRemove();
    }
  }

  /// If any active overlay present
  /// call [removeAndGoToNext] to hide it immediately
  static void resetAndGoToNext({
    BuildContext? context,
    bool manualDismiss = false,
    String? uuid,
  }) {
    /// Developers calling a returned VoidCallback - Unsafe.
    if (uuid != null) {
      final matchingEntry = _overlayQueue.firstWhereOrNull((entry) => entry.uuid == uuid);
      if (matchingEntry != current || matchingEntry == null) {
        _overlayQueue.remove(matchingEntry);
        return; // Since matchingEntry is not found or not being shown.
      }
    }
    _timer?.cancel();
    _animationTimer?.cancel();
    _timer = null;
    _animationTimer = null;

    void removeCurrentShowNext() {
      current?.onDismiss?.call(manualDismiss);

      /// This line harshly removes the overlay But In Case of normal behaviour - no force removal -
      /// It is hidden with animation in [_ContentWidget] before executing this line.
      current?.entry.remove();
      current = null;
      _showOverlay(context);
    }

    if (manualDismiss) {
      /// T O D O  : DONE / try to reach hideIt function or something to avoid harsh hiding
      if (current?.animatedHide != null) {
        current?.animatedHide?.call().then((_) => removeCurrentShowNext());
        return;
      }
    }

    removeCurrentShowNext();
  }

  static void _showTopOverlay([BuildContext? context]) {
    /// This is THE LINE that actually SHOW the overlay
    if (context != null) {
      Overlay.of(context).insert(topEntries.last.entry);
    } else {
      _navigatorKey!.currentState!.overlay!.insert(topEntries.last.entry);
    }
  }

  /// Internal function which handles the actual showing of contentWidget
  /// by adding the overlay to the screen
  ///
  static void _showOverlay([BuildContext? context]) {
    /// As this method is called recursively from [removeAndGoToNext]
    /// It has to have a way of exiting .. and That is it,
    /// When _overlayQueue is Empty i.e. no more toasts are in the queue
    if (_overlayQueue.isEmpty) return;

    try {
      /// get the first arriving toastEntry in the queue
      final toastEntry = _overlayQueue.removeAt(0);
      current = toastEntry;

      /// This is THE LINE that actually SHOW the overlay
      if (context != null) {
        Overlay.of(context).insert(current!.entry);
      } else {
        _navigatorKey!.currentState!.overlay!.insert(current!.entry);
      }
      // RoutesBase.globalNavigatorKey.currentState!.overlay!
      //     .insert(); // Line of Interest

      /// Here we wait for a couple of periods of time
      ///  I.   the showing duration i.e. [toastEntry.duration]
      ///  II.  the overlay fading durations [_CoreWidget.fadeDurations]
      ///
      /// In case of [toastEntry.duration == null] then no timeout will be applied
      /// the caller ,instead, should handle the dismiss of the overlay
      /// by calling the Function returned by [MyOverlay]'s show methods
      /// which is [_MyOverlay.resetAndGoToNext].
      ///
      if (toastEntry.duration != null) {
        _timer = Timer(
          toastEntry.duration!,
          () => _animationTimer = Timer(
            _animationDuration,

            /// Removes current and go to next in queue If It has any
            () => resetAndGoToNext(context: context),
          ),
        );
      }
    } catch (error, stackTrace) {
      if (_navigatorKey == null && context == null) {
        throw ('You need to call BSOverlay.setNavigatorKey or pass in the context');
      }
      clearAllEnqueuedOverlays();
      print(
        'Error While _showOverlay ${error.toString()} with ${stackTrace.toString()}',
      );
    }
  }

  static void clearAllEnqueuedOverlays() {
    _timer?.cancel();
    _animationTimer?.cancel();
    _timer = null;
    _animationTimer = null;

    /// Call onDismiss for all enqueued entries - Current is not included
    for (var element in _overlayQueue) {
      element.onDismiss?.call(true);
    }
    _overlayQueue.clear();

    /// This will only remove the current entry.
    /// It will not go to next in queue, It is empty.
    if (current != null) resetAndGoToNext(manualDismiss: true);
  }

  static void showOverlay({
    required int id,
    required String uuid,
    BuildContext? context,
    required Widget child,
    BsGravity? gravity,
    BsPriority priority = BsPriority.regular,
    Duration? duration,
    bool ignorePointer = false,
    bool dismissOnTap = false,
    ValueSetter<bool>? onDismiss,
    bool dismissOnBack = false,
    bool barrierDismissible = false,
    bool barrier = true,
    bool avoidKeyboard = false,
  }) {
    /// Building the widget only
    Widget newChild = CoreWidget(
      duration: duration,
      ignorePointer: ignorePointer,
      dismissCallback: dismissOnTap || dismissOnBack || barrierDismissible
          ? priority.isOverall
                ? removeOverallEntry
                : () => resetAndGoToNext(context: context, manualDismiss: true)
          : null,
      dismissOnBack: dismissOnBack,
      dismissOnTap: dismissOnTap,
      avoidKeyboard: avoidKeyboard,
      barrier: barrier,
      barrierDismissible: barrierDismissible,
      overall: priority.isOverall,
      gravity: gravity,
      child: child,
    );

    /// Creating an [OverlayEntry] instance
    final newEntry = OverlayEntry(builder: (_) => newChild);

    /// Embedding the [OverlayEntry] inside a _ToastEntry instance
    final myEntry = Entry(
      id: id,
      uuid: uuid,
      entry: newEntry,
      duration: duration,
      onDismiss: onDismiss,
    );

    /// Adding our _ToastEntry to the serving queue
    switch (priority) {
      case BsPriority.regular:
        _overlayQueue.add(myEntry);
      case BsPriority.ifEmpty:
        if (_timer == null && _overlayQueue.isEmpty) _overlayQueue.add(myEntry);
      case BsPriority.noRepeat:
        if (_overlayQueue.isEmpty) {
          if (current?.id != id) _overlayQueue.add(myEntry);
        } else {
          if (_overlayQueue.last.id != id) _overlayQueue.add(myEntry);
        }
      case BsPriority.nowNoRepeat:
        if (_overlayQueue.isEmpty) {
          if (current?.id != id) {
            _overlayQueue.insert(0, myEntry);
            resetAndGoToNext(context: context);
          }
        } else {
          if (_overlayQueue.last.id != id) {
            _overlayQueue.insert(0, myEntry);
            resetAndGoToNext(context: context);
          }
        }
      case BsPriority.now:
        _overlayQueue.insert(0, myEntry);
        resetAndGoToNext(context: context);
      case BsPriority.replaceAll:
        _overlayQueue.clear();
        _overlayQueue.insert(0, myEntry);
        resetAndGoToNext(context: context);
      case BsPriority.overall:
        topEntries.add(myEntry);
        return _showTopOverlay(context);
    }

    /// This to check if a previous overlay is being shown
    /// If so we do nothing, But Do Not Worry,
    /// when current overlay finishes its timer will call [_showOverlay]
    /// and it will serve the first _ToastEntry in the queue until It is empty.
    /// So we are sure that our overlay will be shown As we add its _ToastEntry to the queue above.
    if (current == null) _showOverlay(context);
  }
}

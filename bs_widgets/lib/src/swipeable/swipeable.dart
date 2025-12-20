import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bs_dismissible.dart';

class Swipeable extends ConsumerWidget {
  /// Creates a widget that can be dismissed.
  ///
  /// The [key] argument is required because [Swipeable]s are commonly used in
  /// lists and removed from the list when dismissed. Without keys, the default
  /// behavior is to sync widgets based on their index in the list, which means
  /// the item after the dismissed item would be synced with the state of the
  /// dismissed item. Using keys causes the widgets to sync according to their
  /// keys and avoids this pitfall.
  const Swipeable.dismiss({
    required Key super.key,
    required this.child,
    this.background,
    this.secondaryBackground,
    this.confirmDismiss,
    this.onResize,
    this.onUpdate,
    this.onDismissed,
    this.direction = DismissDirection.horizontal,
    this.resizeDuration = const Duration(milliseconds: 300),
    this.dismissThresholds = const <DismissDirection, double>{},
    this.movementDuration = const Duration(milliseconds: 200),
    this.movementReverseDuration = const Duration(milliseconds: 500),
    this.crossAxisEndOffset = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.behavior = HitTestBehavior.opaque,
  }) : assert(secondaryBackground == null || background != null),
       actionCallback = null,
       actionThresholds = const <DismissDirection, double>{};

  /// Creates a widget that can be dismissed.
  ///
  /// The [key] argument is required because [Swipeable]s are commonly used in
  /// lists and removed from the list when dismissed. Without keys, the default
  /// behavior is to sync widgets based on their index in the list, which means
  /// the item after the dismissed item would be synced with the state of the
  /// dismissed item. Using keys causes the widgets to sync according to their
  /// keys and avoids this pitfall.
  Swipeable.action({
    required Key super.key,
    required this.child,
    this.background,
    this.secondaryBackground,
    this.onUpdate,
    this.direction = DismissDirection.horizontal,
    this.actionThresholds = const <DismissDirection, double>{},
    this.movementDuration = const Duration(milliseconds: 200),
    this.movementReverseDuration = const Duration(milliseconds: 2000),
    this.crossAxisEndOffset = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.behavior = HitTestBehavior.opaque,
    this.actionCallback,
  }) : assert(secondaryBackground == null || background != null),
       confirmDismiss = null,
       onResize = null,
       onDismissed = null,
       resizeDuration = null,

       /// This is to prevent the item from being dismissed AT ALL
       /// read [dismissThresholds] doc.
       dismissThresholds = actionThresholds.map((key, value) => MapEntry(key, 1.0));

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// A widget that is stacked behind the child. If secondaryBackground is also
  /// specified then this widget only appears when the child has been dragged
  /// down or to the right.
  final Widget? background;

  /// A widget that is stacked behind the child and is exposed when the child
  /// has been dragged up or to the left. It may only be specified when background
  /// has also been specified.
  final Widget? secondaryBackground;

  /// Gives the app an opportunity to confirm or veto a pending dismissal.
  ///
  /// The widget cannot be dragged again until the returned future resolves.
  ///
  /// If the returned `Future<bool>` completes true, then this widget will be
  /// dismissed, otherwise it will be moved back to its original location.
  ///
  /// If the returned `Future<bool?>` completes to false or null the [onResize]
  /// and [onDismissed] callbacks will not run.
  final ConfirmDismissCallback? confirmDismiss;

  /// Called when the widget changes size (i.e., when contracting before being dismissed).
  final VoidCallback? onResize;

  /// Called when the widget has been dismissed, after finishing resizing.
  final DismissDirectionCallback? onDismissed;

  /// The direction in which the widget can be dismissed.
  final DismissDirection direction;

  /// The amount of time the widget will spend contracting before [onDismissed] is called.
  ///
  /// If null, the widget will not contract and [onDismissed] will be called
  /// immediately after the widget is dismissed.
  final Duration? resizeDuration;

  /// The offset threshold the item has to be dragged in order to be considered
  /// dismissed.
  ///
  /// Represented as a fraction, e.g. if it is 0.4 (the default), then the item
  /// has to be dragged at least 40% towards one direction to be considered
  /// dismissed. Clients can define different thresholds for each dismiss
  /// direction.
  ///
  /// Flinging is treated as being equivalent to dragging almost to 1.0, so
  /// flinging can dismiss an item past any threshold less than 1.0.
  ///
  /// Setting a threshold of 1.0 (or greater) prevents a drag in the given
  /// [DismissDirection] even if it would be allowed by the [direction]
  /// property.
  ///
  /// See also:
  ///
  ///  * [direction], which controls the directions in which the items can
  ///    be dismissed.
  final Map<DismissDirection, double> dismissThresholds;

  /// The offset threshold the item has to be dragged to before
  /// the user left his finger in order to call [actionCallback]
  ///
  /// Represented as a fraction, e.g. if it is 0.25 (the default), then the item
  /// has to be dragged at least 25% towards one direction to call [actionCallback].
  /// Clients can define different thresholds for each swipe direction.
  ///
  final Map<DismissDirection, double> actionThresholds;

  /// Defines the duration for card to dismiss or to come back to original position if not dismissed.
  final Duration movementDuration;

  final Duration movementReverseDuration;

  /// Defines the end offset across the main axis after the card is dismissed.
  ///
  /// If non-zero value is given then widget moves in cross direction depending on whether
  /// it is positive or negative.
  final double crossAxisEndOffset;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag gesture used to dismiss a
  /// dismissible will begin at the position where the drag gesture won the arena.
  /// If set to [DragStartBehavior.down] it will begin at the position where
  /// a down event is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;

  /// How to behave during hit tests.
  ///
  /// This defaults to [HitTestBehavior.opaque].
  final HitTestBehavior behavior;

  /// Called when the dismissible widget has been dragged.
  ///
  /// If [onUpdate] is not null, then it will be invoked for every pointer event
  /// to dispatch the latest state of the drag. For example, this callback
  /// can be used to for example change the color of the background widget
  /// depending on whether the dismiss threshold is currently reached.
  final DismissUpdateCallback? onUpdate;

  /// Called once the widget is back in place IF the user had dragged
  /// the widget higher than the value within [actionThresholds].
  ///
  final VoidCallback? actionCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) => BsDismissible(
    key: key!,
    background: background,
    secondaryBackground: secondaryBackground,
    confirmDismiss: confirmDismiss,
    onResize: onResize,
    onDismissed: onDismissed,
    direction: direction,
    resizeDuration: resizeDuration,
    dismissThresholds: dismissThresholds,
    actionThresholds: actionThresholds,
    movementDuration: movementDuration,
    crossAxisEndOffset: crossAxisEndOffset,
    dragStartBehavior: dragStartBehavior,
    behavior: behavior,
    onUpdate: onUpdate,
    actionCallback: actionCallback,
    child: child,
  );
}

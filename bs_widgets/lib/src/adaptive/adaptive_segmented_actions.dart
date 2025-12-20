import 'dart:collection';

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentedAction<T extends Object> {
  SegmentedAction({required this.label, required this.icon, required this.value});

  final Widget label;
  final Widget? icon;

  /// This is the ordering key of the action
  /// i.e. this is the order in which this action will be displayed
  /// using the [compare] function of the provided type
  ///
  /// use types that implement [Comparable]
  /// like double, int, String, DateTime, etc
  final T value;
}

class AdaptiveSegmentedActions<T extends Object> extends StatelessWidget {
  const AdaptiveSegmentedActions({
    super.key,
    required this.actions,
    required this.onSelectionChanged,
    this.useSlidingInCupertino = true,
    this.groupValue,
    this.backgroundColor,
  });

  final List<SegmentedAction<T>> actions;
  final ValueSetter<T?> onSelectionChanged;
  final bool useSlidingInCupertino;
  final Color? backgroundColor;

  /// If this attribute is null, no action will be initially selected.
  final T? groupValue;

  @override
  Widget build(BuildContext context) => StaticData.platform.isApple
      ? buildCupertinoSegmentedControl(context, useSlidingInCupertino)
      : buildSegmentedButton(context);

  SegmentedButton<T> buildSegmentedButton(BuildContext context) {
    /// Previously we used [SplayTreeMap.fromIterable] which forces
    /// the use of dynamic access to elements. Now It is safe to use
    /// Since it is compile-time-checked.
    ///
    /// Same happened in [buildCupertinoSegmentedControl]
    final segments = SplayTreeMap<T, ButtonSegment<T>>.from(
      Map<T, ButtonSegment<T>>.fromEntries(
        actions.map(
          (action) => MapEntry(
            action.value,
            ButtonSegment<T>(
              value: action.value,
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: FittedBox(child: action.label),
              ),
              icon: action.icon,
            ),
          ),
        ),
      ),
    ).values.toList();

    return SegmentedButton<T>(
      onSelectionChanged: (selectedActions) =>
          selectedActions.isEmpty ? null : onSelectionChanged(selectedActions.first),
      emptySelectionAllowed: true,
      segments: segments,
      selected: {if (groupValue != null) groupValue!},
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).canvasColor,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      ),
    );
  }

  Widget buildCupertinoSegmentedControl(BuildContext context, bool useSlidingInCupertino) {
    final children = SplayTreeMap<T, Widget>.from(
      Map.fromEntries(
        actions.map(
          (action) => MapEntry(
            action.value,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (action.icon != null) action.icon!,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: action.label,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return useSlidingInCupertino
        ? CupertinoSlidingSegmentedControl<T>(
            children: children,
            proportionalWidth: true,
            onValueChanged: onSelectionChanged,
            thumbColor: Theme.of(context).focusColor,
            backgroundColor: backgroundColor ?? Theme.of(context).canvasColor,
            groupValue: groupValue,
          )
        : CupertinoSegmentedControl(
            children: children,
            onValueChanged: onSelectionChanged,
            groupValue: groupValue,
          );
  }
}

// class AdaptiveSegmentedAction<ActionType extends Object> extends StatelessWidget {
//   const AdaptiveSegmentedAction({super.key});
//
//   final Map<ActionType, Widget> other = {};
//   final ActionType? groupValue;
//
//   @override
//   Widget build(BuildContext context) {
//     return StaticData.platform.isApple
//         ? Cupertino<ActionType>(
//             children: SplayTreeMap..addAll(other),
//             onValueChanged: (value) {},
//             groupValue: groupValue,
//           )
//         : SegmentedButton<ActionType>(
//             segments: List.generate(
//               other.length,
//               (index) {
//                 return ButtonSegment(
//                   value: other.keys.elementAt(index),
//                   label:
//                 );
//               },
//             ),
//             selected: {if (groupValue != null) groupValue!},
//           );
//   }
// }

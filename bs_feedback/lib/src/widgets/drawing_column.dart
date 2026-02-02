// ignore_for_file: public_member_api_docs

import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/adaptive_button.dart';
import 'package:flutter/material.dart';

import 'color_picker/color_picker_icon.dart';

/// This is the Widget on the right side of the app when the feedback view
/// is active.
class DrawingColumn extends StatelessWidget {
  /// Creates a [DrawingColumn].
  DrawingColumn({
    super.key,
    required this.activeColor,
    required this.onColorChanged,
    required this.onUndo,
    required this.onClearDrawing,
    required this.colors,
  }) : assert(
         colors.isNotEmpty,
         'There must be at least one color to draw in colors',
       );

  // assert(colors.contains(activeColor), 'colors must contain activeColor');

  final ValueChanged<Color> onColorChanged;
  final VoidCallback? onUndo;
  final VoidCallback? onClearDrawing;
  final List<Color> colors;
  final Color activeColor;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(24),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        AdaptiveIconButton(
          key: const ValueKey<String>('clear_button'),
          iconData: AppStyle.icons.pin,
          onPressed: onClearDrawing,
        ),
        const _ColumnDivider(),
        // for (final color in Colors.primaries)
        for (final color in colors)
          _ColorSelectionIconButton(
            key: ValueKey<Color>(color),
            color: color,
            onPressed: onColorChanged,
            isActive: activeColor == color,
          ),
        ColorPickerIcon(
          onColorChanged: onColorChanged,
          activeColor: activeColor,
        ),
        const _ColumnDivider(),
        AdaptiveIconButton(
          key: const ValueKey<String>('undo_button'),
          iconData: AppStyle.icons.undo,
          onPressed: onUndo,
        ),
      ],
    ),
  );
}

class _ColorSelectionIconButton extends StatelessWidget {
  const _ColorSelectionIconButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.isActive,
  });

  final Color color;
  final ValueChanged<Color>? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) => AdaptiveIconButton(
    iconData: isActive ? Icons.lens : Icons.panorama_fish_eye,
    iconColor: color,
    onPressed: onPressed == null ? null : () => onPressed!(color),
  );
}

class _ColumnDivider extends StatelessWidget {
  const _ColumnDivider();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    width: 35,
    height: 1,
    color: Theme.of(context).dividerColor,
  );
}

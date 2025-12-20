import 'package:flutter/material.dart';

class CardWell extends StatelessWidget {
  const CardWell({
    super.key,
    required this.child,
    required this.onPressed,
    this.shape,
    this.clipBehaviour = Clip.antiAlias,
  });

  final Widget child;
  final ShapeBorder? shape;
  final VoidCallback onPressed;
  final Clip clipBehaviour;

  BorderRadius get borderRadius12 => BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    shape:
        shape ??
        RoundedRectangleBorder(
          side: const BorderSide(width: 0.2),
          borderRadius: borderRadius12,
        ),
    child: InkWell(
      borderRadius: borderRadius12,
      onTap: onPressed,
      child: child,
    ),
  );
}

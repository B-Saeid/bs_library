import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';

class CustomChild extends StatelessWidget {
  const CustomChild({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(15.0),
    decoration: ShapeDecoration(
      shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(12)),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.secondaryContainer,
          Theme.of(context).colorScheme.secondaryContainer.darken(by: 0.2),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: ['U', 'R', 'N']
              .map(
                (latter) => DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(12)),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      latter,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary.invertedBW,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 50),
        DecoratedBox(
          decoration: ShapeDecoration(
            shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(12)),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'CONTROL',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer.invertedBW,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

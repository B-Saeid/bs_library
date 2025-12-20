import 'package:flutter/material.dart';
import 'src/color_extension.dart';

class ColorSchemeView extends StatelessWidget {
  const ColorSchemeView({super.key,this.themeChanger});

  final Widget? themeChanger;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final map = {
      'primary': colorScheme.primary,
      'onPrimary': colorScheme.onPrimary,
      'primaryContainer': colorScheme.primaryContainer,
      'onPrimaryContainer': colorScheme.onPrimaryContainer,
      'primaryFixed': colorScheme.primaryFixed,
      'primaryFixedDim': colorScheme.primaryFixedDim,
      'onPrimaryFixed': colorScheme.onPrimaryFixed,
      'onPrimaryFixedVariant': colorScheme.onPrimaryFixedVariant,
      'secondary': colorScheme.secondary,
      'onSecondary': colorScheme.onSecondary,
      'secondaryContainer': colorScheme.secondaryContainer,
      'onSecondaryContainer': colorScheme.onSecondaryContainer,
      'secondaryFixed': colorScheme.secondaryFixed,
      'secondaryFixedDim': colorScheme.secondaryFixedDim,
      'onSecondaryFixed': colorScheme.onSecondaryFixed,
      'onSecondaryFixedVariant': colorScheme.onSecondaryFixedVariant,
      'tertiary': colorScheme.tertiary,
      'onTertiary': colorScheme.onTertiary,
      'tertiaryContainer': colorScheme.tertiaryContainer,
      'onTertiaryContainer': colorScheme.onTertiaryContainer,
      'tertiaryFixed': colorScheme.tertiaryFixed,
      'tertiaryFixedDim': colorScheme.tertiaryFixedDim,
      'onTertiaryFixed': colorScheme.onTertiaryFixed,
      'onTertiaryFixedVariant': colorScheme.onTertiaryFixedVariant,
      'error': colorScheme.error,
      'onError': colorScheme.onError,
      'errorContainer': colorScheme.errorContainer,
      'onErrorContainer': colorScheme.onErrorContainer,
      'surface': colorScheme.surface,
      'onSurface': colorScheme.onSurface,
      // 'surfaceVariant': colorScheme.surfaceVariant,
      'surfaceDim': colorScheme.surfaceDim,
      'surfaceBright': colorScheme.surfaceBright,
      'surfaceContainerLowest': colorScheme.surfaceContainerLowest,
      'surfaceContainerLow': colorScheme.surfaceContainerLow,
      'surfaceContainer': colorScheme.surfaceContainer,
      'surfaceContainerHigh': colorScheme.surfaceContainerHigh,
      'surfaceContainerHighest': colorScheme.surfaceContainerHighest,
      'onSurfaceVariant': colorScheme.onSurfaceVariant,
      'outline': colorScheme.outline,
      'outlineVariant': colorScheme.outlineVariant,
      'shadow': colorScheme.shadow,
      'scrim': colorScheme.scrim,
      'inverseSurface': colorScheme.inverseSurface,
      'onInverseSurface': colorScheme.onInverseSurface,
      'inversePrimary': colorScheme.inversePrimary,
      'surfaceTint': colorScheme.surfaceTint,
      // 'background': colorScheme.background,
      // 'onBackground': colorScheme.onBackground,
    };
    return Scaffold(
      appBar: AppBar(title: const Text('ColorScheme View'),actions: [?themeChanger],),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 15,
              alignment: WrapAlignment.spaceBetween,
              children: map.entries
                  .map(
                    (entry) => Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: 150,
                      height: 50,
                      decoration: ShapeDecoration(
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: entry.value,
                      ),
                      child: FittedBox(
                        child: Text(
                          entry.key,
                          style: TextStyle(color: entry.value.invertedBW,fontSize: 16),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

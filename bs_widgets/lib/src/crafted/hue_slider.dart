import 'dart:math';

import 'package:flutter/material.dart';

final _colorsList =
    List<Color>.from(
      Colors.primaries.take(Colors.primaries.length - 2),
    ).followedBy(
      [Colors.brown.shade500, Colors.black],
    ).toList();
final _colorShare = 1 / (_colorsList.length - 1);

const _thumbRadius = 18.0;
double _cachedHueSlider = 1.0;

class HueSlider extends StatefulWidget {
  const HueSlider({
    super.key,
    required this.activeColor,
    required this.onChanged,
  });

  final Color activeColor;
  final ValueSetter<Color> onChanged;

  @override
  State<HueSlider> createState() => _HueSliderState();
}

class _HueSliderState extends State<HueSlider> {
  @override
  void initState() {
    super.initState();
    Future(() {
      _presetToActiveColorIfExists();
      onChanged(_cachedHueSlider);
    });
  }

  void _presetToActiveColorIfExists() {
    /// Presetting [_cachedHueSlider] to move the slider to match the provided
    /// [activeColor] if it is present in [_colorsList]
    Color? matchedColor;
    _colorsList.any(
      (element) {
        if (widget.activeColor == element) {
          matchedColor = element;
          return true;
        }
        return false;
      },
    );
    if (matchedColor != null) {
      final index = _colorsList.indexOf(matchedColor!);
      _cachedHueSlider = index * _colorShare;
    }
  }

  Color _hueSlideColor = Colors.transparent;
  double _slideValue = _cachedHueSlider;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _thumbRadius,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: _thumbRadius / 2,
          margin: const EdgeInsets.symmetric(horizontal: _thumbRadius),
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: _colorsList,
            ),
            shape: const StadiumBorder(),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SliderTheme(
              data: const SliderThemeData(
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: _thumbRadius * 0.65,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: _thumbRadius,
                ),
              ),
              child: Slider(
                activeColor: Colors.transparent,
                inactiveColor: Colors.transparent,
                thumbColor: _hueSlideColor,
                value: _slideValue,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  void onChanged(double value) {
    final hueColor = _getColorFromSliderValue(value);

    setState(() {
      _hueSlideColor = hueColor;
      _slideValue = value;
      _cachedHueSlider = _slideValue;
    });
    widget.onChanged(_hueSlideColor);
  }

  Color _getColorFromSliderValue(double value) {
    final firstIndex = value ~/ _colorShare;
    final secondIndex = min(firstIndex + 1, _colorsList.length - 1);
    final (first, second) = (_colorsList[firstIndex], _colorsList[secondIndex]);

    final interpolation = value / _colorShare - min(firstIndex, secondIndex);

    final hueColor = Color.lerp(first, second, interpolation);
    return hueColor!;
  }
}

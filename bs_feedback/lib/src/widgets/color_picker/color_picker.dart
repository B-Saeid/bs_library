part of 'color_picker_icon.dart';

class _ColorPicker extends StatefulWidget {
  const _ColorPicker({
    required this.onColorChanged,
    required this.activeColor,
    required this.closeCallback,
  });

  final ValueChanged<Color> onColorChanged;
  final Color activeColor;
  final ValueGetter<bool> closeCallback;

  @override
  State<_ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(widget.closeCallback, priority: 2);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(widget.closeCallback);
    super.dispose();
  }

  late Color _hueSlideColor = widget.activeColor;
  double _whiteToColorValue = _cachedWhiteToColorValue;

  void onHueColorChanged(Color color) => setState(
    () => _hueSlideColor = color,
  );

  void onWhiteToColorChanged(double value) => setState(
    () => _whiteToColorValue = value,
  );

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(8),
        boxShadow: kElevationToShadow[4],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 600),
        child: AspectRatio(
          aspectRatio: 5 / 6,
          child: Column(
            spacing: _thumbRadius,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 5 / 4,
                child: _WhiteToColorBox(
                  color: _hueSlideColor,
                  innerSetter: onWhiteToColorChanged,
                  outsideSetter: widget.onColorChanged,
                ),
              ),
              _AlphaSlider(
                color: _hueSlideColor,
                whiteToColorValue: _whiteToColorValue,
                outsideSetter: widget.onColorChanged,
              ),

              /// This is not affected by the alpha slider nor the white to color
              _HueSlider(
                activeColor: widget.activeColor,
                insideSetter: onHueColorChanged,
                outSideSetter: widget.onColorChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

part of '../widgets/painter.dart';

class PainterController extends ChangeNotifier {
  PainterController() : _pathHistory = _PathHistory();

  Color _drawColor = const Color.fromARGB(255, 0, 0, 0);

  double _thickness = 1;
  final _PathHistory _pathHistory;

  Color get drawColor => _drawColor;

  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  double get thickness => _thickness;

  set thickness(double thickness) {
    _thickness = thickness;
    _updatePaint();
  }

  void _updatePaint() {
    final paint = Paint()
      ..color = drawColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    _pathHistory.currentPaint = paint;
    notifyListeners();
  }

  void undo() {
    _pathHistory.undo();
    notifyListeners();
  }

  void _notifyListeners() => notifyListeners();

  void clear() {
    _pathHistory.clear();
    notifyListeners();
  }

  int getStepCount() => _pathHistory._paths.length;

  @visibleForTesting
  void addMockStep() {
    _pathHistory._paths.add(MapEntry<Path, Paint>(Path(), Paint()));
  }
}

class _Painter extends CustomPainter {
  _Painter(this._path, {super.repaint});

  final _PathHistory _path;

  @override
  void paint(Canvas canvas, Size size) => _path.draw(canvas, size);

  @override
  bool shouldRepaint(_Painter oldDelegate) => true;
}

class _PathHistory {
  _PathHistory() : _paths = <MapEntry<Path, Paint>>[], _inDrag = false, currentPaint = Paint();

  final List<MapEntry<Path, Paint>> _paths;
  Paint currentPaint;
  bool _inDrag;

  void undo() {
    if (!_inDrag && _paths.isNotEmpty) _paths.removeLast();
  }

  void clear() {
    if (!_inDrag) _paths.clear();
  }

  void add(Offset startPoint) {
    if (_inDrag) return;

    _inDrag = true;
    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    _paths.add(MapEntry<Path, Paint>(path, currentPaint));
  }

  void pointAdd(Offset startPoint) {
    // if (_inDrag) return;

    // _inDrag = true;
    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    _paths.add(MapEntry<Path, Paint>(path, currentPaint));
    path.addOval(
      Rect.fromCenter(
        center: startPoint,
        width: 3,
        height: 3,
      ),
    );
  }

  void updateCurrent(Offset nextPoint) {
    if (!_inDrag) return;

    final path = _paths.last.key;
    path.lineTo(nextPoint.dx, nextPoint.dy);
  }

  void endCurrent() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    for (final path in _paths) {
      canvas.drawPath(path.key, path.value);
    }
  }
}

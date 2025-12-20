// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart' hide Image;

part '../controllers/painter_controller.dart';

class Painter extends StatefulWidget {
  Painter(this.painterController)
    : super(
        key: ValueKey<PainterController>(painterController),
      );

  final PainterController painterController;

  @override
  State<Painter> createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: GestureDetector(
      onTapUp: _onTapUp,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        willChange: true,
        painter: _Painter(
          widget.painterController._pathHistory,
          repaint: widget.painterController,
        ),
      ),
    ),
  );

  void _onPanStart(DragStartDetails start) {
    final pos = (context.findRenderObject() as RenderBox).globalToLocal(start.globalPosition);
    widget.painterController._pathHistory.add(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanUpdate(DragUpdateDetails update) {
    final pos = (context.findRenderObject() as RenderBox).globalToLocal(update.globalPosition);
    widget.painterController._pathHistory.updateCurrent(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanEnd(DragEndDetails end) {
    widget.painterController._pathHistory.endCurrent();
    widget.painterController._notifyListeners();
  }

  void _onTapUp(TapUpDetails details) {
    final pos = (context.findRenderObject() as RenderBox).globalToLocal(details.globalPosition);
    widget.painterController._pathHistory.pointAdd(pos);
    widget.painterController._notifyListeners();
  }
}

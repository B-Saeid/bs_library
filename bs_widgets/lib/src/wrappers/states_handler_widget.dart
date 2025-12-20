import 'package:flutter/material.dart';

class StatesHandlerWidget extends StatefulWidget {
  const StatesHandlerWidget({
    super.key,
    this.onInitState,
    this.postInitState,
    this.onDispose,
    required this.child,
  });

  final Function? onInitState;
  final Function? postInitState;
  final Function? onDispose;
  final Widget child;

  @override
  State<StatesHandlerWidget> createState() => _StatesHandlerWidgetState();
}

class _StatesHandlerWidgetState extends State<StatesHandlerWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInitState?.call();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.postInitState?.call();
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(_) => widget.child;
}

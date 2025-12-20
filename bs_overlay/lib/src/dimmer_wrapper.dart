import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic.dart';

class DimmedWrapper extends StatefulWidget {
  const DimmedWrapper(
    this.child, {
    super.key,
    this.dismissOnTap = false,
    this.barrierDismissible = false,
    this.isOverall = false,
    this.showCloseIcon = false,
  });

  final Object child;
  final bool showCloseIcon;
  final bool dismissOnTap;
  final bool barrierDismissible;
  final bool isOverall;

  @override
  State<DimmedWrapper> createState() => _DimmedWrapperState();
}

class _DimmedWrapperState extends State<DimmedWrapper> {
  late final _focusNode = widget.barrierDismissible ? FocusNode() : null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.barrierDismissible) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => RefWidget(
      (ref) => Focus(
        focusNode: _focusNode,
        onKeyEvent: !widget.barrierDismissible ? null : _dismissOnESCPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: Colors.black87.withAlphaFraction(StaticData.platform.isApple ? 0.4 : 0.8),
          width: LiveData.deviceWidth(ref),
          height: LiveData.deviceHeight(ref),
          child: Stack(
            children: [
              if (widget.barrierDismissible)
                Positioned.fill(child: GestureDetector(onTap: _handleDismiss)),
              _centerContainer(ref, widget.child),
              if (widget.showCloseIcon) _DismissIconButton(_handleDismiss),
            ],
          ),
        ),
      ),
    ),
  );

  KeyEventResult _dismissOnESCPressed(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      _handleDismiss();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  SafeArea _centerContainer(WidgetRef ref, Object child) => SafeArea(
    child: Center(
      child: widget.dismissOnTap
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _handleDismiss,
              child: _childWrapper(child, ref),
            )
          : _childWrapper(child, ref),
    ),
  );

  Widget _childWrapper(Object child, WidgetRef ref) {
    final zChild = switch (child) {
      String s => DefaultTextStyle.merge(
        style: LiveData.textTheme(ref).titleLarge,
        child: Text(s),
      ),
      _ => child as Widget,
    };

    final width = LiveData.deviceWidth(ref) * 0.8;
    const padding = EdgeInsets.all(18.0);

    Widget childWrapper;

    if (StaticData.platform.isApple) {
      childWrapper = CupertinoPopupSurface(
        child: Container(
          width: width,
          padding: padding,
          child: zChild,
        ),
      );
    } else {
      childWrapper = TextContainer(
        width: width,
        padding: padding,
        color: LiveData.themeData(ref).colorScheme.surfaceDim,
        child: zChild,
      );
    }

    return childWrapper;
  }

  void _handleDismiss() => widget.isOverall
      ? BsOverlayLogic.removeOverallEntry()
      : BsOverlayLogic.resetAndGoToNext(manualDismiss: true);
}

class _DismissIconButton extends ConsumerWidget {
  const _DismissIconButton(this._handleDismiss);

  final VoidCallback _handleDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = Directionality.of(context);
    final viewPadding = LiveData.viewPadding(ref);
    final baseEndPadding = direction == TextDirection.ltr ? viewPadding.right : viewPadding.left;
    return Positioned.directional(
      textDirection: direction,
      top: viewPadding.top + 10,
      end: baseEndPadding + 10,
      child: AdaptiveIconButton.tinted(
        onPressed: _handleDismiss,
        iconData: AppStyle.icons.close,
      ),
    );
  }
}

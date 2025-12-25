import 'dart:async';
import 'dart:developer';

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:bs_widgets/riverpod_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'enums.dart';
import 'logic.dart';

/// internal [StatefulWidget] which handles the show and hide animations.
///
class CoreWidget extends StatefulWidget {
  const CoreWidget({
    super.key,
    required this.child,
    this.duration,
    required this.ignorePointer,
    this.gravity,
    this.dismissCallback,
    this.dismissOnBack = false,
    this.dismissOnTap = false,
    this.barrier = true,
    this.barrierDismissible = false,
    this.avoidKeyboard = false,
    this.overall = false,
  });

  final Widget child;
  final Duration? duration;
  final bool ignorePointer;
  final BsGravity? gravity;
  final VoidCallback? dismissCallback;
  final bool dismissOnBack;
  final bool dismissOnTap;
  final bool barrier;
  final bool barrierDismissible;
  final bool avoidKeyboard;
  final bool overall;

  @override
  // ignore: library_private_types_in_public_api
  _CoreWidgetState createState() => _CoreWidgetState();

  static Duration get _fadeInDuration => 350.milliseconds;

  static Duration get _fadeOutDuration => 200.milliseconds;

  static Duration get fadeDurations => _fadeInDuration + _fadeOutDuration;
}

class _CoreWidgetState extends State<CoreWidget> with SingleTickerProviderStateMixin {
  /// Start the showing animations for the overlay
  void showIt() => _animationController!.forward();

  /// Start the hiding animations for the overlay
  Future<void> hideIt() async {
    widget.overall
        ? BsOverlayLogic.topEntries.last.animatedHide = null
        : BsOverlayLogic.current?.animatedHide = null;
    try {
      await _animationController!.reverse();
    } catch (e) {
      log('Error Caught While Animating out, $e', name: 'BsOverlay-CoreWidget');
    }
    _timer?.cancel();
  }

  Future<bool> animateDismiss() async {
    await hideIt();
    widget.dismissCallback?.call();
    return true;
  }

  /// Controller to start and hide the animation
  AnimationController? _animationController;
  late final Animation<double> _fadeAnimation;
  late final _focusNode = widget.barrierDismissible ? FocusNode() : null;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: CoreWidget._fadeInDuration,
      reverseDuration: CoreWidget._fadeOutDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubicEmphasized,
    );

    showIt();

    if (widget.duration != null) {
      _timer = Timer(widget.duration!, () => hideIt());
    }

    widget.overall
        ? BsOverlayLogic.topEntries.last.animatedHide = hideIt
        : BsOverlayLogic.current?.animatedHide = hideIt;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.barrierDismissible) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _animationController!.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  bool get bottomInsetsCare =>
      widget.avoidKeyboard || [BsGravity.bottomSafe, BsGravity.snackBar].contains(widget.gravity);

  /// Our Path:
  /// [_barrierDismissWrapper] ->
  /// [_bottomCareWrapper] ->
  /// [_backDismissWrapper] ->
  /// [_centerMaterialWrapper] ->
  /// [_ignorePointerWrapper] ->
  /// [_tapHandlerWrapper] ->
  /// finally [_child]
  @override
  Widget build(BuildContext context) => _barrierDismissWrapper;

  Widget get _barrierDismissWrapper => widget.barrier
      ? Focus(
          autofocus: true,
          focusNode: _focusNode,
          onKeyEvent: !widget.barrierDismissible ? null : _dismissOnESCPressed,
          child: Stack(
            children: [
              ConsumerOrStateless(
                builder: (context, ref, child) => SizedBox.fromSize(
                  size: LiveDataOrQuery.sizeQuery(ref: ref, context: context),
                  child: child!,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.barrierDismissible ? animateDismiss : null,
                ),
              ),
              widget.gravity?.positionedBuilder(_bottomCareWrapper) ?? _bottomCareWrapper,
            ],
          ),
        )
      : widget.gravity?.positionedBuilder(_bottomCareWrapper) ?? _bottomCareWrapper;

  KeyEventResult _dismissOnESCPressed(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      animateDismiss();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget get _bottomCareWrapper => bottomInsetsCare
      ? ConsumerOrStateless(
          /// SWEET Observation:
          /// on both Android & iOS: When the keyboard is dismissed while the
          /// overlay is shown it animates down nicely with the keyboard.
          builder: (context, ref, child) {
            final viewInsetsBottom = LiveDataOrQuery.viewInsets(ref: ref, context: context).bottom;
            final viewPaddingBottom = LiveDataOrQuery.viewPadding(
              ref: ref,
              context: context,
            ).bottom;
            return Padding(
              padding: EdgeInsets.only(
                bottom: widget.avoidKeyboard || widget.gravity!.isBottomSafe
                    ? viewPaddingBottom + viewInsetsBottom
                    /// This is for the last case [gravity.snackBar]
                    : viewInsetsBottom == 0
                    ? viewPaddingBottom
                    : viewInsetsBottom,
              ),
              child: child!,
            );
          },
          child: _backDismissWrapper,
        )
      : _backDismissWrapper;

  Widget get _backDismissWrapper {
    if (Router.maybeOf(context) != null) {
      return BackButtonListener(
        onBackButtonPressed: widget.dismissOnBack
            ? animateDismiss
            :
              /// This is necessary as it holds the back button popup from being handled
              /// elsewhere like performing back navigation or closing the app
              /// unintentionally while an overlay is shown
              () => Future.value(false),
        child: _centerMaterialWrapper,
      );
    }

    if (widget.dismissOnBack) {
      log(
        'WARNING: dismissOnBack is set to true but no Router ancestor is found',
        level: 500,
        name: 'Overlay',
      );
    }

    return _centerMaterialWrapper;
  }

  Center get _centerMaterialWrapper => Center(
    child: Material(color: Colors.transparent, child: _ignorePointerWrapper),
  );

  Widget get _ignorePointerWrapper =>
      widget.ignorePointer ? IgnorePointer(child: _tapHandlerWrapper) : _tapHandlerWrapper;

  Widget get _tapHandlerWrapper => widget.dismissOnTap
      ? GestureDetector(
          onTap: animateDismiss,
          behavior: HitTestBehavior.translucent,
          child: _child,
        )
      : _child;

  Widget get _child => FadeTransition(opacity: _fadeAnimation, child: widget.child);
}

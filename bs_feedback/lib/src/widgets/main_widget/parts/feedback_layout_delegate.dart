part of '../feedback_widget.dart';

enum _Children { app, freezeIcon, drawings, sheet, actions }

enum _Actions {
  close,
  draw,
  navigate;

  String text(BuildContext context) => switch (this) {
    _Actions.close => FeedbackLocalizations.of(context).close,
    _Actions.draw => FeedbackLocalizations.of(context).draw,
    _Actions.navigate => FeedbackLocalizations.of(context).navigate,
  };

  IconData get iconData => switch (this) {
    _Actions.close => AppStyle.icons.close,
    _Actions.draw => AppStyle.icons.draw,
    _Actions.navigate => AppStyle.icons.phone,
  };

  static double groupValue(FeedbackMode mode) => switch (mode) {
    FeedbackMode.draw => _Actions.draw.orderKey,
    FeedbackMode.navigate => _Actions.navigate.orderKey,
  };

  double get orderKey => switch (this) {
    _Actions.close => 0,
    _Actions.navigate => 1,
    _Actions.draw => 2,
  };

  static _Actions? fromOrderKey(double? orderKey) => _Actions.values.firstWhereOrNull(
    (e) => e.orderKey == orderKey,
  );
}

class _FeedbackLayoutDelegate extends MultiChildLayoutDelegate {
  _FeedbackLayoutDelegate({
    required this.displayFeedback,
    required this.query,
    required this.sheetFraction,
    required this.openingProgress,
    required this.displayColumn,
    required this.drawingColumnProgress,
  });

  final bool displayFeedback;
  final MediaQueryData query;
  final double? sheetFraction;
  final double openingProgress;
  final bool displayColumn;
  final double drawingColumnProgress;

  double get safeAreaHeight => query.viewPadding.top;

  double get keyboardHeight => query.viewInsets.bottom;

  double get screenHeight => query.size.height;

  /// The size passed down here == device screen size.
  /// as this is the size of the parent widget.
  @override
  void performLayout(Size size) {
    // print('animationProgress = $openingProgress');

    /// If the feedback view is closed, JUST lay out the app view
    if (!displayFeedback) {
      layoutChild(_Children.app, BoxConstraints.tight(size));

      /// Crucial line that fixed the miserable displacement of
      /// the app after closing the feedback view.
      positionChild(_Children.app, Offset.zero);
      return;
    }

    ///
    /// STEP 1
    ///
    /// Lay out the sheet on bottom
    final sheetHeight = layoutChild(
      _Children.sheet,
      BoxConstraints.loose(
        Size(
          size.width,
          size.height,
        ),
      ),
    ).height;

    // print('sheetHeight = $sheetHeight');
    // print('sheetFraction = $sheetFraction');
    // Position sheet.
    ///
    /// STEP 2
    ///
    /// Position the sheet on bottom
    positionChild(
      _Children.sheet,
      Offset(
        0,
        size.height - openingProgress * (sheetHeight + keyboardHeight),
      ),
    );

    ///
    /// STEP 3
    ///
    /// Lay out the controls
    final minimumPadding = 8.0;
    final topPadding = safeAreaHeight + minimumPadding;

    final actionsSize = layoutChild(
      _Children.actions,
      BoxConstraints.loose(
        Size(
          size.width,
          size.height,
        ),
      ),
    );
    //
    // print('actionsSize = $actionsSize');

    ///
    /// STEP 4
    ///
    /// Position the controls on top safely.
    positionChild(
      _Children.actions,
      Offset(
        size.width - (size.width + actionsSize.width) / 2, // i.e. center horizontally
        openingProgress * topPadding,
      ),
    );

    ///
    /// STEP 5
    ///
    /// Lay out the drawing column if [displayColumn] is true
    /// i.e. if we are in draw mode.

    Size? drawingColumn;

    // Fraction of screen height taken up by the screenshot preview.

    // It is needed to be calculated before the column is laid out
    // as the column height depends on the app height.
    // It should never be greater than it.
    final screenshotFraction =
        1 -
        openingProgress *
            ((topPadding + actionsSize.height) / screenHeight +
                (sheetHeight * (sheetFraction ?? 1)) / screenHeight);
    final screenshotHeight = screenshotFraction * screenHeight;

    if (displayColumn) {
      drawingColumn = layoutChild(
        _Children.drawings,
        BoxConstraints.loose(
          Size(size.width, screenshotHeight),
        ),
      );
    }

    // print('controlsSize = $drawingColumn');
    // print('screenshotHeight = $screenshotHeight');
    // print('size = $size');

    final progressiveColumnWidth = drawingColumnProgress * (drawingColumn?.width ?? 0);

    ///
    /// STEP 6
    ///
    /// Lay out the freeze icon.
    double? freezeIconWidth;

    if (drawingColumnProgress < 1) {
      freezeIconWidth = layoutChild(
        _Children.freezeIcon,
        BoxConstraints.loose(
          Size(
            size.width,
            size.height,
          ),
        ),
      ).width;
    }

    final progressiveFreezeIconWidth = (1 - drawingColumnProgress) * (freezeIconWidth ?? 0);

    ///
    /// STEP 7
    ///
    /// Lay out app view, clipping the bounds to the correct aspect ratio.
    /// This acts as if we put the app in a [FittedBox] with fit = BoxFit.Contain and
    /// an alignment of [Alignment.topCenter].

    // print('size : $size');

    final inputSize = Size(
      size.width,
      size.height,
    );
    // print('inputSize : $inputSize');

    final outputSize = Size(
      size.width - openingProgress * (progressiveColumnWidth - progressiveFreezeIconWidth),
      size.height - openingProgress * (size.height - screenshotHeight),
    );
    // print('outputSize : $outputSize');
    final sourceDest = applyBoxFit(
      BoxFit.contain,
      inputSize,
      outputSize,
    );

    // print('sourceDest.source = ${sourceDest.source}');
    // print('sourceDest.destination = ${sourceDest.destination}');

    final appSize = layoutChild(
      _Children.app,
      // This clips our available space to the aspect ratio of the device screen
      BoxConstraints.tight(sourceDest.destination),
    );

    // print('appSize = $appSize');
    // print('destination = ${sourceDest.destination}');

    /// Align the screenshot to the top center
    final rect = Alignment.topCenter.inscribe(
      appSize,
      Rect.fromLTWH(
        0,
        0,
        outputSize.width,
        size.height,
        // appSize.height,
        // outputSize.height, // neglected, as we only care about the horizontal alignment.
      ),
    );

    // print('rect = $rect');

    ///
    /// STEP 8
    ///
    /// Position the app, freeze icon and the drawing column centered together.

    // [rect.topLeft.dy]same as [rect.topLeft.dy] we use the y
    final topYOffset = rect.topLeft.dy + topPadding + actionsSize.height;
    // print('topYOffset $topYOffset');
    // print('topYOffset2 ${openingProgress * topYOffset}');
    positionChild(
      _Children.app,
      Offset(
        rect.topLeft.dx,
        openingProgress * topYOffset,
      ),
    );

    if (drawingColumnProgress < 1) {
      positionChild(
        _Children.freezeIcon,
        Offset(
          min(1 - drawingColumnProgress, openingProgress) * (rect.topLeft.dx - freezeIconWidth!),
          topYOffset + (appSize.height - freezeIconWidth) / 2,
        ),
      );
    }

    if (displayColumn) {
      positionChild(
        _Children.drawings,
        Offset(
          size.width - openingProgress * progressiveColumnWidth,
          topYOffset + (appSize.height - (drawingColumn?.height ?? 0)) / 2,
        ),
      );
    }

    // Lay out actions button on the bottom.

    // final bottomViewPadding = query.viewPadding.bottom;
    // final minimumBottomPadding = 30.0;
    //
    // /// The bottom padding of the actions button. If the keyboard is visible, use
    // /// the keyboard height plus a minimum padding. Otherwise, use the larger of
    // /// the view padding and the minimum padding. This ensures that the actions
    // /// button is always visible above the keyboard and is not occluded by the
    // /// system notch or home indicator.
    // final bottomPadding = keyboardHeight > 0
    //     ? keyboardHeight + minimumBottomPadding
    //     : max(
    //         minimumBottomPadding,
    //         bottomViewPadding,
    //       );
    //
    // final actionsSize = layoutChild(
    //   _Children.actions,
    //   BoxConstraints.loose(
    //     Size(
    //       size.width,
    //       size.height - bottomPadding,
    //     ),
    //   ),
    // );
    // //
    // print('actionsSize = $actionsSize');
    //
    // // Position actions.
    //
    // positionChild(
    //   _Children.actions,
    //   Offset(
    //     size.width - (size.width + actionsSize.width) / 2,
    //     size.height - openingProgress * (actionsSize.height + bottomPadding),
    //   ),
    // );
  }

  @override
  bool shouldRelayout(covariant _FeedbackLayoutDelegate oldDelegate) =>
      openingProgress != oldDelegate.openingProgress ||
      drawingColumnProgress != oldDelegate.drawingColumnProgress ||
      sheetFraction != oldDelegate.sheetFraction ||
      query != oldDelegate.query ||
      displayColumn != oldDelegate.displayColumn;
}

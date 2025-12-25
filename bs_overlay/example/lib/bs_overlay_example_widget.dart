import 'package:bs_overlay/bs_overlay.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:flutter/material.dart';

import 'custom_child.dart';
import 'info_widget.dart';

class BsOverlayExampleWidget extends StatelessWidget {
  const BsOverlayExampleWidget({super.key});

  @override
  Widget build(BuildContext context) => const Directionality(
    textDirection: TextDirection.ltr,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 100),
          OverlayShowcase(),
          SizedBox(height: 100),
        ],
      ),
    ),
  );
}

class OverlayShowcase extends StatefulWidget {
  const OverlayShowcase({super.key});

  @override
  State<OverlayShowcase> createState() => _OverlayShowcaseState();
}

class _OverlayShowcaseState extends State<OverlayShowcase> {
  bool get useChild => !useContent;
  bool useContent = true;
  bool dismissOnTap = true;
  bool showCloseIcon = false;
  bool barrierDismissible = false;
  bool ignorePointer = false;
  bool barrier = true;
  VoidCallback? dismissCallback;

  @override
  void initState() {
    super.initState();
    Future(_update);
  }

  String? errorMessage;

  Future<void> _update() async {
    setState(() {});
    final tempErrorMessage = errorMessage;
    try {
      dismissCallback?.call();
      if (errorMessage != null) await Future.delayed(const Duration(milliseconds: 250));
      dismissCallback = _show(_PreviewOverlay.globalKey.currentContext);
      errorMessage = null;
    } catch (e) {
      if (e is AssertionError) {
        errorMessage = e.message.toString();
        // print(e.message);
      } else {
        errorMessage = e.toString();
      }
    }
    if (tempErrorMessage != errorMessage) setState(() {});
  }

  VoidCallback _show([BuildContext? context]) => BsOverlay.show(
    context: context,
    ignorePointer: ignorePointer,
    content: useContent ? exampleWidget : null,
    child: useChild ? exampleWidget : null,
    dismissOnTap: dismissOnTap,
    barrierDismissible: barrierDismissible,
    showCloseIcon: showCloseIcon,
    barrier: barrier,
  );

  late Widget exampleWidget = examples.first.widget;
  late String selectedExampleTitle = examples.first.title;
  late final examples = [
    (
      title: 'Loading Overlay',
      onSelected: () {
        useContent = true;
        ignorePointer = true;
        exampleWidget = const LoadingPleaseWait();
        selectedExampleTitle = 'Loading Overlay';
        dismissOnTap = false;
        barrierDismissible = false;
        showCloseIcon = false;
        barrier = true;
        _update();
      },
      tooltip: 'More Likely To Be Dismissed Programmatically Only',
      widget: const LoadingPleaseWait(),
    ),
    (
      title: 'Speed Info',
      onSelected: () {
        useContent = true;
        ignorePointer = false;
        exampleWidget = const SpeedInfo();
        selectedExampleTitle = 'Speed Info';
        dismissOnTap = false;
        barrierDismissible = true;
        showCloseIcon = true;
        barrier = true;
        _update();
      },
      tooltip: '',
      widget: const SpeedInfo(),
    ),
    (
      title: 'Custom Child',
      onSelected: () {
        useContent = false;
        ignorePointer = false;
        exampleWidget = const CustomChild();
        selectedExampleTitle = 'Custom Child';
        dismissOnTap = false;
        barrierDismissible = false;
        showCloseIcon = false;
        barrier = false;
        _update();
      },
      tooltip: '',
      widget: const CustomChild(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final examplesWidgets = examples
        .map(
          (example) => ChoiceChip(
            tooltip: example.tooltip,
            selected: example.title == selectedExampleTitle,
            showCheckmark: false,
            onSelected: (_) {
              example.onSelected();
            },
            label: Text(example.title),
          ),
        )
        .toList();
    final contentOrChild = Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        ChoiceChip(
          tooltip: 'Convenience Sizing and Adaptive Background',
          selected: useContent,
          label: const Text('Content'),
          onSelected: (_) {
            useContent = true;
            _update();
          },
        ),
        Text('Or', style: Theme.of(context).textTheme.titleMedium),
        ChoiceChip(
          tooltip: 'Full Control Over The Overlay - Shown as is',
          selected: useChild,
          label: const Text('Child'),
          onSelected: (_) {
            useContent = false;
            _update();
          },
        ),
      ],
    );
    final parameters = [
      contentOrChild,
      ChoiceChip(
        tooltip: 'Dismisses the overlay when tapped on it',
        selected: dismissOnTap,
        label: const Text('DismissOnTap'),
        onSelected: (value) {
          dismissOnTap = value;
          _update();
        },
      ),
      ChoiceChip(
        tooltip: 'Not Available When Custom Child Is Used',
        selected: showCloseIcon,
        label: const Text('ShowCloseIcon'),
        onSelected: (value) {
          showCloseIcon = value;
          _update();
        },
      ),
      ChoiceChip(
        tooltip: 'Dismiss if tapped around or When press ESC - Requires Barrier',
        selected: barrierDismissible,
        label: const Text('BarrierDismissible'),
        onSelected: (value) {
          barrierDismissible = value;
          if (barrierDismissible) barrier = true;
          _update();
        },
      ),
      ChoiceChip(
        tooltip: 'Prevents interaction with the underlying screen',
        selected: barrier,
        label: const Text('Barrier'),
        onSelected: (value) {
          barrier = value;
          if (!barrier) barrierDismissible = false;
          _update();
        },
      ),
      ChoiceChip(
        // tooltip: e.isBottomSafe || e.isSnackBar ? 'Not obscured by keyboard' : null,
        selected: ignorePointer,
        tooltip: 'Does not work with DismissOnTap',
        label: const Text('IgnorePointer'),
        onSelected: (value) {
          ignorePointer = value;
          _update();
        },
      ),
    ];
    final parametersTitle = Text(
      'Overlay Parameters',
      style: Theme.of(context).textTheme.titleLarge,
    );
    final examplesTitle = Text('Examples:', style: Theme.of(context).textTheme.titleLarge);
    final previewWidget = Card(
      child: DecoratedBox(
        decoration: const ShapeDecoration(shape: RoundedSuperellipseBorder()),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            const Positioned.fill(child: _PreviewOverlay(key: ValueKey('_PreviewOverlay'))),
            Positioned.fill(
              child: Center(
                child: CustomAnimatedSize(
                  child: errorMessage != null
                      ? FractionallySizedBox(
                          widthFactor: 0.8,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                errorMessage!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: errorMessage == null ? _show : null,
                child: const Text('Preview'),
              ),
            ),
          ],
        ),
      ),
    );
    return BreakPoints.isMobile(MediaQuery.sizeOf(context).width)
        ? Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    spacing: 20,
                    children: [
                      parametersTitle,
                      Wrap(
                        runSpacing: 20,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        spacing: 25,
                        children: parameters,
                      ),
                      examplesTitle,
                      Wrap(
                        runSpacing: 20,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        spacing: 25,
                        children: examplesWidgets,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 400,
                child: previewWidget,
              ),
            ],
          )
        : Row(
            children: [
              const Spacer(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 25,
                    children: [
                      parametersTitle,
                      ...parameters,
                      examplesTitle,
                      ...examplesWidgets,
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 6,
                child: SizedBox(height: 600, child: previewWidget),
              ),
              const Spacer(),
            ],
          );
  }
}

class _PreviewOverlay extends StatelessWidget {
  const _PreviewOverlay({super.key});

  static final globalKey = GlobalKey<OverlayState>();

  @override
  Widget build(BuildContext context) => Overlay(
    initialEntries: [
      OverlayEntry(
        builder: (context) => SizedBox(key: globalKey),
      ),
    ],
  );
}

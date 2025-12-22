import 'package:bs_toast/bs_toast.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

class BSToastExampleWidget extends StatelessWidget {
  const BSToastExampleWidget({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      children: [
        const SizedBox(height: 25),

        /// Standard Toasts
        Text(
          'Standard Toasts',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
        Wrap(
          spacing: 25,
          runSpacing: 25,
          alignment: WrapAlignment.center,
          children: [
            FilledButton(
              onPressed: () => Toast.show('Showing Basic Toast'),
              child: const Text('Basic'),
            ),
            FilledButton(
              onPressed: () => Toast.showSuccess('Operation Done Successfully'),
              child: const Text('Success'),
            ),
            FilledButton(
              onPressed: () => Toast.showWarning('Check Your lorem ipsum'),
              child: const Text('Warning'),
            ),
            FilledButton(
              onPressed: () => Toast.showError('Showing Error Example'),
              child: const Text('Error'),
            ),
          ],
        ),
        Divider(
          height: 50,
          indent: MediaQuery.sizeOf(context).width * 0.1,
          endIndent: MediaQuery.sizeOf(context).width * 0.1,
        ),

        /// Customizations
        const _Customizations(),
        const SizedBox(height: 100),
      ],
    ),
  );
}

class _Customizations extends StatefulWidget {
  const _Customizations();

  @override
  State<_Customizations> createState() => _CustomizationsState();
}

class _CustomizationsState extends State<_Customizations> {
  static const defaultMessage = 'Hello from BSaeid portfolio';
  late final TextEditingController messageController = TextEditingController(text: defaultMessage);

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  int durationSec = 2;
  Color color = Colors.green;
  bool dismissOnTap = true;
  BsGravity gravity = BsGravity.bottomSafe;
  BsPriority priority = BsPriority.now;

  //     bool ignorePointer = false, // option
  //     bool dismissOnTap = true, // option
  //     ValueSetter<bool>? onDismiss, // called and show manual dismiss true or false
  // Test open keyboard
  @override
  Widget build(BuildContext context) => Column(
    spacing: 25,
    children: [
      Text(
        'Custom Toasts',
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
      FractionallySizedBox(
        widthFactor: 0.6,
        child: TextField(
          enabled: liveToastCloseCallback != null,
          onChanged: (value) => messageNotifier.value = value,
          controller: messageController,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      Wrap(
        spacing: 10,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Duration: $durationSec s', style: Theme.of(context).textTheme.titleLarge),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: Slider(
              divisions: 10,
              min: 1.0,
              max: 10.0,
              value: durationSec.toDouble(),
              onChanged: (value) => setState(() => durationSec = value.toInt()),
            ),
          ),
        ],
      ),
      Wrap(
        spacing: 10,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Color:', style: Theme.of(context).textTheme.titleLarge),
          SizedBox.square(
            dimension: 20,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: const CircleBorder(side: BorderSide()),
                color: color,
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: HueSlider(
              activeColor: color,
              onChanged: (value) => setState(() => color = value),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          'Don\'t worry about the text. It will always be visible.',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      Row(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Gravity:', style: Theme.of(context).textTheme.titleLarge),
          Flexible(
            child: Wrap(
              spacing: 10,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...BsGravity.values.map(
                  (e) => ChoiceChip(
                    tooltip: e.isBottomSafe || e.isSnackBar ? 'Not obscured by keyboard' : null,
                    selected: gravity == e,
                    label: Text(e.name.capitalize()),
                    onSelected: (_) => setState(() => gravity = e),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Row(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Priority:', style: Theme.of(context).textTheme.titleLarge),
          Flexible(
            child: Wrap(
              spacing: 10,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...BsPriority.values
                    .whereNot((element) => element.isOverall)
                    .map(
                      (e) => ChoiceChip(
                        selected: priority == e,
                        label: Text(e.name.capitalize()),
                        onSelected: (_) {
                          switch (e) {
                            case BsPriority.regular:
                              messageController.text = 'I am a regular customer I wait on the line';
                            case BsPriority.noRepeat:
                              messageController.text = 'I can not be repeated but I can wait';
                            case BsPriority.now:
                              messageController.text = 'Show me NOW then continue the queue';
                            case BsPriority.ifEmpty:
                              messageController.text =
                                  'I have autism ONLY show me if queue is empty';
                            case BsPriority.nowNoRepeat:
                              messageController.text = 'I show now and can not be repeated';
                            case BsPriority.replaceAll:
                              messageController.text =
                                  'DESTRUCTIVE Show me NOW and clear the queue';
                            case BsPriority.overall:
                              throw ('Internal Use only');
                          }
                          setState(() => priority = e);
                        },
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          ChoiceChip(
            selected: dismissOnTap,
            onSelected: (bool? value) {
              setState(() => dismissOnTap = value!);
            },
            label: const Text('DismissOnTap'),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            icon: const Icon(Icons.clear),
            label: const Text('Clear Queue'),
            onPressed: Toast.clearQueue,
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 30,
          children: [
            FilledButton(onPressed: _showCustomToast, child: const Text('SHOW NORMAL')),
            Tooltip(
              message: 'Separated from Queue',
              child: FilledButton(
                onPressed: liveToastCloseCallback == null
                    ? _showLiveToast
                    : liveToastCloseCallback!,
                child: Text(liveToastCloseCallback == null ? 'SHOW LIVE' : 'CLOSE LIVE'),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  void _showCustomToast() => Toast.show(
    messageController.text,
    color: color,
    gravity: gravity,
    priority: priority,
    dismissOnTap: dismissOnTap,
    duration: Duration(seconds: durationSec),
  );
  late final ValueNotifier<String> messageNotifier = ValueNotifier(messageController.text);
  VoidCallback? liveToastCloseCallback;

  void _showLiveToast() {
    messageController.text = defaultMessage;
    messageNotifier.value = messageController.text;
    liveToastCloseCallback = Toast.showLive(
      messageNotifier,
      // color: color, // Just to look different
      gravity: gravity,
      dismissOnTap: dismissOnTap,
      onDismiss: (_) => setState(() => liveToastCloseCallback = null),
    );
    setState(() {}); // To notify liveToastCloseCallback != null
  }
}

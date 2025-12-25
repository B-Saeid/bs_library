import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';

class SpeedInfo extends StatelessWidget {
  const SpeedInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 10,
          children: [
             Icon(AppStyle.icons.info),
            Text('Info', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 20),
        Text('Your Internet Speed is:', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Text('123 Mbps', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 25),
        FilledButton.icon(
          icon: Icon(AppStyle.icons.reload),
          label: const Text('Refresh'),
          onPressed: () {},
        ),
      ],
    );
  }
}

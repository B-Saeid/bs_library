import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/link.dart';

import 'l10n_strings.dart';

class BottomLink extends ConsumerWidget {
  const BottomLink({
    super.key,
    required this.group,
  });

  final bool group;

  @override
  Widget build(BuildContext context, WidgetRef ref) => DefaultTextStyle.merge(
    style: Theme.of(context).textTheme.bodyMedium,
    child: Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(l10nR.tForARealWorldExample(ref)),
        FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10nR.tSeeThe(ref)),
              Link(
                uri: Uri.parse('https://ladders.bsaeid.dev/home/${group ? 'settings' : 'about'}'),
                builder: (context, followLink) => ScaleControlledText(
                  '',
                  spans: [
                    TextSpan(
                      text: group ? l10nR.tSettings(ref) : l10nR.tAbout(ref),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = followLink,
                    ),
                  ],
                ),
              ),
              Text(l10nR.tPageInThe(ref)),
              Link(
                uri: Uri.parse('https://ladders.bsaeid.dev/download'),
                builder: (context, followLink) => ScaleControlledText(
                  '',
                  spans: [
                    TextSpan(
                      text: 'Ladders',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = followLink,
                    ),
                  ],
                ),
              ),
              Text(l10nR.tApp(ref)),
            ],
          ),
        ),
      ],
    ),
  );

  // @override
  // Widget build(BuildContext context) => ScaleControlledText(
  //   'For a real world example, see the ',
  //   scale: true,
  //   spans: [
  //     TextSpan(
  //       text: '${group ? 'settings' : 'about'} page',
  //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //         color: Theme.of(context).colorScheme.primary,
  //       ),
  //       recognizer: TapGestureRecognizer()
  //         ..onTap = group
  //             ? () => UrlLauncher.httpsLink(
  //                 'https://ladders.bsaeid.dev/home/settings',
  //               )
  //             : () => UrlLauncher.httpsLink('https://ladders.bsaeid.dev/home/about'),
  //     ),
  //
  //     const TextSpan(text: ' in the '),
  //     TextSpan(
  //       text: 'Ladders app.',
  //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //         color: Theme.of(context).colorScheme.primary,
  //       ),
  //       recognizer: TapGestureRecognizer()
  //         ..onTap = () => UrlLauncher.httpsLink('https://ladders.bsaeid.dev/download'),
  //     ),
  //   ],
  // );
}

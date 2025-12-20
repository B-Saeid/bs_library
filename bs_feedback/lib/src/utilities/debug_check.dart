// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import '../l18n/translation.dart';

bool debugCheckHasFeedbackLocalizations(BuildContext context) {
  assert(
    () {
      final localizations = Localizations.of<FeedbackLocalizations>(
        context,
        FeedbackLocalizations,
      );

      if (localizations != null) return true;

      throw FlutterError.fromParts(
        <DiagnosticsNode>[
          ErrorSummary('No FeedbackLocalizations found.'),
          ErrorDescription(
            '${context.widget.runtimeType} widgets require FeedbackLocalizations '
            'to be provided by a Localizations widget ancestor.',
          ),
          ErrorDescription(
            'Localizations are used to generate many different messages, labels, '
            'and abbreviations which are used by the feedback library.',
          ),
          ...context.describeMissingAncestor(
            expectedAncestorType: FeedbackLocalizations,
          ),
        ],
      );
    }(),
  );
  return true;
}

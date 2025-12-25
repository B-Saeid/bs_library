import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../bs_widgets.dart';

class AppleListTile extends AdaptiveListTile {
  const AppleListTile({
    super.key,
    super.leading,
    required super.title,
    super.description,
    super.enabled,
    super.onPressed,
    super.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef? ref) =>
      IgnorePointer(ignoring: !enabled, child: buildContent(ref, context));

  Widget buildContent(WidgetRef? ref, BuildContext context) => CupertinoWell(
    // color: theme.themeData.tileColor,
    color: AppStyle.colors.onScaffoldBackground(ref: ref, context: context),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    borderRadius: BorderRadius.circular(12),
    pressedColor: CupertinoColors.systemGrey.resolveFrom(context).withAlpha(180),
    onPressed: onPressed,
    child: Row(
      children: [
        if (leading != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15),
            child: buildLeading(ref, context),
          ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Title & Description
                      buildTitle(ref, context),
                      if (description != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: 2.scalableFlexible(ref: ref, context: context),
                          ),
                          child: buildDescription(ref, context),
                        ),
                    ],
                  ),
                ),
              ),
              if (trailing != null) buildTrailing(ref, context),
            ],
          ),
        ),
      ],
    ),
  );

  Widget buildLeading(WidgetRef? ref, BuildContext context) => FitWithin(
    size: Size.square(32.scalableFlexible(ref: ref, context: context, maxFactor: 2)),
    alignment: AlignmentDirectional.center,
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: IconTheme.merge(
        data: IconThemeData(
          color: enabled
              ? null
              : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
        ),
        child: leading!,
      ),
    ),
  );

  Widget buildTitle(WidgetRef? ref, BuildContext context) => DefaultTextStyle.merge(
    style: LiveDataOrQuery.textTheme(ref: ref, context: context).titleMedium?.copyWith(
      color: enabled ? null : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
    ),
    child: title,
  );

  Widget buildDescription(WidgetRef? ref, BuildContext context) => DefaultTextStyle.merge(
    style: LiveDataOrQuery.textTheme(ref: ref, context: context).bodyMedium?.copyWith(
      color: enabled ? null : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
    ),
    child: description!,
  );

  Widget buildTrailing(WidgetRef? ref, BuildContext context) => IconTheme.merge(
    data: IconThemeData(
      size: 24.scalableFlexible(ref: ref, context: context, maxFactor: 1.5),
      color: enabled ? null : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
    ),
    child: trailing!,
  );
}

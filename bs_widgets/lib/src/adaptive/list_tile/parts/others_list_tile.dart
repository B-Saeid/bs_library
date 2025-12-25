import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adaptive_list_tile.dart';

class OthersListTile extends AdaptiveListTile {
  const OthersListTile({
    super.key,
    super.leading,
    required super.title,
    super.description,
    super.enabled,
    super.onPressed,
    super.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef? ref) => Padding(
    padding: const EdgeInsets.only(right: 8, left: 8, bottom: 5),
    child: IgnorePointer(
      ignoring: !enabled,
      child: Material(
        color: AppStyle.colors.onScaffoldBackground(ref: ref, context: context),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 0.5,
            style: LiveDataOrQuery.isLight(ref: ref, context: context)
                ? BorderStyle.solid
                : BorderStyle.none,
            color: Colors.grey,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          // highlightColor: theme.themeData.tileHighlightColor,
          child: Row(
            children: [
              if (leading != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  child: buildLeading(ref, context),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 15,
                    vertical: 19.scalableFlexible(ref: ref, context: context, maxValue: 25),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildTitle(ref, context),
                              if (description != null)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 4.0.scalableFlexible(
                                      ref: ref,
                                      context: context,
                                      maxValue: 8,
                                    ),
                                  ),
                                  child: buildDescription(ref, context),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (trailing != null)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 15,
                            end: 5,
                          ),
                          child: buildTrailing(ref, context),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget buildLeading(WidgetRef? ref, BuildContext context) => IconTheme.merge(
    data: LiveDataOrQuery.themeData(ref: ref, context: context).iconTheme.copyWith(
      color: enabled ? null : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
      size: 32.scalableFlexible(ref: ref, context: context, maxValue: 35),
    ),
    child: leading!,
  );

  Widget buildTitle(WidgetRef? ref, BuildContext context) => DefaultTextStyle.merge(
    style: LiveDataOrQuery.textTheme(ref: ref, context: context).titleLarge?.copyWith(
      color: enabled ? null : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
    ),
    child: title,
  );

  Widget buildDescription(WidgetRef? ref, BuildContext context) => DefaultTextStyle.merge(
    style: LiveDataOrQuery.textTheme(ref: ref, context: context).bodyLarge?.copyWith(
      color: enabled ? null : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
    ),
    child: description!,
  );

  Widget buildTrailing(WidgetRef? ref, BuildContext context) => IconTheme.merge(
    data: IconThemeData(
      size: 32.scalableFlexible(ref: ref, context: context, maxValue: 35),
      color: enabled ? null : LiveDataOrQuery.themeData(ref: ref, context: context).disabledColor,
    ),
    child: trailing!,
  );
}

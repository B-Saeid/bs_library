import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod_widgets/consumer_or_stateless.dart';

class ScaleControlledText extends ConsumerOrStatelessWidget {
  const ScaleControlledText(
    this.text, {
    super.key,
    this.spans,
    this.scale = false,
    this.style,
    this.maxSize,
    this.maxFactor,
    this.allowBelow = true,
    this.sizeWrapString,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    // @Deprecated(
    //   'Use textScaler instead. '
    //       'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
    //       'This feature was deprecated after v3.12.0-2.0.pre.',
    // )
    // double textScaleFactor = 1.0,
    // TextScaler textScaler = TextScaler.noScaling,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.selectionRegistrar,
    this.selectionColor,
  });

  final String text;
  final TextStyle? style;

  /// Set this to true to scale the text
  ///
  /// Has no effect if maxSize != null || maxFactor != null || !allowBelow
  ///
  /// defaults to false.
  final bool scale;

  final List<InlineSpan>? spans;
  final double? maxSize;
  final double? maxFactor;
  final bool allowBelow;
  final String? sizeWrapString;

  ///
  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [text] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any. If there is no ambient
  /// [Directionality], then this must not be null.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  // / Deprecated. Will be removed in a future version of Flutter. Use
  // /// [textScaler] instead.
  // ///
  // /// The number of font pixels for each logical pixel.
  // ///
  // /// For example, if the text scale factor is 1.5, text will be 50% larger than
  // /// the specified font size.
  // @Deprecated(
  //   'Use textScaler instead. '
  //       'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
  //       'This feature was deprecated after v3.12.0-2.0.pre.',
  // )
  // double get textScaleFactor => textScaler.textScaleFactor;
  //
  // /// {@macro flutter.painting.textPainter.textScaler}
  // final TextScaler textScaler;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// The [SelectionRegistrar] this rich text is subscribed to.
  ///
  /// If this is set, [selectionColor] must be non-null.
  final SelectionRegistrar? selectionRegistrar;

  /// The color to use when painting the selection.
  ///
  /// This is ignored if [selectionRegistrar] is null.
  ///
  /// See the section on selections in the [RichText] top-level API
  /// documentation for more details on enabling selection in [RichText]
  /// widgets.
  final Color? selectionColor;

  bool get shouldScale => scale || maxSize != null || maxFactor != null || !allowBelow;

  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    // final defaultStyle = LiveDataOrQuery.textTheme(ref:ref, context:context).bodyMedium!;
    final defaultStyle = DefaultTextStyle.of(context).style;

    TextStyle? scaledStyle;
    List<InlineSpan>? scaledSpans;

    if (shouldScale) {
      scaledStyle = getScaledStyle(context, ref, style ?? defaultStyle);
      if (spans != null) {
        scaledSpans = spans
            ?.map(
              (span) => (span as TextSpan).copyWith(
                style: getScaledStyle(context, ref, span.style ?? style ?? defaultStyle),
              ),
            )
            .toList();
      }
    }

    return SizedBox(
      width: sizeWrapString?.getWidth(
        scaledStyle ?? style ?? defaultStyle,
        followScale: false,
      ),

      /// Check out later - It behaves similarly todo
      // child: ExcludeSemantics(
      //   child: Text(
      //     text,
      //     style: scaledStyle ?? style ?? defaultStyle,
      //     // children: spans,
      //   ),
      // ),
      child: RichText(
        text: TextSpan(
          text: text,
          style: scaledStyle ?? style ?? defaultStyle,
          children: scaledSpans ?? spans,
        ),
        textAlign: textAlign,
        textDirection: textDirection,
        softWrap: softWrap,
        overflow: overflow,
        // textScaleFactor: textScaleFactor,
        // textScaler: TextScaler.linear(LiveDataOrQuery.scalePercentage(ref)),
        // textScaler: textScaler,
        maxLines: maxLines,
        locale: locale,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionRegistrar: selectionRegistrar,
        selectionColor: selectionColor,
      ),
    );
  }

  // double
  TextStyle getScaledStyle(BuildContext context, WidgetRef? ref, TextStyle style) {
    assert((maxSize ?? style.fontSize!) >= style.fontSize!);
    final scaledSize = style.fontSize!.scalableFlexible(
      ref: ref,
      context: context,
      maxValue: maxSize,
      maxFactor: maxFactor,
      allowBelow: allowBelow,
    );
    return style.copyWith(fontSize: scaledSize);
  }
}

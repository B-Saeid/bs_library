import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension TextSpanCopyWith on TextSpan {
  TextSpan copyWith({
    String? text,
    List<InlineSpan>? children,
    TextStyle? style,
    GestureRecognizer? recognizer,
    MouseCursor? mouseCursor,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    String? semanticsLabel,
    String? semanticsIdentifier,
    ui.Locale? locale,
    bool? spellOut,
  }) => TextSpan(
    text: text ?? this.text,
    children: children ?? this.children,
    style: style ?? this.style,
    recognizer: recognizer ?? this.recognizer,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    onEnter: onEnter ?? this.onEnter,
    onExit: onExit ?? this.onExit,
    semanticsLabel: semanticsLabel ?? this.semanticsLabel,
    semanticsIdentifier: semanticsIdentifier ?? this.semanticsIdentifier,
    locale: locale ?? this.locale,
    spellOut: spellOut ?? this.spellOut,
  );
}

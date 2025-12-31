import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AdaptiveDensity {
  /// for Material: Maps to [VisualDensity.compact]
  /// for Cupertino: Maps to [StyleSize.small]
  compact,

  /// for Material: Maps to [VisualDensity.comfortable]
  /// for Cupertino: Maps to [StyleSize.medium]
  medium,

  /// for Material: Maps to [VisualDensity.maximumDensity] in both axes
  /// for Cupertino: Maps to [StyleSize.large]
  lossless
  ;

  bool get isCompact => this == AdaptiveDensity.compact;

  VisualDensity get visualDensity => switch (this) {
    AdaptiveDensity.compact => VisualDensity.compact,
    AdaptiveDensity.medium => VisualDensity.comfortable,
    AdaptiveDensity.lossless => const VisualDensity(
      horizontal: VisualDensity.maximumDensity,
      vertical: VisualDensity.maximumDensity,
    ),
  };

  CupertinoButtonSize get sizeStyle => switch (this) {
    AdaptiveDensity.compact => CupertinoButtonSize.small,
    AdaptiveDensity.medium => CupertinoButtonSize.medium,
    AdaptiveDensity.lossless => CupertinoButtonSize.large,
  };

}

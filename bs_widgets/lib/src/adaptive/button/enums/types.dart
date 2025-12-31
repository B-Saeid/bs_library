import 'package:flutter/material.dart';

/// Type enum for [AdaptiveButton]
enum AdaptiveButtonType {
  ///   - Apple: [CupertinoButton.filled] with transparent background.
  ///   - Others:  [TextButton]
  plain,

  ///   - Apple: [CupertinoButton.filled] with greyish tint.
  ///   - Others:  [OutlinedButton]
  outlinedOrGreyed,

  ///   - Apple: [CupertinoButton.filled] with greyish tint.
  ///   - Others:  [ElevatedButton]
  elevatedOrGreyed,

  ///   - Apple: [CupertinoButton.filled] with app seed color tint.
  ///   - Others:  [OutlinedButton]
  outlinedOrTinted,

  ///   - Apple: [CupertinoButton.filled] with app seed color tint.
  ///   - Others:  [FilledButton.tonal]
  tonalOrTinted,

  ///   - Apple: [CupertinoButton.filled]
  ///   - Others:  [FilledButton]
  filled
  ;

  bool get isPlain => this == AdaptiveButtonType.plain;

  bool get isElevatedOrGreyed => this == AdaptiveButtonType.elevatedOrGreyed;

  bool get isTonalOrTinted => this == AdaptiveButtonType.tonalOrTinted;

  bool get isFilled => this == AdaptiveButtonType.filled;

  CupertinoButtonType get cType => switch (this) {
    AdaptiveButtonType.plain => CupertinoButtonType.plain,
    AdaptiveButtonType.outlinedOrGreyed => CupertinoButtonType.greyish,
    AdaptiveButtonType.elevatedOrGreyed => CupertinoButtonType.greyish,
    AdaptiveButtonType.outlinedOrTinted => CupertinoButtonType.tinted,
    AdaptiveButtonType.tonalOrTinted => CupertinoButtonType.tinted,
    AdaptiveButtonType.filled => CupertinoButtonType.filled,
  };

  MaterialButtonType get mType => switch (this) {
    AdaptiveButtonType.plain => MaterialButtonType.text,
    AdaptiveButtonType.outlinedOrGreyed => MaterialButtonType.outlined,
    AdaptiveButtonType.elevatedOrGreyed => MaterialButtonType.elevated,
    AdaptiveButtonType.outlinedOrTinted => MaterialButtonType.outlined,
    AdaptiveButtonType.tonalOrTinted => MaterialButtonType.filledTonal,
    AdaptiveButtonType.filled => MaterialButtonType.filled,
  };
}

enum CupertinoButtonType {
  /// [CupertinoButton.filled] with transparent background.
  plain,

  ///   - Apple: [CupertinoButton.filled] with greyish tint.
  greyish,

  ///   - Apple: [CupertinoButton.filled] with app seed color tint.
  tinted,

  ///   - Apple: [CupertinoButton.filled]
  filled
  ;

  bool get isPlain => this == CupertinoButtonType.plain;

  bool get isGreyish => this == CupertinoButtonType.greyish;

  bool get isTinted => this == CupertinoButtonType.tinted;

  bool get isFilled => this == CupertinoButtonType.filled;
}

enum MaterialButtonType {
  text,
  outlined,
  elevated,
  filledTonal,
  filled
  ;

  bool get isText => this == MaterialButtonType.text;

  bool get isOutlined => this == MaterialButtonType.outlined;

  bool get isElevated => this == MaterialButtonType.elevated;

  bool get isFilledTonal => this == MaterialButtonType.filledTonal;

  bool get isFilled => this == MaterialButtonType.filled;
}

/// Type enum for [AdaptiveIconButton]
enum AdaptiveIconButtonType {
  ///   - Apple: [CupertinoButton.filled] with transparent background.
  ///   - Others:  [IconButton]
  plain,

  ///   - Apple: Crafted [CupertinoButton] with outline
  ///   - Others:  [IconButton.outlined]
  outlined,

  ///   - Apple: [CupertinoButton.filled] with app seed color tint.
  ///   - Others:  [IconButton.filledTonal]
  tinted,

  ///   - Apple: [CupertinoButton.filled]
  ///   - Others:  [IconButton.filled]
  filled
  ;

  bool get isPlain => this == AdaptiveIconButtonType.plain;

  bool get isOutlined => this == AdaptiveIconButtonType.outlined;

  bool get isTinted => this == AdaptiveIconButtonType.tinted;

  bool get isFilled => this == AdaptiveIconButtonType.filled;
}

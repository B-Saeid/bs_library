import 'package:flutter/material.dart';

class AdaptiveTilesTheme extends InheritedWidget {
  const AdaptiveTilesTheme({
    super.key,
    required this.themeData,
    required this.platform,
    required super.child,
  });

  final AdaptiveTilesThemeData themeData;
  final TargetPlatform platform;

  static AdaptiveTilesTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AdaptiveTilesTheme>();

  @override
  bool updateShouldNotify(covariant AdaptiveTilesTheme oldWidget) => true;
}

// class AdaptiveTilesTheme {
//   const AdaptiveTilesTheme({
//     required this.themeData,
//     required this.platform,
//   });
//
//   final AdaptiveTilesThemeData themeData;
//   final TargetPlatform platform;
// }

class AdaptiveTilesThemeData {
  const AdaptiveTilesThemeData({
    this.iOSTilesGroupMargin,
    this.constraints,
    this.trailingTextColor,
    // this.settingsListBackground,
    this.tileColor,
    this.dividerColor,
    this.tileHighlightColor,
    this.titleTextColor,
    this.leadingIconsColor,
    this.tileDescriptionTextColor,
    this.inactiveTitleColor,
    this.inactiveSubtitleColor,
  });

  /// This is only for iOS.
  /// default is: Cupertino Specific margin
  final EdgeInsets? iOSTilesGroupMargin;
  final BoxConstraints? constraints;

  // final Color? settingsListBackground;
  final Color? trailingTextColor;
  final Color? leadingIconsColor;
  final Color? tileColor;
  final Color? dividerColor;
  final Color? tileDescriptionTextColor;
  final Color? tileHighlightColor;
  final Color? titleTextColor;
  final Color? inactiveTitleColor;
  final Color? inactiveSubtitleColor;

  AdaptiveTilesThemeData merge([AdaptiveTilesThemeData? theme]) {
    if (theme == null) return this;

    return copyWith(
      iOSTilesGroupMargin: theme.iOSTilesGroupMargin,
      constraints: theme.constraints,
      leadingIconsColor: theme.leadingIconsColor,
      tileDescriptionTextColor: theme.tileDescriptionTextColor,
      dividerColor: theme.dividerColor,
      trailingTextColor: theme.trailingTextColor,
      // settingsListBackground: theme.settingsListBackground,
      tileColor: theme.tileColor,
      tileHighlightColor: theme.tileHighlightColor,
      titleTextColor: theme.titleTextColor,
      inactiveTitleColor: theme.inactiveTitleColor,
      inactiveSubtitleColor: theme.inactiveSubtitleColor,
    );
  }

  AdaptiveTilesThemeData copyWith({
    EdgeInsets? iOSTilesGroupMargin,
    BoxConstraints? constraints,
    // Color? settingsListBackground,
    Color? trailingTextColor,
    Color? leadingIconsColor,
    Color? tileColor,
    Color? dividerColor,
    Color? tileDescriptionTextColor,
    Color? tileHighlightColor,
    Color? titleTextColor,
    Color? inactiveTitleColor,
    Color? inactiveSubtitleColor,
  }) {
    return AdaptiveTilesThemeData(
      iOSTilesGroupMargin: iOSTilesGroupMargin ?? this.iOSTilesGroupMargin,
      constraints: constraints ?? this.constraints,
      // settingsListBackground: settingsListBackground ?? this.settingsListBackground,
      trailingTextColor: trailingTextColor ?? this.trailingTextColor,
      leadingIconsColor: leadingIconsColor ?? this.leadingIconsColor,
      tileColor: tileColor ?? this.tileColor,
      dividerColor: dividerColor ?? this.dividerColor,
      tileDescriptionTextColor: tileDescriptionTextColor ?? this.tileDescriptionTextColor,
      tileHighlightColor: tileHighlightColor ?? this.tileHighlightColor,
      titleTextColor: titleTextColor ?? this.titleTextColor,
      inactiveTitleColor: inactiveTitleColor ?? this.inactiveTitleColor,
      inactiveSubtitleColor: inactiveSubtitleColor ?? this.inactiveSubtitleColor,
    );
  }
}

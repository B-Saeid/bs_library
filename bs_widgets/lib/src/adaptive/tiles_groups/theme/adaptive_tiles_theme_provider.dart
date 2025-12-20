// import 'package:flutter/material.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// import '../../../../../../Shared/Utilities/device_platform.dart';
// import '../../../Utilities/SessionData/session_data.dart';
// import 'adaptive_tiles_theme.dart' as tiles_theme;
// import 'adaptive_tiles_theme_helper.dart';
//
// part 'adaptive_tiles_theme_provider.g.dart';
//
// @protected
// @riverpod
// class AdaptiveTilesTheme extends _$AdaptiveTilesTheme {
//   @override
//   tiles_theme.AdaptiveTilesTheme build() {
//     final defaultTheme = AdaptiveTilesThemeHelper.getTheme(
//       platform: StaticData.platform,
//       isLight: ref.watch(liveDataProvider).isLight,
//     );
//
//     return tiles_theme.AdaptiveTilesTheme(
//       themeData: defaultTheme,
//       platform: DevicePlatform.fromIO,
//     );
//   }
//
//   void setTheme({
//     required tiles_theme.AdaptiveTilesThemeData themeData,
//     required DevicePlatform platform,
//   }) =>
//       state = tiles_theme.AdaptiveTilesTheme(
//         themeData: themeData,
//         platform: platform,
//       );
// }

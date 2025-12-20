import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/fa.dart';
import 'package:iconify_flutter/icons/game_icons.dart';

import 'overridden_icons.dart';

/// Make sure you are explicitly setting it correctly
final class AdaptiveIcons {
  const AdaptiveIcons._();

  @internal
  static final instance = const AdaptiveIcons._();

  bool get isApple => StaticData.platform.isApple;

  Color _adaptiveColor([WidgetRef? ref]) =>
      (ref != null ? LiveData.isLight(ref) : StaticData.isLight) ? Colors.black : Colors.white;

  Widget wGoogleLogo({double? size}) => Iconify(
    Logos.google_icon,
    size: size ?? 25,
  );

  Widget wAppleLogo({WidgetRef? ref, Color? color, double? size}) => SizedBox.square(
    dimension: size ?? 25,
    child: Iconify(
      Logos.apple,
      color: color ?? _adaptiveColor(ref),
      size: size ?? 25,
    ),
  );

  Widget wSandTimer({WidgetRef? ref, Color? color, double? size}) => Iconify(
    GameIcons.sands_of_time,
    color: color ?? _adaptiveColor(ref),
    size: size,
  );

  //  Widget wTraining({WidgetRef? ref, Color? color, double? size}) => Iconify(
  //       GameIcons.weight_lifting_up,
  //       color: color ?? _adaptiveColor(ref),
  //       size: size,
  //     );
  //
  //  Widget wFlatBar({WidgetRef? ref, Color? color, double? size}) => Iconify(
  //       Ion.ios_fitness,
  //       color: color ?? _adaptiveColor(ref),
  //       size: size,
  //     );
  //
  //  Widget wResting({WidgetRef? ref, Color? color, double? size}) => Iconify(
  //       GameIcons.weight_lifting_down,
  //       color: color ?? _adaptiveColor(ref),
  //       size: size,
  //     );

  Widget wCardList({WidgetRef? ref, Color? color, double? size}) => Iconify(
    Bi.card_list,
    size: size ?? 32,
    color: color ?? _adaptiveColor(ref),
  );

  Widget wCardHeading({WidgetRef? ref, Color? color, double? size}) => Iconify(
    Bi.card_heading,
    size: size ?? 32,
    color: color ?? _adaptiveColor(ref),
  );

  Widget wDrivingLicenseOutline({WidgetRef? ref, Color? color, double? size}) => Iconify(
    Fa.drivers_license_o,
    color: color ?? _adaptiveColor(ref),
    size: size,
  );

  Widget wDrivingLicense({WidgetRef? ref, Color? color, double? size}) => Iconify(
    Fa.drivers_license,
    size: size ?? 32,
    color: color ?? _adaptiveColor(ref),
  );

  // Widget wSpeakingHead({WidgetRef? ref, Color? color, double? size}) => Iconify(
  //       // EmojioneMonotone.speaking_head,
  //       FluentEmojiHighContrast.speaking_head,
  //       size: size ?? 32,
  //       color: color ?? _adaptiveColor(ref),
  //     );

  IconData get home => isApple ? CupertinoIcons.home : Icons.home_rounded;

  IconData get calender => isApple ? CupertinoIcons.calendar_today : Icons.today_rounded;

  IconData get clock => isApple ? CupertinoIcons.clock : Icons.watch_later_outlined;

  IconData get duration => isApple ? CupertinoIcons.stopwatch_fill : Icons.timer_rounded;

  IconData get timeLapsed => CupertinoIcons.timer_fill;

  IconData get score => CupertinoIcons.number_circle_fill;

  IconData get star => isApple ? CupertinoIcons.star_fill : Icons.star_rounded;

  IconData get halfStar =>
      isApple ? OverriddenIcons.star_lefthalf_fill : OverriddenIcons.star_half_rounded;

  IconData get halfStarTD =>
      isApple ? OverriddenIcons.star_lefthalf_fill_TD : OverriddenIcons.star_half_rounded_TD;

  IconData get emptyStar => isApple ? CupertinoIcons.star : Icons.star_border_rounded;

  IconData get globe => isApple ? CupertinoIcons.globe : Icons.language_rounded;

  IconData get info => isApple ? CupertinoIcons.info_circle : Icons.info_outline_rounded;

  IconData get settings => isApple ? CupertinoIcons.settings : Icons.settings;

  IconData get send => isApple ? CupertinoIcons.arrow_up_circle_fill : Icons.send_rounded;

  IconData get check => isApple ? CupertinoIcons.check_mark : Icons.check;

  IconData get upload => isApple ? CupertinoIcons.arrow_up_circle_fill : Icons.upload_rounded;

  IconData get draw => isApple ? CupertinoIcons.pencil_outline : Icons.draw_rounded;

  IconData get pen => isApple ? CupertinoIcons.pen : Icons.edit_rounded;

  IconData get feedback =>
      isApple ? CupertinoIcons.exclamationmark_bubble_fill : Icons.feedback_rounded;

  IconData get undo => isApple ? CupertinoIcons.arrow_counterclockwise_circle_fill : Icons.undo;

  IconData get list => isApple ? CupertinoIcons.square_list_fill : Icons.list_alt_rounded;

  IconData get circle => isApple ? CupertinoIcons.circle : Icons.circle_outlined;

  IconData get circleFill => isApple ? CupertinoIcons.circle_filled : Icons.circle_rounded;

  IconData get checkFilled =>
      isApple ? CupertinoIcons.check_mark_circled_solid : Icons.check_circle;

  IconData get checkShieldFilled => CupertinoIcons.checkmark_shield_fill;

  IconData get share => isApple ? CupertinoIcons.share : Icons.share_rounded;

  IconData get search => isApple ? CupertinoIcons.search : Icons.search_rounded;

  IconData get pin => isApple ? CupertinoIcons.delete : Icons.delete_rounded;

  IconData get report => isApple ? CupertinoIcons.exclamationmark_circle_fill : Icons.report;

  IconData get reload => isApple ? CupertinoIcons.refresh_circled_solid : Icons.refresh_rounded;

  IconData get reset => isApple ? CupertinoIcons.gobackward : Icons.settings_backup_restore_rounded;

  IconData get startingArrow =>
      isApple ? CupertinoIcons.arrow_right_to_line_alt : Icons.start_rounded;

  IconData get gridView => isApple ? CupertinoIcons.square_grid_2x2_fill : Icons.grid_view_rounded;

  IconData get headSet => isApple ? CupertinoIcons.headphones : Icons.headset_mic_rounded;

  IconData get theme => isApple ? CupertinoIcons.circle_righthalf_fill : Icons.contrast_rounded;

  IconData get light => isApple ? CupertinoIcons.sun_min_fill : Icons.light_mode_rounded;

  IconData get dark => isApple ? CupertinoIcons.moon_fill : Icons.dark_mode_rounded;

  IconData get plus => isApple ? CupertinoIcons.add : Icons.add_rounded;

  IconData get plusOutlined =>
      isApple ? CupertinoIcons.add_circled : Icons.add_circle_outline_rounded;

  IconData get plusFilled => isApple ? CupertinoIcons.add_circled_solid : Icons.add_circle_rounded;

  IconData get minus => isApple ? CupertinoIcons.minus : Icons.remove;

  IconData get minusOutlined =>
      isApple ? CupertinoIcons.minus_circle : Icons.remove_circle_outline_rounded;

  IconData get minusFilled =>
      isApple ? CupertinoIcons.minus_circle_fill : Icons.remove_circle_rounded;

  IconData get doubleArrowRight =>
      isApple ? CupertinoIcons.chevron_right_2 : Icons.double_arrow_rounded;

  IconData get bolt => isApple ? CupertinoIcons.bolt_fill : Icons.bolt_rounded;

  IconData get arrowUp => isApple ? CupertinoIcons.chevron_up : Icons.keyboard_arrow_up_rounded;

  IconData get arrowDown =>
      isApple ? CupertinoIcons.chevron_down : Icons.keyboard_arrow_down_rounded;

  IconData get arrowRight =>
      isApple ? OverriddenIcons.chevron_right : OverriddenIcons.chevron_right_rounded;

  /// TD: Text Direction. Stays left if [Directionality] is LTR i.e. Same as [arrowRight]
  /// but in case of RTL it is mirrored to be left same as [arrowLeft]
  IconData get arrowRightTD =>
      isApple ? OverriddenIcons.chevron_right_TD : OverriddenIcons.chevron_right_rounded_TD;

  IconData get arrowLeft =>
      isApple ? OverriddenIcons.chevron_left : OverriddenIcons.chevron_left_rounded;

  /// TD: Text Direction. Stays left if [Directionality] is LTR i.e. Same as [arrowLeft]
  /// but in case of RTL it is mirrored to be right same as [arrowRight]
  IconData get arrowLeftTD =>
      isApple ? OverriddenIcons.chevron_left_TD : OverriddenIcons.chevron_left_rounded_TD;

  IconData get rtlArrow => CupertinoIcons.arrow_left_square_fill;

  IconData get ltrArrow => CupertinoIcons.arrow_right_square_fill;

  IconData get reply => isApple ? CupertinoIcons.reply : Icons.reply;

  IconData get copy => isApple ? CupertinoIcons.doc_on_doc_fill : Icons.copy_rounded;

  IconData get pause => isApple ? CupertinoIcons.pause : Icons.pause_rounded;

  IconData get play => isApple ? CupertinoIcons.play_fill : Icons.play_arrow_rounded;

  IconData get stop => isApple ? CupertinoIcons.stop_fill : Icons.stop_rounded;

  IconData get photo => isApple ? CupertinoIcons.photo_fill : Icons.photo_rounded;

  IconData get camera => isApple ? CupertinoIcons.camera_fill : Icons.camera_alt_rounded;

  IconData get speaker => isApple ? CupertinoIcons.speaker_2_fill : Icons.volume_up_rounded;

  IconData get microphone => isApple ? CupertinoIcons.mic_fill : Icons.mic_rounded;

  IconData get microphoneCircle => CupertinoIcons.mic_circle_fill;

  IconData get microphoneOutlined => isApple ? CupertinoIcons.mic : Icons.mic_none_rounded;

  IconData get microphoneMuted => isApple ? CupertinoIcons.mic_slash_fill : Icons.mic_off_rounded;

  IconData get speakWave => CupertinoIcons.waveform_circle_fill;

  IconData get oneTwoThree => Icons.onetwothree_rounded;

  IconData get close => isApple ? CupertinoIcons.clear : Icons.close_rounded;

  IconData get clear => isApple ? CupertinoIcons.clear_circled_solid : Icons.clear_rounded;

  IconData get email => isApple ? CupertinoIcons.mail_solid : Icons.email_rounded;

  IconData get call => isApple ? CupertinoIcons.phone_fill : Icons.call_rounded;

  IconData get sms => isApple ? CupertinoIcons.text_bubble_fill : Icons.sms_rounded;

  IconData get phone =>
      isApple ? CupertinoIcons.device_phone_portrait : Icons.phone_android_rounded;

  IconData get person => isApple ? CupertinoIcons.person_fill : Icons.person_rounded;

  IconData get lock => isApple ? CupertinoIcons.lock_fill : Icons.lock_rounded;

  IconData get eye => isApple ? CupertinoIcons.eye_fill : Icons.visibility_rounded;

  IconData get eyeSlash => isApple ? CupertinoIcons.eye_slash_fill : Icons.visibility_off_rounded;

  IconData get fire => isApple ? CupertinoIcons.flame_fill : Icons.local_fire_department_rounded;

  IconData get power => isApple ? CupertinoIcons.power : Icons.power_settings_new_rounded;

  IconData get downloadFile =>
      isApple ? CupertinoIcons.arrow_down_doc_fill : Icons.file_download_rounded;

  IconData get download => isApple ? CupertinoIcons.arrow_down_circle_fill : Icons.download_rounded;

  IconData get downloadSquare =>
      isApple ? CupertinoIcons.arrow_down_square_fill : Icons.file_download_outlined;

  IconData get openLink =>
      isApple ? CupertinoIcons.arrow_up_right_square_fill : Icons.open_in_new_rounded;
}

/// This was commented out, when testing on web and is replaced with [OverriddenIcons]
/// Reason: When using non-constant Constructor of [IconData] It is not possible to
/// tree-shake the icons fonts like MaterialIconsFont, CupertinoIconsFont and others.
///
/// We do need that compression so we implemented an alternative.
// extension on IconData {
//   IconData copyWith({
//     int? codePoint,
//     String? fontFamily,
//     String? fontPackage,
//     bool? matchTextDirection,
//     List<String>? fontFamilyFallback,
//   }) =>
//       IconData(
//         codePoint ?? this.codePoint,
//         fontFamily: fontFamily ?? this.fontFamily,
//         fontPackage: fontPackage ?? this.fontPackage,
//         matchTextDirection: matchTextDirection ?? this.matchTextDirection,
//         fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
//       );
// }

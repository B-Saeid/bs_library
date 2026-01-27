import 'package:bs_l10n/bs_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AdaptiveListTilesExampleL10n on L10nR {
  String tStandard([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Standard',
    SupportedLocale.ar => 'الأساسي',
  };

  String tDescription([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Description',
    SupportedLocale.ar => 'الوصف',
  };

  String tValue([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Value',
    SupportedLocale.ar => 'قيمة',
  };

  String tNavigation([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Navigation',
    SupportedLocale.ar => 'التنقل',
  };

  String tSwitch([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Switch',
    SupportedLocale.ar => 'التبديل',
  };

  String tTitle([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Title',
    SupportedLocale.ar => 'العنوان',
  };

  String tBasic([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Basic',
    SupportedLocale.ar => 'فردي',
  };

  String tAdaptiveListTileTooltip([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Generic AdaptiveListTile',
    SupportedLocale.ar => 'عنصر القائمة المتكيف العام',
  };

  String tGroup([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Group',
    SupportedLocale.ar => 'مُجمّع',
  };

  String tAdaptiveTilesGroupTooltip([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'AdaptiveTilesGroup that uses AdaptiveTile (Setting-Like)',
    SupportedLocale.ar => 'مجموعة عناصر القائمة التي تستخدم العنصر المتكيف (مثالي للإعدادات)',
  };

  String tEnabled([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Enabled',
    SupportedLocale.ar => 'مُفعّل',
  };

  String tLoading([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Loading',
    SupportedLocale.ar => 'جاري التحميل',
  };

  String tOnPressed([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'OnPressed',
    SupportedLocale.ar => 'قابل للضغط',
  };

  String tShow([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Show',
    SupportedLocale.ar => 'عرض',
  };

  String tGroupTitle([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Group Title',
    SupportedLocale.ar => 'عنوان المجموعة',
  };

  String tLeading([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Leading',
    SupportedLocale.ar => 'المقدمة',
  };

  String tTrailing([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Trailing',
    SupportedLocale.ar => 'النهاية',
  };

  String tAndroid([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'android',
    SupportedLocale.ar => 'أندرويد',
  };

  String tAndroidNavTileTooltip([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'I meant it. No trailing arrows for android by design.',
    SupportedLocale.ar => 'هذا مقصود. لا يوجد سهم في نهاية عنصر التنقل في تصميم أندرويد.',
  };

  String tIOSMacOS([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'iOS & macOS',
    SupportedLocale.ar => 'أيفون و ماك',
  };

  String tDesktopWeb([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'Desktop & Web',
    SupportedLocale.ar => 'الحاسوب و الويب',
  };

  String tForARealWorldExample([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'For a real world example, ',
    SupportedLocale.ar => 'من أجل مثال حقيقي، ',
  };

  String tSeeThe([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'see the ',
    SupportedLocale.ar => 'ألق نظرة على صفحة ',
  };

  String tSettings([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'settings',
    SupportedLocale.ar => 'الإعدادات',
  };

  String tAbout([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => 'about',
    SupportedLocale.ar => 'عن التطبيق',
  };

  String tPageInThe([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => ' page in the ',
    SupportedLocale.ar => ' في تطبيق ',
  };

  String tApp([WidgetRef? ref]) => switch (l10nR.currentLocale(ref)) {
    SupportedLocale.en => ' app.',
    SupportedLocale.ar => '.',
  };
}

import 'package:bs_internet_service/bs_internet_service.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_toast/bs_toast.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdaptiveButtonsPage extends StatefulWidget {
  const AdaptiveButtonsPage({super.key});

  static String title = 'Adaptive Buttons';

  @override
  State<AdaptiveButtonsPage> createState() => _AdaptiveButtonsPageState();
}

class _AdaptiveButtonsPageState extends State<AdaptiveButtonsPage> {
  bool actionable = true;
  bool hidden = false;
  bool loadingIndicator = false;
  bool requireInternet = false;
  Color? seedColor;

  @override
  void initState() {
    super.initState();

    /// Because by default internet will not be checked on web
    if (kIsWeb) Internet.updateCheckerConfig(forceCheckOnWeb: true);
  }

  void _onPressed(String typeMessage) =>
      Toast.showSuccess('$typeMessage onPressed', priority: BsPriority.now);

  void _onLongPressed(String typeMessage) =>
      Toast.showSuccess('$typeMessage onLongPressed', priority: BsPriority.now);

  IconData _getIcon({
    MaterialButtonType? mType,
    CupertinoButtonType? cType,
    AdaptiveIconButtonType? iType,
    bool? isMaterial,
  }) {
    if (mType != null) {
      return switch (mType) {
        MaterialButtonType.text => _icons(TargetPlatform.android)[0],
        MaterialButtonType.outlined => _icons(TargetPlatform.android)[1],
        MaterialButtonType.elevated => _icons(TargetPlatform.android)[2],
        MaterialButtonType.filledTonal => _icons(TargetPlatform.android)[3],
        MaterialButtonType.filled => _icons(TargetPlatform.android)[4],
      };
    } else if (cType != null) {
      return switch (cType) {
        CupertinoButtonType.plain => _icons(TargetPlatform.iOS)[0],
        CupertinoButtonType.greyish => _icons(TargetPlatform.iOS)[2],
        CupertinoButtonType.tinted => _icons(TargetPlatform.iOS)[3],
        CupertinoButtonType.filled => _icons(TargetPlatform.iOS)[4],
      };
    } else if (iType != null) {
      final platform = isMaterial! ? TargetPlatform.android : TargetPlatform.iOS;
      return switch (iType) {
        AdaptiveIconButtonType.plain => _icons(platform)[0],
        AdaptiveIconButtonType.outlined => _icons(platform)[1],
        AdaptiveIconButtonType.tinted => _icons(platform)[3],
        AdaptiveIconButtonType.filled => _icons(platform)[4],
      };
    }
    return AppStyle.icons.home;
  }

  List<IconData> _icons(TargetPlatform platform) => [
    AppStyle.iconsOfPlatform(platform).home,
    AppStyle.iconsOfPlatform(platform).photo,
    AppStyle.iconsOfPlatform(platform).share,
    AppStyle.iconsOfPlatform(platform).camera,
    AppStyle.iconsOfPlatform(platform).microphone,
  ];

  Iterable<Widget> _getButtons({
    required bool isMaterial,
    required bool basic,
    required bool withIcon,
  }) => isMaterial
      ? MaterialButtonType.values.map(
          (mType) {
            final nameCapitalized = mType.name.capitalize();
            return basic
                ? AdaptiveButton(
                    materialType: mType,
                    platform: TargetPlatform.android,
                    icon: withIcon ? Icon(_getIcon(mType: mType)) : null,
                    child: nameCapitalized,
                    onPressed: () => _onPressed(
                      'Basic Material $nameCapitalized${withIcon ? ' with icon' : ''}',
                    ),
                    onLongPressed: () => _onLongPressed(
                      'Basic Material $nameCapitalized${withIcon ? ' with icon' : ''}',
                    ),
                    actionable: actionable,
                    hidden: hidden,
                    loadingIndicator: loadingIndicator,
                    requireInternet: requireInternet,
                    colorSchemeSeed: seedColor,
                  )
                : AdaptiveButton.custom(
                    // takes precedence over [type]
                    materialType: mType,
                    // overridden to show a material button
                    platform: TargetPlatform.android,
                    icon: withIcon ? Icon(_getIcon(mType: mType)) : null,
                    child: nameCapitalized,
                    onPressed: () => _onPressed(
                      'Custom Material $nameCapitalized${withIcon ? ' with icon' : ''}',
                    ),
                    onLongPressed: () => _onLongPressed(
                      'Custom Material $nameCapitalized${withIcon ? ' with icon' : ''}',
                    ),
                    actionable: actionable,
                    hidden: hidden,
                    loadingIndicator: loadingIndicator,
                    requireInternet: requireInternet,
                    colorSchemeSeed: seedColor,
                  );
          },
        )
      : CupertinoButtonType.values.map(
          (cType) {
            final nameCapitalized = cType.name.capitalize();
            return basic
                ? AdaptiveButton(
                    cupertinoType: cType,
                    platform: TargetPlatform.iOS,
                    icon: withIcon ? Icon(_getIcon(cType: cType)) : null,
                    child: nameCapitalized,
                    onPressed: () => _onPressed(
                      'Basic Cupertino $nameCapitalized${withIcon ? ' with icon' : ''}',
                    ),
                    onLongPressed: () => _onLongPressed(
                      'Basic Cupertino $nameCapitalized${withIcon ? ' with icon' : ''}',
                    ),
                    actionable: actionable,
                    hidden: hidden,
                    loadingIndicator: loadingIndicator,
                    requireInternet: requireInternet,
                    colorSchemeSeed: seedColor,
                  )
                : AdaptiveButton.custom(
                    cupertinoType: cType,
                    // takes precedence over [type]
                    platform: TargetPlatform.iOS,
                    // overridden to show a cupertino button
                    icon: withIcon ? Icon(_getIcon(cType: cType)) : null,
                    child: nameCapitalized,
                    onPressed: () => _onPressed(
                      'Custom Cupertino $nameCapitalized${withIcon ? ' with icon' : ''}',
                    ),
                    onLongPressed: () => _onLongPressed(
                      'Custom Cupertino $nameCapitalized${withIcon ? ' with icon' : ''}',
                    ),
                    actionable: actionable,
                    hidden: hidden,
                    loadingIndicator: loadingIndicator,
                    requireInternet: requireInternet,
                    colorSchemeSeed: seedColor,
                  );
          },
        );

  Iterable<Widget> _getIconButtons({required bool isMaterial}) => AdaptiveIconButtonType.values.map(
    (type) => AdaptiveIconButton(
      type: type,

      /// Note: `dimension` and `padding` are hard coded here to make the Cupertino version
      /// look almost exactly like the material one. This is not advisable. it is only done for
      /// the demo purpose.
      dimension: 40,
      padding: EdgeInsets.zero,
      //
      iconData: _getIcon(isMaterial: isMaterial, iType: type),
      platform: isMaterial ? TargetPlatform.android : TargetPlatform.iOS,
      onPressed: () =>
          _onPressed('Icon${isMaterial ? ' Material' : ' Cupertino'} ${type.name.capitalize()}'),
      onLongPressed: () => _onLongPressed(
        'Icon${isMaterial ? ' Material' : ' Cupertino'} ${type.name.capitalize()}',
      ),
      actionable: actionable,
      hidden: hidden,
      loadingIndicator: loadingIndicator,
      requireInternet: requireInternet,
      colorSchemeSeed: seedColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget comparison(Iterable<Widget> first, Iterable<Widget> second) => Column(
      spacing: 25,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 30,
          children: [
            Column(
              spacing: 18,
              children: [...first],
            ),
            Column(
              spacing: 18,
              children: [...second],
            ),
          ],
        ),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: Text(
                      'Material V.S. Cupertino',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Tooltip(
                  message:
                      'Unlike OutlinedButton, IconButton.outlined does have a similar peer in Cupertino.',
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    minWidth: 100,
                    minHeight: 32.0,
                  ),
                  textAlign: TextAlign.center,
                  child: Icon(AppStyle.icons.info),
                ),
              ],
            ),
            const SizedBox(height: 25),

            /// Basic Buttons
            Wrap(
              spacing: 100,
              runSpacing: 100,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                /// Standard
                comparison(
                  _getButtons(isMaterial: true, basic: true, withIcon: false),
                  _getButtons(isMaterial: false, basic: true, withIcon: false),
                ),

                /// With Icon
                comparison(
                  _getButtons(isMaterial: true, basic: true, withIcon: true),
                  _getButtons(isMaterial: false, basic: true, withIcon: true),
                ),

                /// Icon Buttons
                comparison(
                  _getIconButtons(isMaterial: true),
                  _getIconButtons(isMaterial: false),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    ChoiceChip(
                      label: const Text('Actionable'),
                      selected: actionable,
                      onSelected: (value) => setState(() => actionable = value),
                      tooltip: 'Master Switch for Enabling/Disabling The Button',
                    ),
                    ChoiceChip(
                      label: const Text('Hidden'),
                      selected: hidden,
                      onSelected: (value) => setState(() => hidden = value),
                      tooltip: 'Size and Position is Maintained Either Way',
                    ),
                    ChoiceChip(
                      label: const Text('Loading Indicator'),
                      selected: loadingIndicator,
                      onSelected: (value) => setState(() => loadingIndicator = value),
                      tooltip: 'Size and Position is Maintained Either Way',
                    ),
                    ChoiceChip(
                      label: const Text('Require Internet'),
                      tooltip:
                          'When Enabled, Buttons Will Only Work When Connected (continuously checking)',
                      selected: requireInternet,
                      onSelected: (value) => setState(() => requireInternet = value),
                    ),
                    ChoiceChip(
                      label: const Text('Seed Color'),
                      selected: seedColor != null,
                      onSelected: (value) =>
                          setState(() => value ? seedColor = Colors.blue : seedColor = null),
                      tooltip: 'Changes The ColorScheme of The Button',
                    ),
                  ],
                ),
              ),
            ),
            CustomAnimatedSize(
              child: seedColor != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: HueSlider(
                          activeColor: seedColor!,
                          onChanged: (value) => setState(() => seedColor = value),
                        ),
                      ),
                    )
                  : const SizedBox(height: 25),
            ),

            /// Custom Buttons
            Wrap(
              spacing: 100,
              runSpacing: 100,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                /// Standard
                comparison(
                  _getButtons(isMaterial: true, basic: false, withIcon: false),
                  _getButtons(isMaterial: false, basic: false, withIcon: false),
                ),

                /// With Icon
                comparison(
                  _getButtons(isMaterial: true, basic: false, withIcon: true),
                  _getButtons(isMaterial: false, basic: false, withIcon: true),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:bs_widgets/bs_widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
// Only For Example Localization
// we are using bs_l10n package which requires flutter_riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bottom_link.dart';
import 'l10n_strings.dart';
import 'tile_in_group.dart';

class TilesPage extends StatelessWidget {
  const TilesPage({super.key});

  static String title = 'Adaptive List Tiles';

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Center(
      child: Column(
        children: [
          SizedBox(height: 100),
          TilesExample(),
          SizedBox(height: 100),
        ],
      ),
    ),
  );
}

class TilesExample extends ConsumerStatefulWidget {
  const TilesExample({super.key});

  @override
  ConsumerState<TilesExample> createState() => _TilesExampleState();
}

class _TilesExampleState extends ConsumerState<TilesExample> {
  bool group = false;
  bool showGroupTitle = false;
  bool enabled = true;
  bool loading = false;
  bool on = true;
  bool onPressed = true;

  bool showLeading = true;
  bool showDescription = true;
  (bool, bool, bool) descriptionIndices = (false, false, true);
  (bool, bool, bool) valueIndices = (true, true, false);
  bool showTrailing = true;
  bool showValue = true;

  AdaptiveIcons adaptiveIcons(bool isMaterial) =>
      AppStyle.iconsOfPlatform(isMaterial ? TargetPlatform.android : TargetPlatform.iOS);

  List<(IconData?, String, String?, String?)> _placeHolders({
    required bool isMaterial,
    bool group = false,
  }) => group
      ? [
          (
            showLeading ? adaptiveIcons(isMaterial).person : null,
            l10nR.tStandard(ref),
            showDescription && descriptionIndices.$1 ? l10nR.tDescription(ref) : null,
            showValue && valueIndices.$1 ? l10nR.tValue(ref) : null,
          ),
          (
            showLeading ? adaptiveIcons(isMaterial).settings : null,
            l10nR.tNavigation(ref),
            showDescription && descriptionIndices.$2 ? l10nR.tDescription(ref) : null,
            showValue && valueIndices.$2 ? l10nR.tValue(ref) : null,
          ),
          (
            showLeading ? adaptiveIcons(isMaterial).camera : null,
            l10nR.tSwitch(ref),
            showDescription && descriptionIndices.$3 ? l10nR.tDescription(ref) : null,
            showValue && valueIndices.$3 ? l10nR.tValue(ref) : null,
          ),
        ]
      : [
          (
            showLeading ? adaptiveIcons(isMaterial).home : null,
            l10nR.tTitle(ref),
            showDescription ? l10nR.tDescription(ref) : null,
            showValue ? l10nR.tValue(ref) : null, // unused
          ),
        ];

  IconData trailingIcon(bool isMaterial) => adaptiveIcons(isMaterial).info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 25,
          children: [
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: CustomAnimatedSize(
                  child: Column(
                    spacing: 15,
                    children: [
                      SegmentedButton(
                        showSelectedIcon: false,
                        onSelectionChanged: (value) => setState(() => group = value.contains(1)),
                        segments: [
                          ButtonSegment(
                            value: 0,
                            label: Text(l10nR.tBasic(ref)),
                            tooltip: l10nR.tAdaptiveListTileTooltip(ref),
                          ),
                          ButtonSegment(
                            value: 1,
                            label: Text(l10nR.tGroup(ref)),
                            tooltip: l10nR.tAdaptiveTilesGroupTooltip(ref),
                          ),
                        ],
                        selected: group ? {1} : {0},
                      ),
                      // ChoiceChip(
                      //   label: Text(l10nR.tGroup(ref),
                      //   selected: group,
                      //   onSelected: (value) => setState(() => group = value),
                      // ),
                      ChoiceChip(
                        label: Text(l10nR.tEnabled(ref)),
                        selected: enabled,
                        onSelected: (value) => setState(() => enabled = value),
                      ),
                      if (group)
                        ChoiceChip(
                          label: Text(l10nR.tLoading(ref)),
                          selected: loading,
                          onSelected: (value) => setState(() => loading = value),
                        ),
                      ChoiceChip(
                        label: Text(l10nR.tOnPressed(ref)),
                        selected: onPressed,
                        onSelected: (value) => setState(() => onPressed = value),
                      ),
                      Text(l10nR.tShow(ref), style: Theme.of(context).textTheme.titleLarge),
                      if (group)
                        ChoiceChip(
                          label: Text(l10nR.tGroupTitle(ref)),
                          selected: showGroupTitle,
                          onSelected: (value) => setState(() => showGroupTitle = value),
                        ),
                      ChoiceChip(
                        label: Text(l10nR.tLeading(ref)),
                        selected: showLeading,
                        onSelected: (value) => setState(() => showLeading = value),
                      ),
                      ChoiceChip(
                        label: Text(l10nR.tDescription(ref)),
                        selected: showDescription,
                        onSelected: (value) => setState(() => showDescription = value),
                      ),
                      if (group && showDescription)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 5,
                          children: [
                            Checkbox(
                              value: descriptionIndices.$1,
                              onChanged: (value) => setState(
                                () => descriptionIndices = (
                                  !descriptionIndices.$1,
                                  descriptionIndices.$2,
                                  descriptionIndices.$3,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: descriptionIndices.$2,
                              onChanged: (value) => setState(
                                () => descriptionIndices = (
                                  descriptionIndices.$1,
                                  !descriptionIndices.$2,
                                  descriptionIndices.$3,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: descriptionIndices.$3,
                              onChanged: (value) => setState(
                                () => descriptionIndices = (
                                  descriptionIndices.$1,
                                  descriptionIndices.$2,
                                  !descriptionIndices.$3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (group)
                        ChoiceChip(
                          label: Text(l10nR.tValue(ref)),
                          selected: showValue,
                          onSelected: (value) => setState(() => showValue = value),
                        ),
                      if (group && showValue)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 5,
                          children: [
                            Checkbox(
                              value: valueIndices.$1,
                              onChanged: (value) => setState(
                                () => valueIndices = (
                                  !valueIndices.$1,
                                  valueIndices.$2,
                                  valueIndices.$3,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: valueIndices.$2,
                              onChanged: (value) => setState(
                                () => valueIndices = (
                                  valueIndices.$1,
                                  !valueIndices.$2,
                                  valueIndices.$3,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: valueIndices.$3,
                              onChanged: (value) => setState(
                                () => valueIndices = (
                                  valueIndices.$1,
                                  valueIndices.$2,
                                  !valueIndices.$3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ChoiceChip(
                        label: Text(l10nR.tTrailing(ref)),
                        selected: showTrailing,
                        onSelected: (value) => setState(() => showTrailing = value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: CustomConstrainedWidget(
                maxWidth: 1024,
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 40,
                      runSpacing: 40,
                      children: [
                        SizedBox(
                          width: 400,
                          child: CustomAnimatedSize(
                            child: Column(
                              children: [
                                Card.outlined(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      l10nR.tAndroid(ref),
                                      style: Theme.of(context).textTheme.labelLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                if (!group || !showGroupTitle) const SizedBox(height: 20),
                                if (group)
                                  AdaptiveTilesGroup(
                                    header: showGroupTitle ? Text(l10nR.tGroupTitle(ref)) : null,
                                    platform: TargetPlatform.android,
                                    tiles: [
                                      ..._placeHolders(isMaterial: true, group: true).mapIndexed(
                                        (i, data) => TileInGroup(
                                          data: data,
                                          enabled: enabled,
                                          trailingInStandard: showTrailing
                                              ? trailingIcon(true)
                                              : null,
                                          isNavigation: i == 1,
                                          androidNavigationTileTip: i == 1
                                              ? l10nR.tAndroidNavTileTooltip(ref)
                                              : null,
                                          isSwitch: i == 2,
                                          loading: loading,
                                          on: on,
                                          onToggle: (value) => setState(() => on = value),
                                          onPressed: onPressed,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  ..._placeHolders(isMaterial: true).map(
                                    (data) => AdaptiveListTile(
                                      enabled: enabled,
                                      leading: data.$1 != null ? Icon(data.$1) : null,
                                      title: Text(data.$2),
                                      onPressed: onPressed ? () {} : null,
                                      description: data.$3 != null ? Text(data.$3!) : null,
                                      trailing: showTrailing ? Icon(trailingIcon(true)) : null,
                                      platform: TargetPlatform.android,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: CustomAnimatedSize(
                            child: Column(
                              children: [
                                Card.outlined(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      l10nR.tIOSMacOS(ref),
                                      style: Theme.of(context).textTheme.labelLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                if (!group || !showGroupTitle) const SizedBox(height: 20),
                                if (group)
                                  AdaptiveTilesGroup(
                                    header: showGroupTitle ? Text(l10nR.tGroupTitle(ref)) : null,
                                    platform: TargetPlatform.iOS,
                                    tiles: [
                                      ..._placeHolders(isMaterial: false, group: true).mapIndexed(
                                        (i, data) => TileInGroup(
                                          data: data,
                                          enabled: enabled,
                                          trailingInStandard: showTrailing
                                              ? trailingIcon(false)
                                              : null,
                                          isNavigation: i == 1,
                                          isSwitch: i == 2,
                                          loading: loading,
                                          on: on,
                                          onToggle: (value) => setState(() => on = value),
                                          onPressed: onPressed,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  ..._placeHolders(isMaterial: false).map(
                                    (data) => AdaptiveListTile(
                                      enabled: enabled,
                                      leading: data.$1 != null ? Icon(data.$1) : null,
                                      title: Text(data.$2),
                                      onPressed: onPressed ? () {} : null,
                                      description: data.$3 != null ? Text(data.$3!) : null,
                                      trailing: showTrailing
                                          ? Icon(adaptiveIcons(false).info)
                                          : null,
                                      platform: TargetPlatform.iOS,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: group ? 33 : 50),
                    CustomAnimatedSize(
                      child: Column(
                        children: [
                          Card.outlined(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Text(
                                l10nR.tDesktopWeb(ref),
                                style: Theme.of(context).textTheme.labelLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          if (!group || !showGroupTitle) const SizedBox(height: 20),
                          if (group)
                            AdaptiveTilesGroup(
                              header: showGroupTitle ? Text(l10nR.tGroupTitle(ref)) : null,
                              platform: TargetPlatform.windows,
                              tiles: [
                                ..._placeHolders(isMaterial: true, group: true).mapIndexed(
                                  (i, data) => TileInGroup(
                                    data: data,
                                    enabled: enabled,
                                    trailingInStandard: showTrailing ? trailingIcon(true) : null,
                                    isNavigation: i == 1,
                                    isSwitch: i == 2,
                                    loading: loading,
                                    on: on,
                                    onToggle: (value) => setState(() => on = value),
                                    onPressed: onPressed,
                                  ),
                                ),
                              ],
                            )
                          else
                            ..._placeHolders(isMaterial: true).map(
                              (data) => AdaptiveListTile(
                                enabled: enabled,
                                leading: data.$1 != null ? Icon(data.$1) : null,
                                title: Text(data.$2),
                                onPressed: onPressed ? () {} : null,
                                description: data.$3 != null ? Text(data.$3!) : null,
                                trailing: showTrailing ? Icon(trailingIcon(true)) : null,
                                platform: TargetPlatform.windows,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 50),
        BottomLink(group: group),
      ],
    );
  }
}

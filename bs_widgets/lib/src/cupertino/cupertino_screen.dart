import 'package:bs_internet_service/bs_internet_service.dart';
import 'package:bs_l10n/bs_l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adaptive/neat_circular_indicator.dart';
import '../misc/l10nr_text.dart';
import '../riverpod_widgets/consumer_or_stateless.dart';

///{@template CupertinoScreen}
/// A convenient widget to create a Cupertino based screen
///{@endtemplate}
class CupertinoScreen extends ConsumerOrStatelessWidget {
  const CupertinoScreen({
    super.key,
    this.navigationBar,
    this.leading,
    this.title,
    this.largeTitle,
    this.trailing,
    this.useSafeArea = true,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    required Widget this.body, // NEW* : this is to avoid `body: null`
  }) : _slivered = false,
       // bodyWidgets = null,
       // bodyWidgetsPadding = null,
       alwaysShowTitle = null,
       connectionAware = false,
       notConnectedString = null,
       sliverNavigationBar = null,
       assert(
         (title != null) ^ (largeTitle != null),
         'Only one of title and largeTitle must be passed,'
         '${title == null && title == null ? 'Neither was passed' : 'NOT BOTH'}.'
         'If you want an interactive navBar use `CupertinoScreen.slivered`',
       );

  /// {@macro CupertinoScreen}
  ///
  /// Uses [NestedScrollView] with [CupertinoSliverNavigationBar]
  const CupertinoScreen.slivered({
    super.key,
    this.sliverNavigationBar,
    this.leading,
    this.title,
    this.alwaysShowTitle,
    this.largeTitle,
    this.trailing,
    this.useSafeArea = true,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    required Widget this.body,
    this.connectionAware = false,
    this.notConnectedString,
    // this.bodyWidgets,
    // this.bodyWidgetsPadding,
  }) : _slivered = true,
       navigationBar = null;

  // body = null;

  final bool _slivered;

  /// Use it to have full control over the navigation bar
  final CupertinoNavigationBar? navigationBar;

  /// Use it to have full control over the sliver navigation bar
  ///
  /// [CupertinoScreen.slivered] Specific.
  final CupertinoSliverNavigationBar? sliverNavigationBar;

  final Widget? leading;

  /// Note: If you set this to false and [connectionAware] to true
  /// you will not see [notConnectedString] in the title place.
  ///
  /// [CupertinoScreen.slivered] Specific.
  final bool? alwaysShowTitle;
  final Widget? title;
  final Widget? largeTitle;
  final Widget? trailing;

  /// Shows [notConnectedString] instead of [title] in case
  /// internet connection is lost.
  ///
  /// [CupertinoScreen.slivered] Specific.
  final bool connectionAware;

  /// The string you want to show in case internet connection
  /// is lost.
  ///
  /// default: 'Waiting for connection...'
  ///
  /// [CupertinoScreen.slivered] Specific.
  final StringRef? notConnectedString;
  final bool useSafeArea;

  /// Whether the body should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true.
  final bool resizeToAvoidBottomInset;

  /// The desired scaffold background color.
  final Color? backgroundColor;

  final Widget? body;

  // final List<Widget>? bodyWidgets;
  // final EdgeInsets? bodyWidgetsPadding;

  @override
  Widget build(BuildContext context, WidgetRef? ref) => _slivered
      ? CupertinoPageScaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: backgroundColor,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              sliverNavigationBar ??
                  _SliverNav(
                    key: UniqueKey(),
                    leading: leading,
                    title: title,
                    largeTitle: largeTitle,
                    trailing: trailing,
                    alwaysShowTitle: alwaysShowTitle,
                    connectionAware: connectionAware,
                    notConnectedString: notConnectedString,
                  ),
            ],
            body: useSafeArea
                ? SafeArea(child: body ?? const SizedBox.shrink())
                : body ?? const SizedBox.shrink(),

            /// This approach will prevent us from centering
            /// a few number of widgets. They will be aligned to the top.
            // SliverPadding(
            //   padding: bodyWidgetsPadding ?? EdgeInsets.zero,
            //   sliver: SliverList.list(
            //     children: [...bodyWidgets!],
            //     //     child: useSafeArea ? SafeArea(child: body) : body,
            //   ),
            // ),
          ),
        )
      : CupertinoPageScaffold(
          navigationBar:
              navigationBar ??
              (largeTitle != null
                  ? CupertinoNavigationBar.large(
                      leading: leading,
                      trailing: trailing,
                      largeTitle: largeTitle,
                    )
                  : CupertinoNavigationBar(
                      leading: leading,
                      trailing: trailing,
                      middle: title,
                    )),
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: backgroundColor,
          child: useSafeArea ? SafeArea(child: body!) : body!,
        );
}

class _SliverNav extends ConsumerWidget {
  const _SliverNav({
    super.key,
    required this.leading,
    required this.title,
    required this.largeTitle,
    required this.trailing,
    required this.alwaysShowTitle,
    required this.connectionAware,
    required this.notConnectedString,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? largeTitle;
  final Widget? trailing;
  final bool connectionAware;
  final StringRef? notConnectedString;
  final bool? alwaysShowTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = connectionAware ? ref.watch(isConnectedProvider) : true;
    return CupertinoSliverNavigationBar(
      leading: leading,
      trailing: trailing,
      middle: connected ?? true
          ? title
          : FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const NeatCircularIndicator(),
                  const SizedBox(width: 10),
                  L10nRText(notConnectedString ?? (_) => 'Waiting for network...'),
                ],
              ),
            ),
      largeTitle: largeTitle ?? title,
      alwaysShowMiddle: alwaysShowTitle ?? (connected == false ? true : false),
    );
  }
}

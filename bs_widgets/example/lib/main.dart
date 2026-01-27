import 'package:bs_l10n/bs_l10n.dart';
import 'package:bs_toast/bs_toast.dart';
/// Uncomment if you opt in to use LiveData
// import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/l10n_helper.dart';
import 'providers/setting_provider.dart';
import 'widgets/adaptive_buttons/adaptive_buttons_page.dart';
import 'widgets/adaptive_list_tiles/adaptive_list_tiles_page.dart';
import 'widgets/top_bar.dart';

void main() {
  /// Uncomment if you opt in to use LiveData
  runApp(const ProviderScope(child: MyApp()));
  // runApp(const MyApp());
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    title: 'BSWidgets Showcase',
    navigatorKey: MyApp.navigatorKey,
    theme: ThemeData(colorSchemeSeed: Colors.lightGreen),
    darkTheme: ThemeData(brightness: Brightness.dark, colorSchemeSeed: Colors.lightGreen),
    builder: (context, child) {
      /// Example does use Toast without context, so this line is necessary
      /// If you will ONLY use Toast with context passed you can omit this line on your app
      Toast.setNavigatorKey(MyApp.navigatorKey);

      // ignore: use_build_context_synchronously
      if (L10nService.localeNeedsInit) Future(() => L10nHelper.init(context));

      // ignore: use_build_context_synchronously
      // Future(() => LiveData.init(context));  // Uncomment if you opt in to use LiveData

      return child!;
    },
    localizationsDelegates: L10nService.delegates,
    themeMode: ref.watch(settingProvider.select((p) => p.themeMode)),
    locale: ref.watch(settingProvider.select((p) => p.locale)),
    supportedLocales: L10nService.supportedLocales,
    home: const MyHomePage(),
  );
}

final examplePages = {
  AdaptiveButtonsPage.title: const AdaptiveButtonsPage(),
  TilesPage.title: const TilesPage(),
};

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = examplePages.entries.first.key;
  Widget page = examplePages.entries.first.value;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TopBar(
      title: title,
      changePage: (page) => setState(() {
        this.page = page;
        title = examplePages.entries.firstWhere((e) => e.value == page).key;
      }),
    ),
    body: page,
  );
}

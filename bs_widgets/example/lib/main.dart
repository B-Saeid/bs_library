import 'package:bs_toast/bs_toast.dart';
/// Uncomment if you opt in to use LiveData
// import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/adaptive_buttons_page.dart';
import 'widgets/top_bar.dart';

void main() {
  /// Uncomment if you opt in to use LiveData
  runApp(const ProviderScope(child: MyApp()));
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.light;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BSWidgets Showcase',
    navigatorKey: MyApp.navigatorKey,
    theme: ThemeData(colorSchemeSeed: Colors.lightGreen),
    darkTheme: ThemeData(brightness: Brightness.dark, colorSchemeSeed: Colors.lightGreen),
    themeMode: mode,
    builder: (context, child) {
      /// Example does use Toast without context, so this line is necessary
      /// If you will ONLY use Toast with context passed you can omit this line on your app
      Toast.setNavigatorKey(MyApp.navigatorKey);

      // ignore: use_build_context_synchronously
      // Future(() => LiveData.init(context));  // Uncomment if you opt in to use LiveData
      return child!;
    },
    home: MyHomePage(
      mode: mode,
      changeThemeMode: () => setState(() {
        mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      }),
    ),
  );
}

final examplePages = {
  AdaptiveButtonsPage.title: const AdaptiveButtonsPage(),
};

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.changeThemeMode, required this.mode});

  final VoidCallback changeThemeMode;
  final ThemeMode mode;

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
      changeThemeMode: widget.changeThemeMode,
      mode: widget.mode,
      changePage: (Widget page) => setState(() => this.page = page),
    ),
    body: page,
  );
}

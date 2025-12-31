import 'package:bs_overlay/bs_overlay.dart';
/// Uncomment if you opt in to use LiveData
// import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_styles/bs_styles.dart';
import 'package:flutter/material.dart';

import 'bs_overlay_example_widget.dart';

/// Uncomment if you opt in to use LiveData
// import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  /// Uncomment if you opt in to use LiveData
  // runApp(ProviderScope(child: const MyApp()));
  runApp(const MyApp());
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
    title: 'BSOverlay Example',
    navigatorKey: MyApp.navigatorKey,
    theme: ThemeData(colorSchemeSeed: Colors.lightGreen),
    darkTheme: ThemeData(brightness: Brightness.dark, colorSchemeSeed: Colors.lightGreen),
    themeMode: mode,
    builder: (context, child) {
      /// Example does use BsOverlay without context, so this line is necessary
      /// If you will ONLY use BsOverlay with context passed you can omit this line on your app
      BsOverlay.setNavigatorKey(MyApp.navigatorKey);

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.changeThemeMode, required this.mode});

  final VoidCallback changeThemeMode;
  final ThemeMode mode;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('BSOverlay Example'),
    ),
    body: const BsOverlayExampleWidget(),
    floatingActionButton: FloatingActionButton(
      onPressed: changeThemeMode,
      child: Icon(mode == ThemeMode.system ? AppStyle.icons.light : AppStyle.icons.dark),
    ),
  );
}

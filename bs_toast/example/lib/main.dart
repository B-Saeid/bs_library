import 'package:bs_toast/bs_toast.dart';
import 'package:flutter/material.dart';

/// Uncomment if you opt in to use LiveData
// import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bs_toast_example_widget.dart';

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
    title: 'BSToast Example',
    navigatorKey: MyApp.navigatorKey,
    theme: ThemeData(colorSchemeSeed: Colors.lightGreen),
    darkTheme: ThemeData(brightness: Brightness.dark, colorSchemeSeed: Colors.lightGreen),
    themeMode: mode,
    builder: (context, child) {
      /// Example does use Toast without context, so this line is necessary
      /// If you will ONLY use Toast with context passed you can omit this line in your app
      Toast.setNavigatorKey(MyApp.navigatorKey);

      // ignore: use_build_context_synchronously
      /// Uncomment if you opt in to use LiveData
      // Future(() => LiveData.init(context));
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
      title: Text('BSToast Example'),
    ),
    body: BSToastExampleWidget(),
    floatingActionButton: FloatingActionButton(
      onPressed: changeThemeMode,
      child: Icon(mode == ThemeMode.system ? Icons.light_mode : Icons.dark_mode),
    ),
  );
}

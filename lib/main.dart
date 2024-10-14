import 'package:cashcow/app_binding.dart';
import 'package:cashcow/utils/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app_translations.dart';
import 'view/pages/login.dart';

void main() {
  AppBindings().dependencies();
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures binding for SystemChrome.
  // Set preferred orientation based on device width
  final double deviceWidth = WidgetsBinding.instance.window.physicalSize.width /
      WidgetsBinding.instance.window.devicePixelRatio;

  if (deviceWidth < 600) {
    // Assuming 600 pixels width is for mobile screens
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: const Locale('en'), // Default language
      fallbackLocale: const Locale('en'),
      theme: lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: LoginPage(),
    );
  }
}

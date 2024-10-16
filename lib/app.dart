import 'package:cashcow/view/pages/cart.dart';
import 'package:cashcow/view/pages/menu.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_translations.dart';
import 'model/food_category.dart';
import 'view/pages/food_selection.dart';
import 'view/pages/login.dart';
import 'view/pages/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context) ??
          const Locale('en'), // Enable locale from Device Preview
      builder: DevicePreview.appBuilder,
      translations: AppTranslations(), // Handle multiple languages
      fallbackLocale: const Locale('en'), // Fallback language
      theme: ThemeData.light(), // Custom light theme
      darkTheme: ThemeData.dark(), // Custom dark theme
      themeMode: ThemeMode.system, // Use system theme
      debugShowCheckedModeBanner: false, // Remove debug banner
      initialRoute: '/', // Define initial route
      getPages: [
        GetPage(
            name: '/',
            page: () => SplashScreen()), // SplashScreen as the first route
        GetPage(name: '/login', page: () => LoginPage()), // LoginPage route
        GetPage(
            name: '/category',
            page: () => const FoodMenuSelection()), // LoginPage route
        GetPage(
            name: '/menu',
            page: () => MenuPage(
                  category: categories.first,
                )), // LoginPage route
        GetPage(name: '/cart', page: () => CartPage()), // LoginPage route
      ],
    );
  }
}

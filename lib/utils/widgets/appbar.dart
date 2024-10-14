import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/localization_controller.dart';
import '../../controllers/theme_controller.dart';

AppBar kAppBar() {
  // Get the ThemeController instance
  final ThemeController themeController = Get.find();
  return AppBar(
    leadingWidth: 30,
    titleSpacing: 0.5,
    leading: const Icon(
      Icons.store,
      color: Colors.white,
    ),
    title: const Text(
      "Cashcow",
    ), // Using the translation key for "login"
    actions: [
      // Language Switcher Button
      const IconButton(
        icon: Icon(
          Icons.language,
          color: Colors.white,
        ),
        onPressed: changeLanguage,
      ),
      // Theme Switcher Button
      Obx(
        () => IconButton(
          icon: Icon(
            themeController.isDarkTheme.value
                ? Icons.dark_mode
                : Icons.light_mode,
            color: Colors.white,
          ),
          onPressed: changeTheme,
        ),
      ),
    ],
  );
}

void changeTheme() {
  // Get the ThemeController instance
  final ThemeController themeController = Get.find();
  themeController.toggleTheme();
}

void changeLanguage() {
  final LocalizationController localizationController = Get.find();
  // Switch Language
  var locale = Get.locale!.languageCode == 'en'
      ? const Locale('es')
      : const Locale('en');
  localizationController.changeLanguage(locale.languageCode);
}

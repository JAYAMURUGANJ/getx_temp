import 'package:get/get.dart';
import 'dart:ui'; // Import the Locale class

class LocalizationController extends GetxController {
  var selectedLanguage = 'en'.obs;

  // Method to change the language
  void changeLanguage(String langCode) {
    selectedLanguage.value = langCode;

    // Update the locale using GetX
    var locale = Locale(langCode);
    Get.updateLocale(locale);
  }
}

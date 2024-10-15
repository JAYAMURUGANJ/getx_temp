import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToLogin();
  }

  // Navigate to Login after 3 seconds
  void navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    debugPrint("Navigating to Login Page");
    Get.offAllNamed(
        '/login'); // Navigate to LoginPage and remove SplashScreen from stack
  }
}

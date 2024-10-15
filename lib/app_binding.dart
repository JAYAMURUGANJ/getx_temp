import 'package:get/get.dart';
import 'controllers/splash_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/localization_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    Get.put<ThemeController>(ThemeController());
    Get.put<LocalizationController>(LocalizationController());
  }
}

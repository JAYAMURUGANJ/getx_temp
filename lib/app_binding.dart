import 'package:cashcow/controllers/cart_controller.dart';
import 'package:cashcow/controllers/food_menu_controller.dart';
import 'package:get/get.dart';

import 'controllers/localization_controller.dart';
import 'controllers/splash_controller.dart';
import 'controllers/theme_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    Get.put<ThemeController>(ThemeController());
    Get.put<LocalizationController>(LocalizationController());
    Get.put<FoodMenuController>(FoodMenuController());
    Get.put<CartController>(CartController());
  }
}

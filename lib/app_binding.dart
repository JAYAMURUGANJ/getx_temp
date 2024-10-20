import 'package:cashcow/controllers/cart_controller.dart';
import 'package:cashcow/controllers/food_menu_controller.dart';
import 'package:get/get.dart';

import 'controllers/localization_controller.dart';
import 'controllers/splash_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/hive/order_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<LocalizationController>(() => LocalizationController());
    Get.lazyPut<FoodMenuController>(() => FoodMenuController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<OrderServiceController>(() => OrderServiceController());
  }
}

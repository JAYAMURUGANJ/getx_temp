import 'package:cashcow/app_binding.dart';
import 'package:cashcow/model/food_category.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'model/food_menu.dart';
import 'model/order.dart';
import 'model/order_type.dart';
import 'utils/class/hive/order_service.dart';

Future<void> main() async {
  // Ensure WidgetsBinding is initialized before anything else
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut(() => OrderServiceController());
  // Initialize Hive and register adapters
  await _initHive();

  // Register dependencies (after Hive initialization)
  AppBindings().dependencies();

  // Run the app
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Enables DevicePreview only in non-release mode
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

Future<void> _initHive() async {
  try {
    await Hive.initFlutter();

    // Registering all adapters
    Hive.registerAdapter(FoodMenuAdapter());
    Hive.registerAdapter(FoodCategoryAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderTypeAdapter());

    // Open required boxes
    OrderServiceController orderService = OrderServiceController();
    await orderService.openBox();
  } catch (e) {
    // Handle any errors related to Hive initialization
    debugPrint('Error initializing Hive: $e');
  }
}

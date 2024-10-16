import 'package:cashcow/model/food_category.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../model/food_menu.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

class FoodMenuController extends GetxController {
  // List to hold the menu items loaded from JSON
  var foodMenuList = <FoodMenu>[].obs;

  // Load menu based on category
  Future<void> loadMenuFromCategory(FoodCategory category) async {
    try {
      final String response = await rootBundle
          .loadString('assets/data/food_menu/${category.name}.json');
      List data = json.decode(response);
      foodMenuList.value = data.map((item) => FoodMenu.fromJson(item)).toList();
    } catch (e) {
      debugPrint("Error loading menu: $e");
    }
  }
}

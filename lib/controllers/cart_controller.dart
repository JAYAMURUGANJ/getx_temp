import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../model/food_menu.dart';
import '../model/order_type.dart';

class CartController extends GetxController {
  var cartItems = <FoodMenu>[].obs; // Observable list of cart items
  var totalCost = 0.0.obs; // Observable for total cart cost
  var selectedOrderType =
      Rx<OrderType?>(null); // Observable for selected order type
  var selectedTable =
      Rx<int?>(null); // To hold the selected table number for Dine In
  var phoneController = TextEditingController(); // To hold the phone number

  // Add item to the cart
  void addToCart(FoodMenu item) {
    // Check if the item already exists in the cart
    var existingItem =
        cartItems.firstWhereOrNull((cartItem) => cartItem.name == item.name);

    if (existingItem != null) {
      // If the item exists, increase its quantity
      existingItem.quantity += 1; // Always increment by 1
    } else {
      // If the item does not exist, add it with a quantity of 1
      item.quantity = 1; // Ensure it starts with a quantity of 1
      cartItems.add(item);
    }
    calculateTotal();
  }

  // Remove item from the cart
  void removeFromCart(FoodMenu item) {
    cartItems.remove(item);
    calculateTotal();
  }

  // Increase quantity of a specific item in the cart
  void increaseQuantity(FoodMenu item) {
    int index = cartItems.indexOf(item);
    if (index != -1) {
      cartItems[index].quantity += 1; // Increase by 1
      cartItems.refresh(); // Refresh the list to update UI
      calculateTotal();
    }
  }

  // Decrease quantity of a specific item in the cart
  void decreaseQuantity(FoodMenu item) {
    int index = cartItems.indexOf(item);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1; // Decrease by 1 if quantity > 1
      } else {
        // Remove item if quantity is 1
        cartItems.removeAt(index);
      }
      cartItems.refresh(); // Refresh the list to update UI
      calculateTotal();
    }
  }

  // Calculate the total price of all items in the cart
  void calculateTotal() {
    totalCost.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price ?? 0) * item.quantity,
    );
  }

  // Compute total quantity of items in the cart
  int get totalQuantity {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Select the order type
  void selectOrderType(OrderType? orderType) {
    selectedOrderType.value = orderType;
    selectedTable.value =
        null; // Clear table selection when switching order type
    phoneController.clear(); // Clear phone number when switching order type
  }

  // Clear the cart
  void clearCart() {
    cartItems.clear();
    calculateTotal();
  }

  // Check if the cart is empty
  bool get isCartEmpty => cartItems.isEmpty;

  // Validate phone number (example)
  bool validatePhoneNumber() {
    String phone = phoneController.text.trim();
    return phone.isNotEmpty &&
        phone.length == 10; // Assuming a 10-digit phone number
  }
}

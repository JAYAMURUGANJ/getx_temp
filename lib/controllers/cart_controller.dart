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
      existingItem.quantity +=
          item.quantity; // Update quantity of existing item
    } else {
      cartItems.add(item);
    }
    calculateTotal();
  }

  // Remove item from the cart
  void removeFromCart(FoodMenu item) {
    cartItems.remove(item);
    calculateTotal();
  }

  // Increase item quantity
  void increaseQuantity(FoodMenu item) {
    item.quantity += 1; // Increase quantity
    calculateTotal();
  }

  // Decrease item quantity
  void decreaseQuantity(FoodMenu item) {
    if (item.quantity > 1) {
      item.quantity -= 1; // Decrease quantity only if it's more than 1
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
    selectedTable(null); // Clear table selection when switching order type
    phoneController.clear(); // Clear phone number when switching order type
  }

  // Clear the cart
  void clearCart() {
    cartItems.clear();
    calculateTotal();
  }
}

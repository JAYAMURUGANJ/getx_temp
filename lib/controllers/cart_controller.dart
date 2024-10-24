import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../model/food_menu.dart';

class CartController extends GetxController {
  // Observable list of cart items
  var cartItems = <FoodMenu>[].obs;

  // Observable for total cart cost
  var totalCost = 0.0.obs;

  var customerName = ''.obs;
  var phoneNumber = ''.obs;

  // Observable for selected order type
  var selectedOrderType = Rx<int>(1);

  // Controllers to hold customer name and phone number
  var customerNameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  void onInit() {
    // Set initial values of the text fields to be synchronized with the observable variables
    customerNameController.text = customerName.value;
    phoneController.text = phoneNumber.value;
    super.onInit();
  }

  // Add item to the cart
  void addToCart(FoodMenu item) {
    // Check if the item already exists in the cart
    var existingItem =
        cartItems.firstWhereOrNull((cartItem) => cartItem.name == item.name);

    if (existingItem != null) {
      // Increase quantity of existing item
      existingItem.quantity = existingItem.quantity + 1;
    } else {
      // Add new item with quantity of 1
      item.quantity = 1;
      cartItems.add(item);
    }

    // Recalculate total cost after adding an item
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
      cartItems[index].quantity = cartItems[index].quantity + 1;
      cartItems.refresh(); // Trigger UI update
      calculateTotal();
    }
  }

  // Decrease quantity of a specific item in the cart
  void decreaseQuantity(FoodMenu item) {
    int index = cartItems.indexOf(item);
    if (index != -1) {
      if ((cartItems[index].quantity) > 1) {
        cartItems[index].quantity = cartItems[index].quantity - 1;
      } else {
        // Remove item if quantity reaches 1
        cartItems.removeAt(index);
      }
      cartItems.refresh(); // Trigger UI update
      calculateTotal();
    }
  }

  // Calculate the total price of all items in the cart
  void calculateTotal() {
    totalCost.value = cartItems.fold(0.0, (sum, item) {
      return sum + (item.price ?? 0) * item.quantity;
    });
  }

  // Compute the total quantity of items in the cart
  int get totalQuantity {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Select the order type and reset relevant fields
  void selectOrderType(int orderTypeId) {
    selectedOrderType.value = orderTypeId;
  }

  // Clear the cart
  void clearCart() {
    cartItems.clear();
    calculateTotal();
  }

  // Check if the cart is empty
  bool get isCartEmpty => cartItems.isEmpty;

  // Validate phone number (example: 10-digit phone number)
  bool validatePhoneNumber() {
    String phone = phoneController.text.trim();
    return phone.isNotEmpty && phone.length == 10;
  }

  // Validate customer name (example: non-empty validation)
  bool validateCustomerName() {
    String name = customerNameController.text.trim();
    return name.isNotEmpty && name.length > 1; // Adjust as per business logic
  }

  // Update the controller text when values change
  void updateCustomerDetails() {
    customerNameController.text = customerName.value;
    phoneController.text = phoneNumber.value;
  }

  // Clear form fields after submission (optional)
  void clearFormFields() {
    customerNameController.clear();
    phoneController.clear();
  }

  // Perform a final check before submitting the order
  bool canSubmitOrder() {
    if (isCartEmpty) {
      Get.snackbar('Error', 'Your cart is empty.');
      return false;
    }
    if (!validatePhoneNumber()) {
      Get.snackbar('Error', 'Please enter a valid phone number.');
      return false;
    }
    if (!validateCustomerName()) {
      Get.snackbar('Error', 'Please enter a valid customer name.');
      return false;
    }
    return true;
  }
}

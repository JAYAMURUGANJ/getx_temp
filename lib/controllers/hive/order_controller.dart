import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../model/order.dart';
import '../../model/order_menus.dart';

class OrderServiceController extends GetxController {
  final String _orderBoxName = 'orders_list';
  final String _orderMenuBoxName = 'order_menus_list';

  Box<Order>? _orderBox; // Hive box to store orders
  Box<OrderMenus>? _orderMenuBox; // Hive box to store order menus

  // Observable lists to hold orders and menus
  var orders = <Order>[].obs;
  var orderMenus = <OrderMenus>[].obs;

  // Open the Hive box for orders
  Future<void> openBox() async {
    if (_orderBox != null) return; // Already opened

    try {
      _orderBox = await Hive.openBox<Order>(_orderBoxName);
      _orderMenuBox = await Hive.openBox<OrderMenus>(_orderMenuBoxName);
      debugPrint('Order and Menu boxes opened successfully.');

      // Load orders and menus from Hive into observable lists
      orders.addAll(_orderBox!.values.toList());
      orderMenus.addAll(_orderMenuBox!.values.toList());
    } catch (e) {
      debugPrint('Error opening boxes: $e');
    }
  }

  // Create a new order and add it to the box
  Future<void> createOrder(Order order, List<OrderMenus> menus) async {
    if (!isBoxOpen(_orderBox)) return;

    try {
      // Assign an orderTrackId for the order
      String orderTrackId =
          DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID
      Order newOrder = order.copyWith(orderTrackId: orderTrackId);

      await _orderBox!.add(newOrder);
      orders.add(newOrder); // Add to observable list

      // Save associated OrderMenus with the same orderTrackId
      for (var menu in menus) {
        OrderMenus newMenu = menu.copyWith(
            orderTrackId: orderTrackId); // Set the same orderTrackId
        await _orderMenuBox!.add(newMenu);
        orderMenus.add(newMenu); // Add to observable list
      }

      debugPrint(
          'Order created: ${newOrder.orderStatusId}, Track ID: $orderTrackId');
    } catch (e) {
      debugPrint('Error creating order: $e');
      rethrow; // Optional: rethrow to handle it higher up
    }
  }

  // Get all OrderMenus by orderTrackId
  List<OrderMenus> getOrderMenus(String orderTrackId) {
    return orderMenus
        .where((menu) => menu.orderTrackId == orderTrackId)
        .toList();
  }

  Future<List<dynamic>> getOrders(int page, int pageSize) async {
    // Retrieve orders from your storage (e.g., Hive) and apply pagination
    List<dynamic> allOrders =
        getAllOrdersList(); // Your method to get all orders
    return allOrders.skip((page - 1) * pageSize).take(pageSize).toList();
  }

  // Get order details including order and corresponding menus
  Order getOrderDetails(String orderTrackId) {
    final order = orders.firstWhere(
      (o) => o.orderTrackId == orderTrackId,
    ); // Safely get the order or null

    return order;

    // final associatedMenus = getOrderMenus(orderTrackId);
    // return {
    //   'order': order,
    //   'menus': associatedMenus,
    // };
  }

  // Get all orders
  List<Order> getAllOrdersList() {
    return orders.toList(); // Return a list of all orders
  }

  // Delete all orders and their corresponding menus
  Future<void> deleteAllOrders() async {
    if (!isBoxOpen(_orderBox)) return;

    try {
      await _orderBox!.clear(); // Clear the orders box
      await _orderMenuBox!.clear(); // Clear the order menus box
      orders.clear(); // Clear the observable list
      orderMenus.clear(); // Clear the observable list
      debugPrint(
          'All orders and their corresponding menus deleted successfully.');
    } catch (e) {
      debugPrint('Error deleting all orders: $e');
      rethrow; // Optional: rethrow to handle it higher up
    }
  }

  // Other methods (updateOrderStatus, deleteOrder, etc.) remain unchanged...

  // Private method to check if the box is opened
  bool isBoxOpen(Box? box) => box != null;

  // Close the box (called when the app is terminating)
  Future<void> closeBox() async {
    if (_orderBox != null) {
      await _orderBox!.close();
      _orderBox = null;
      debugPrint('Order box closed successfully.');
    } else {
      debugPrint('Order box is already closed or not opened.');
    }
  }

// Method to update the isPrepared status of an OrderMenus item
  Future<void> updateIsPrepared(
      String orderTrackId, String id, int isPrepared) async {
    // Ensure the Hive box is open
    if (!isBoxOpen(_orderMenuBox)) return;

    try {
      // Get the list of OrderMenus items by orderTrackId
      var menuList = _orderMenuBox!.values
          .where((menu) => menu.orderTrackId == orderTrackId)
          .toList();

      if (menuList.isEmpty) {
        debugPrint('Error: No menu items found for orderTrackId $orderTrackId');
        return; // Exit if no items are found for the given orderTrackId
      }

      // Find the specific OrderMenus item using the provided id
      var menu = menuList.firstWhere(
        (menu) => menu.id == id,
      ); // Exit if no matching menu was found

      // Update the isPrepared value
      OrderMenus updatedMenu = menu.copyWith(isPrepared: isPrepared);

      // Save the updated menu back to Hive
      await _saveUpdatedMenu(updatedMenu, menu);

      // Handle menu deletion if isPrepared status is 4 (delete the menu)
      if (isPrepared == 4) {
        await _deleteMenuItem(menu);
      }

      // Update the order status based on the updated menu status
      await _updateOrderStatusBasedOnMenu(menuList, orderTrackId);

      // Check if the order has no items left and show confirmation dialog
      if (menuList.isEmpty || menuList.every((menu) => menu.isPrepared == 4)) {
        // If all items are deleted (isPrepared == 4), prompt for order deletion
        _showDeleteOrderConfirmation(orderTrackId);
      }
    } catch (e) {
      debugPrint('Error updating isPrepared status: $e');
    }
  }

// Method to update the order status based on the prepared statuses of menu items
  Future<void> _updateOrderStatusBasedOnMenu(
      List<OrderMenus> menuList, String orderTrackId) async {
    bool allPrepared = true; // Assume all items are prepared initially
    bool allProcessed = true; // Assume all items are processed initially

    // Iterate through the menu list to check the conditions
    for (var menu in menuList) {
      if (menu.isPrepared != 1) {
        allPrepared = false; // At least one item is not prepared
      }
      if (menu.isPrepared != 3) {
        allProcessed = false; // At least one item is not processed
      }
      // If both flags become false, no need to continue
      if (!allPrepared && !allProcessed) break;
    }

    // Determine the order status based on the flags
    if (allPrepared) {
      // If all items are prepared (status 1)
      await _updateOrderStatus(orderTrackId, 1);
    } else if (allProcessed) {
      // If all items are processed (status 3)
      await _updateOrderStatus(orderTrackId, 3);
    } else {
      // Otherwise, default to status 2 (Cooking)
      await _updateOrderStatus(orderTrackId, 2);
    }
  }

// Method to save the updated menu back to Hive
  Future<void> _saveUpdatedMenu(
      OrderMenus updatedMenu, OrderMenus oldMenu) async {
    // Get the index of the old menu item in the Hive box
    int menuIndex = _orderMenuBox!.values.toList().indexOf(oldMenu);

    if (menuIndex != -1) {
      // Save the updated menu at the correct index
      await _orderMenuBox!.putAt(menuIndex, updatedMenu);

      // Update the observable list (orderMenus) to reflect the change
      int orderMenuIndex = orderMenus.indexWhere((m) => m.id == oldMenu.id);
      if (orderMenuIndex != -1) {
        orderMenus[orderMenuIndex] = updatedMenu;
      }

      debugPrint(
          'Menu status updated successfully: isPrepared = ${updatedMenu.isPrepared}');
    } else {
      debugPrint(
          'Error: Unable to find the menu in the Hive box for updating.');
    }
  }

// Method to delete a menu item if its isPrepared status is 4
  Future<void> _deleteMenuItem(OrderMenus menu) async {
    // Remove the item from Hive
    await _orderMenuBox!.delete(menu.id);

    // Remove the item from the observable list
    orderMenus.removeWhere((m) => m.id == menu.id);

    debugPrint('Menu item with id ${menu.id} deleted.');
  }

// Method to update the order status
  Future<void> _updateOrderStatus(String orderTrackId, int newStatus) async {
    // Ensure the box is open
    if (!isBoxOpen(_orderBox)) return;

    try {
      // Attempt to find the order by orderTrackId
      final order = _orderBox!.values.firstWhere(
        (o) => o.orderTrackId == orderTrackId,
        orElse: () => throw Exception('Order not found'),
      );

      // Create an updated order instance
      Order updatedOrder = order.copyWith(orderStatusId: newStatus);

      // Save the updated order back to Hive
      int orderIndex = _orderBox!.values.toList().indexOf(order);
      await _orderBox!.putAt(orderIndex, updatedOrder);

      debugPrint(
          'Order status updated to $newStatus for orderTrackId: $orderTrackId');
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }

// Method to show confirmation dialog for deleting the order
  void _showDeleteOrderConfirmation(String orderTrackId) {
    Get.defaultDialog(
      title: "Delete Order",
      middleText: "This order has no items left. Do you want to delete it?",
      onConfirm: () async {
        // Delete the order from Hive and any related items
        await _deleteOrder(orderTrackId);
        Get.back(); // Close the dialog
      },
      onCancel: () {
        Get.back(); // Just close the dialog
      },
    );
  }

// Method to delete the order
  Future<void> _deleteOrder(String orderTrackId) async {
    // Implement the logic to delete the order from Hive
    debugPrint('Order with orderTrackId: $orderTrackId deleted');
  }
}

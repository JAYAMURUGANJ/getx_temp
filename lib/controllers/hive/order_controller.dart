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
          'Order created: ${newOrder.orderStatus}, Track ID: $orderTrackId');
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

  // Get order details including order and corresponding menus
  Map<String, dynamic> getOrderDetails(String orderTrackId) {
    final order = orders.firstWhere(
      (o) => o.orderTrackId == orderTrackId,
    ); // Safely get the order or null

    final associatedMenus = getOrderMenus(orderTrackId);
    return {
      'order': order,
      'menus': associatedMenus,
    };
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
}

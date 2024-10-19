import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../model/order.dart';

class OrderServiceController extends GetxController {
  final String _orderBoxName = 'orders';
  Box<Order>? _orderBox; // Store reference to the opened box
  var orders = <Order>[].obs; // Observable order list

  // Open the Hive box for orders (should be called once, during initialization)
  Future<void> openBox() async {
    if (_orderBox == null) {
      try {
        _orderBox = await Hive.openBox<Order>(_orderBoxName);
        debugPrint('Order box opened successfully.');

        // Load existing orders from Hive into the observable list
        orders.addAll(_orderBox!.values.toList());
      } catch (e) {
        debugPrint('Error opening order box: $e');
      }
    }
  }

  // Create a new order and add it to the box
  Future<void> createOrder(Order order) async {
    if (_orderBox == null) {
      debugPrint('Order box is not opened. Please open the box first.');
      return;
    }
    try {
      await _orderBox!.add(order);
      orders.add(order); // Add to observable list
      debugPrint('Order created: ${order.orderStatus}');
    } catch (e) {
      debugPrint('Error creating order: $e');
    }
  }

  // Read all orders from the box
  List<Order> readOrders() {
    return orders; // Return the observable list
  }

  // Update the status and endDateTime of an existing order by index
  Future<void> updateOrderStatus(
      int index, int status, DateTime endDateTime) async {
    if (_orderBox == null) {
      debugPrint('Order box is not opened. Please open the box first.');
      return;
    }

    try {
      Order? order = orders[index]; // Get from observable list

      order.orderStatus = status;
      order.endDateTime = endDateTime;
      await _orderBox!.putAt(index, order); // Update the order in the box
      orders[index] = order; // Update the observable list
      debugPrint(
          'Order updated: ${order.orderStatus}, End time: ${order.endDateTime}');
    } catch (e) {
      debugPrint('Error updating order: $e');
    }
  }

  // Delete an order by index
  Future<void> deleteOrder(int index) async {
    if (_orderBox == null) {
      debugPrint('Order box is not opened. Please open the box first.');
      return;
    }
    try {
      await _orderBox!.deleteAt(index);
      orders.removeAt(index); // Remove from observable list
      debugPrint('Order deleted at index: $index');
    } catch (e) {
      debugPrint('Error deleting order: $e');
    }
  }

  // Get an order by its index
  Order? getOrder(int index) {
    return orders[index]; // Get from observable list
  }

  // Close the box (optional, can be used when the app is terminating)
  Future<void> closeBox() async {
    if (_orderBox != null) {
      await _orderBox!.close();
      _orderBox = null; // Reset the reference
      debugPrint('Order box closed successfully.');
    } else {
      debugPrint('Order box is already closed or not opened.');
    }
  }
}

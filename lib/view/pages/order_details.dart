import 'package:cashcow/model/order_type.dart';
import 'package:flutter/material.dart';
import '../../controllers/hive/order_controller.dart';
import '../../model/order.dart'; // Import your Order model
import '../../model/order_menus.dart'; // Import OrderMenus model
import 'package:get/get.dart'; // Import GetX for dependency injection

class OrderDetailsPage extends StatefulWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final OrderServiceController orderService = Get.find();

    // Get OrderMenus associated with this order
    List<OrderMenus> orderMenus =
        orderService.getOrderMenus(widget.order.orderTrackId!);

    return Scaffold(
      appBar: AppBar(
        title: Text("Order: ${widget.order.orderTrackId}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${widget.order.orderTrackId}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Order Type: ${orderType[widget.order.orderTypeId - 1].name!}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Items:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orderMenus.length,
                itemBuilder: (context, index) {
                  final item = orderMenus[index];
                  return ListTile(
                    title: Text(item.name!),
                    trailing: Icon(
                      item.isPrepared == true
                          ? Icons.check_circle
                          : Icons.error_outline,
                      color:
                          item.isPrepared == true ? Colors.green : Colors.red,
                    ),
                    subtitle: Text(
                      item.isPrepared == true ? "Processed" : "Not Processed",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

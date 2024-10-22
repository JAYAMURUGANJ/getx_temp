import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:cashcow/view/widgets/order_details_props.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX for dependency injection

import '../../controllers/hive/order_controller.dart';
import '../../model/order.dart'; // Import your Order model
import '../../model/order_menus.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  double _calculateTotalAmount(List<OrderMenus> orderMenus) {
    // Calculate total amount by summing up price * quantity of each item
    double totalAmount = 0.0;
    for (var item in orderMenus) {
      totalAmount += item.price! * item.quantity!;
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    final OrderServiceController orderServiceController = Get.find();

    // Get OrderMenus associated with this order
    List<OrderMenus> orderMenus =
        orderServiceController.getOrderMenus(widget.order.orderTrackId!);

    // Calculate the total amount for the order
    double totalAmount = _calculateTotalAmount(orderMenus);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderDetailsCard(order: widget.order),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Order Items:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orderMenus.length,
                itemBuilder: (context, index) {
                  final item = orderMenus[index];
                  return ListTile(
                    title: Text(item.name!),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          item.isPrepared == true
                              ? Icons.check_circle
                              : Icons.error_outline,
                          color: item.isPrepared == true
                              ? Colors.green
                              : Colors.red,
                        ),
                        Flexible(
                          child: Text(
                            '\$ ${(item.price! * item.quantity!).toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold, // Bolder price
                                ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '( ${item.quantity} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.grey[
                                            600]), // Consistent small text styling
                              ),
                              4.pw,
                              const Text('x'),
                              4.pw,
                              Text(
                                '\$ ${item.price} )',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Text(
                            item.isPrepared == true
                                ? "Processed"
                                : "Not Processed",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Add a bottom navigation bar with a floating action button for the payment
      bottomNavigationBar: BottomAppBar(
        height: 150,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Total cost row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Amount To Pay:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$ ${totalAmount.toStringAsFixed(2)}", // Dynamic total cost
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .black87, // Slightly darkened for better contrast
                    ),
                  ),
                ],
              ),
              10.ph,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon:
                          const Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        // Handle payment logic here
                        debugPrint("Proceeding to payment");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Background color
                        padding: const EdgeInsets.symmetric(
                            vertical: 14), // Larger buttons
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                      label: const Text(
                        "Proceed to Payment",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

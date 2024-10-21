import 'package:cashcow/view/pages/order_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/hive/order_controller.dart';
import '../../model/order_type.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final OrderServiceController orderServiceController = Get.find();

  @override
  void initState() {
    super.initState();
    // Ensure the box is opened only once during initialization
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    await orderServiceController.openBox(); // Wait until the box is opened
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                //   orderServiceController.
              },
              icon: const Icon(Icons.delete_sweep_sharp))
        ],
      ),
      body: Obx(() {
        if (orderServiceController.orders.isEmpty) {
          return _emptyKitchen(context);
        }

        return ListView.builder(
          itemCount: orderServiceController.orders.length,
          itemBuilder: (context, index1) {
            final orders = orderServiceController.getAllOrdersList();
            final order = orders[index1];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              elevation: 3,
              child: ListTile(
                leading: Container(
                  width: 60,
                  height: 50,
                  color: order.orderTypeId == 1 ? Colors.green : Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: Text(
                        orderType[order.orderTypeId - 1].name!.toUpperCase(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  "Order Id: ${order.orderTrackId}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Tap to view details"),
                trailing: order.orderStatus == 1
                    ? const Icon(
                        Icons.linear_scale_outlined,
                        size: 40,
                        color: Colors.amber,
                      )
                    : order.orderStatus == 6
                        ? const Icon(
                            Icons.close,
                            size: 40,
                            color: Colors.greenAccent,
                          )
                        : const Icon(
                            Icons.check_sharp,
                            size: 40,
                            color: Colors.greenAccent,
                          ),
                onTap: () {
                  // Navigate to the OrderDetailsPage with the order data
                  Get.to(() => OrderDetailsPage(order: order));
                },
              ),
            );
          },
        );
      }),
    );
  }

  Widget _emptyKitchen(context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.rice_bowl_outlined,
          size: 100,
        ),
        Text(
          'Your kitchen order is empty.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ));
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cashcow/model/order_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/class/hive/order_service.dart';

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
    orderServiceController.openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (orderServiceController.orders.isEmpty) {
          return const Center(child: Text('No orders available.'));
        }
        return ListView.builder(
          itemCount: orderServiceController.orders.length,
          itemBuilder: (context, index1) {
            final order = orderServiceController.orders[index1];
            final item = orderServiceController.orders[index1].items;
            return Card(
              child: ListTile(
                leading: Text(
                  orderType[order.orderStatus!].name!.toUpperCase(),
                ),
                title: Text(
                  item.length.toString(),
                ), // Display order status
                subtitle: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (context, index2) {
                      return Text(item[index2].name!);
                    },
                  ),
                ), // Display end time
                onTap: () {
                  // Add functionality to handle order tap
                },
              ),
            );
          },
        );
      }),
    );
  }
}

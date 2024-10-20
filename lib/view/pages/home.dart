import 'package:cashcow/view/pages/kitchen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import 'new_order.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final CartController cartController = Get.find();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController
    tabController = TabController(length: 3, vsync: this); // Assuming 3 tabs
  }

  @override
  void dispose() {
    tabController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cashcow'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.add_shopping_cart),
                text: 'New Order',
              ),
              Tab(
                icon: Icon(Icons.kitchen),
                text: 'Kitchen',
              ),
              Tab(
                icon: Icon(Icons.payment),
                text: 'Payment',
              ),
            ],
          ),
          actions: [
            Obx(
              () => IconButton(
                icon: cartController.cartItems.isNotEmpty
                    ? Badge.count(
                        count: cartController.cartItems
                            .length, // Display the total quantity of items
                        child: const Icon(
                          Icons.shopping_cart,
                        ),
                      )
                    : const Icon(
                        Icons.shopping_cart_outlined,
                      ),
                onPressed: () => Get.toNamed("/cart"),
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            NewOrderPage(), // Widget for New Order tab
            KitchenPage(), // Widget for Kitchen tab
            PaymentPage(), // Widget for Payment tab
          ],
        ),
      ),
    );
  }
}

// Payment Page
class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Payment Tab',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

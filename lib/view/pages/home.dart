import 'package:cashcow/view/pages/kitchen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../widgets/common/kart_icon.dart';
import 'new_order.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final CartController cartController = Get.find();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController
    _tabController =
        TabController(length: tabs.length, vsync: this); // Assuming 3 tabs
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length, // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Cashcow'),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          actions: [
            KCartIcon(cartController: cartController),
          ],
        ),
        body: TabBarView(controller: _tabController, children: [
          NewOrderPage(
            tabController: _tabController,
          ),
          const KitchenPage(),
          const PaymentPage(),
        ]),
      ),
    );
  }
}

List<Widget> tabs = [
  const Tab(
    icon: Icon(Icons.add_shopping_cart),
    text: 'New Order',
  ),
  const Tab(
    icon: Icon(Icons.soup_kitchen_outlined),
    text: 'Kitchen',
  ),
  const Tab(
    icon: Icon(Icons.payments_sharp),
    text: 'Payment',
  ),
];

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

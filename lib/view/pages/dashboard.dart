import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/hive/order_controller.dart';
import '../../model/order.dart';
import '../../model/order_type.dart';
import '../../utils/widgets/appbar.dart';
import '../widgets/dashboard_props.dart';
import '../widgets/order_details_props.dart';
import 'order_details.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final OrderServiceController orderServiceController = Get.find();

  // TextEditingController for search
  final TextEditingController searchController = TextEditingController();

  // Observable variables for GetX
  final RxString selectedOrderType = 'All'.obs; // Default filter option
  final RxList<Order> allOrders =
      <Order>[].obs; // Observable list of all orders
  final RxList<Order> filteredOrders =
      <Order>[].obs; // Observable list for filtered orders

  // Order counts by status
  RxInt confirmedCount = 0.obs;
  RxInt cookingCount = 0.obs;
  RxInt completedCount = 0.obs;

  @override
  void initState() {
    super.initState();
    orderServiceController.watchOrders();
    loadOrders(); // Load orders on initialization
  }

  // Load orders and filter them
  void loadOrders() async {
    await orderServiceController.openBox(); // Wait until the box is opened
    allOrders.assignAll(
        orderServiceController.getAllOrdersList()); // Populate all orders
    filterOrders(); // Apply initial filter to show all orders
    calculateOrderCounts(); // Calculate initial order counts

    // Watch for changes in orders and re-filter and re-calculate when they change
    ever(orderServiceController.orders, (_) {
      allOrders.assignAll(orderServiceController.getAllOrdersList());
      filterOrders();
      calculateOrderCounts(); // Recalculate counts whenever orders change
    });
  }

  // Function to calculate order counts by status
  void calculateOrderCounts() {
    confirmedCount.value =
        allOrders.where((order) => order.orderStatusId == 1).length;
    cookingCount.value =
        allOrders.where((order) => order.orderStatusId == 2).length;
    completedCount.value =
        allOrders.where((order) => order.orderStatusId == 3).length;
  }

  // Function to filter orders based on search and filter criteria
  void filterOrders() {
    filteredOrders.value = allOrders.where((order) {
      // Filter by search
      bool matchesSearch = searchController.text.isEmpty ||
          order.orderTrackId.toString().contains(searchController.text);

      // Filter by order type
      bool matchesFilter = selectedOrderType.value == 'All' ||
          order.orderTypeId ==
              orderType
                  .firstWhere(
                    (type) => type.name == selectedOrderType.value,
                    orElse: () => OrderType(id: 0, name: ''),
                  )
                  .id;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order status cards at the top
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "Orders",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ordersDetailsCountCards(),
              // Search and filter
              10.ph,
              _buildSearchAndFilter(),
              // Order list
              10.ph,
              Expanded(
                child: filteredOrders.isEmpty
                    ? noOrdersFound(context)
                    : ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return GestureDetector(
                            onTap: () => Get.to(() => OrderDetailsPage(
                                  orderTrackId: order.orderTrackId.toString(),
                                )),
                            child: OrderDetailsCard(order: order),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/home'),
        label: const Text("New Order"),
        icon: const Icon(Icons.add_shopping_cart_sharp),
      ),
    );
  }

  Row ordersDetailsCountCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildOrderStatusCard('Confirmed', confirmedCount.value, Colors.blue),
        buildOrderStatusCard(
            'In Cooking', cookingCount.value, Colors.deepOrange),
        buildOrderStatusCard(
            'Completed', completedCount.value, Colors.lightGreen),
      ],
    );
  }

  // Build search and filter widget
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by Order ID",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                filterOrders; // Trigger filtering when search changes
              },
            ),
          ),
          10.pw,
          Container(
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: DropdownButtonHideUnderline(
                child: Obx(() {
                  return DropdownButton<String>(
                    value: selectedOrderType.value,
                    items: <String>[
                      'All',
                      ...orderType.map((type) => type.name!)
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedOrderType.value =
                          value!; // Update selected order type
                      filterOrders(); // Trigger filtering when filter changes
                    },
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget noOrdersFound(BuildContext context) {
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
      ),
    );
  }
}

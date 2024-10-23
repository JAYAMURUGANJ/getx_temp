import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:cashcow/view/widgets/order_details_props.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/hive/order_controller.dart';
import '../../model/order.dart';
import '../../model/order_type.dart';
import 'order_details.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final OrderServiceController orderServiceController = Get.find();

  // TextEditingController for search
  final TextEditingController searchController = TextEditingController();

  // Observable variables for GetX
  final RxString selectedOrderType = 'All'.obs; // Default filter option
  final RxList<Order> allOrders =
      <Order>[].obs; // Observable list of all orders
  final RxList<Order> filteredOrders =
      <Order>[].obs; // Observable list for filtered orders

  @override
  void initState() {
    super.initState();
    loadOrders(); // Load orders on initialization
  }

  // Load orders and filter them
  void loadOrders() async {
    await orderServiceController.openBox(); // Wait until the box is opened
    allOrders.assignAll(
        orderServiceController.getAllOrdersList()); // Populate all orders
    filterOrders(); // Apply initial filter to show all orders

    // Watch for changes in orders and re-filter when they change
    ever(orderServiceController.orders, (_) {
      allOrders.assignAll(orderServiceController.getAllOrdersList());
      filterOrders();
    });
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
      body: Obx(() {
        if (filteredOrders.isEmpty) {
          return _emptyKitchen(context);
        }

        return Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return GestureDetector(
                    onTap: () => Get.to(() => OrderDetailsPage(
                          orderTrackId: order.orderTrackId.toString(),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OrderDetailsCard(order: order),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  // Build search and filter widget
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                filterOrders(); // Trigger filtering when search changes
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

  Widget _emptyKitchen(BuildContext context) {
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

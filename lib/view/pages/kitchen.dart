import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:cashcow/view/pages/order_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/hive/order_controller.dart';
import '../../model/order_type.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final OrderServiceController orderServiceController = Get.find();

  // TextEditingController for search
  final TextEditingController searchController = TextEditingController();

  String selectedOrderType = 'All'; // Default filter option
  List<dynamic> filteredOrders = []; // List to store filtered orders

  @override
  void initState() {
    super.initState();
    // Ensure the box is opened only once during initialization
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    await orderServiceController.openBox(); // Wait until the box is opened
    _filterOrders(); // Apply initial filter to show all orders
  }

  // Function to filter orders based on search and filter criteria
  void _filterOrders() {
    final orders = orderServiceController.getAllOrdersList();

    setState(() {
      filteredOrders = orders.where((order) {
        // Filter by search
        bool matchesSearch = searchController.text.isEmpty ||
            order.orderTrackId.toString().contains(searchController.text);

        // Filter by order type
        bool matchesFilter = selectedOrderType == 'All' ||
            order.orderTypeId ==
                orderType
                    .firstWhere((type) => type.name == selectedOrderType,
                        orElse: () => OrderType(id: 0, name: ''))
                    .id;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (orderServiceController.orders.isEmpty) {
          return _emptyKitchen(context);
        }

        return Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: ListView(
                children: [
                  if (filteredOrders.isNotEmpty)
                    _buildOrderSection("Orders", filteredOrders)
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No orders found"),
                      ),
                    ),
                ],
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
                _filterOrders(); // Trigger filtering when search changes
              },
            ),
          ),
          10.pw,
          Container(
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: Colors.grey), // Adjust the color as needed
              color: Colors.white, // Background color
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: DropdownButtonHideUnderline(
                // Hides the default underline
                child: DropdownButton<String>(
                  value: selectedOrderType,
                  items: <String>['All', ...orderType.map((type) => type.name!)]
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        // Adds padding around the text
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOrderType = value!;
                      _filterOrders(); // Trigger filtering when filter changes
                    });
                  },
                  isExpanded:
                      true, // Makes the dropdown take the full width of the container
                  icon: const Icon(
                      Icons.arrow_drop_down), // Customize the dropdown icon
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper function to build each order section
  Widget _buildOrderSection(String title, List orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index1) {
            final order = orders[index1];

            // Format the time part of the order
            String formattedDate = DateFormat('MMMM dd, yyyy, hh:mm a')
                .format(order.startDateTime);

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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate, // Display the time only
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Text(
                      "Tap to view more",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
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
        ),
      ],
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

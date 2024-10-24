import 'package:cashcow/model/food_category.dart';
import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/food_menu_controller.dart';
import '../../controllers/hive/order_controller.dart';
import '../../utils/widgets/catch_network_img.dart';

class NewOrderPage extends StatelessWidget {
  final TabController? tabController;
  const NewOrderPage({super.key, this.tabController});

  @override
  Widget build(BuildContext context) {
    final FoodMenuController foodMenuController = Get.put(FoodMenuController());
    final OrderServiceController orderServiceController = Get.find();
    final CartController cartController = Get.find();

    // Observable variables for GetX
    var selectedCategoryIndex = 0.obs; // Use RxInt for reactive state
    var searchQuery = ''.obs; // Use RxString for the search query

    // Load menu items based on initial category selection
    foodMenuController
        .loadMenuFromCategory(categories[selectedCategoryIndex.value]);
    // Open the Hive box when the widget is created
    orderServiceController.openBox();

    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Expanded(
            child: Row(
              children: [
                // Scrollable NavigationRail for categories
                _foodCategory(context, selectedCategoryIndex,
                    foodMenuController, orderServiceController),
                // Divider between navigation and content
                const VerticalDivider(thickness: 1, width: 1),
                // Food Menu List for the selected category
                Expanded(
                  child: Obx(() {
                    var filteredMenu = foodMenuController.foodMenuList
                        .where((item) =>
                            item.name
                                ?.toLowerCase()
                                .contains(searchQuery.value) ??
                            true)
                        .toList();

                    if (filteredMenu.isEmpty) {
                      return const Center(
                          child: Text('No items available in this category.'));
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              searchQuery.value = value
                                  .toLowerCase(); // Update the search query
                            },
                            decoration: InputDecoration(
                              labelText: 'Search Menu',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                        10.ph,
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredMenu.length,
                            itemBuilder: (context, index) {
                              var item = filteredMenu[index];

                              return Card(
                                elevation: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    cartController.addToCart(item);
                                    Get.snackbar(
                                      'Added to Cart',
                                      '${item.name}',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0)),
                                        child: CatchNetworkImage(
                                          imageUrl: item.img ?? '',
                                          width: 250,
                                          height: 180,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                    item.name ?? '',
                                                    textAlign: TextAlign.left,
                                                    maxLines: 2,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                    item.dsc ?? '',
                                                    textAlign: TextAlign.left,
                                                    maxLines: 3,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "\$${item.price}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _foodCategory(
      BuildContext context,
      RxInt selectedCategoryIndex,
      FoodMenuController foodMenuController,
      OrderServiceController orderServiceController) {
    return NavigationRail(
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          "Category",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Obx(() {
              // Ensure that orders is an observable
              var ordersCount = orderServiceController
                  .orders.length; // Assuming orders is an observable list

              return IconButton(
                icon: ordersCount != 0
                    ? Badge.count(
                        textStyle: const TextStyle(fontSize: 18),
                        count: ordersCount, // Display the total count of orders
                        child: const Icon(
                          Icons.rice_bowl_sharp,
                          size: 40,
                        ),
                      )
                    : const Icon(
                        Icons.rice_bowl_outlined,
                        size: 40,
                      ),
                onPressed: () {
                  Get.offAllNamed("dashboard");
                },
              );
            }),
          ),
        ),
      ),
      selectedIndex: selectedCategoryIndex.value,
      onDestinationSelected: (int index) {
        selectedCategoryIndex.value =
            index; // Update the selected category index
        // Load menu based on selected category
        foodMenuController.loadMenuFromCategory(categories[index]);
      },
      labelType: NavigationRailLabelType.all,
      destinations: categories.map((category) {
        return NavigationRailDestination(
          icon: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Image.asset(
              category.imagePath,
              width: 30,
              height: 30,
              fit: BoxFit.fitWidth,
            ),
          ),
          selectedIcon: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Image.asset(
              category.imagePath,
              width: 45,
              height: 40,
              fit: BoxFit.fitWidth,
            ),
          ),
          label: Text(category.name.capitalize.toString()),
        );
      }).toList(),
    );
  }
}

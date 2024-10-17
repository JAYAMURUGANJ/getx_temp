import 'package:cashcow/model/food_category.dart';
import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/food_menu_controller.dart';
import '../../utils/widgets/catch_network_img.dart';
import 'cart.dart';

class FoodMenuSelection extends StatefulWidget {
  const FoodMenuSelection({super.key});

  @override
  _FoodMenuSelectionState createState() => _FoodMenuSelectionState();
}

class _FoodMenuSelectionState extends State<FoodMenuSelection> {
  int selectedCategoryIndex = 0; // To track the selected category
  final FoodMenuController foodMenuController = Get.find();
  final CartController cartController = Get.find();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load menu items based on initial category selection
    foodMenuController.loadMenuFromCategory(categories[selectedCategoryIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Menu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          // Inside your widget where the IconButton is located
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
              onPressed: () => Get.to(() => CartPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Expanded(
            child: Row(
              children: [
                // Scrollable NavigationRail for categories
                NavigationRail(
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "Category",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  selectedIndex: selectedCategoryIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
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
                ),

                // Divider between navigation and content
                const VerticalDivider(thickness: 1, width: 1),

                // Food Menu List for the selected category
                Expanded(
                  child: Obx(() {
                    var filteredMenu = foodMenuController.foodMenuList
                        .where((item) =>
                            item.name?.toLowerCase().contains(searchQuery) ??
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
                              setState(() {
                                searchQuery = value
                                    .toLowerCase(); // Update the search query
                              });
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
                                    Get.find<CartController>().addToCart(item);
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
}

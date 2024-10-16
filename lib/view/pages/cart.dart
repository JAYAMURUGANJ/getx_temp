import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../model/food_menu.dart';
import '../../model/order_type.dart';
import '../../utils/widgets/catch_network_img.dart';
import 'kitchen.dart'; // Ensure to import your FoodMenu model

class CartPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          } else {
            return Column(
              children: [
                // Cart items list
                Expanded(
                  child: ListView.builder(
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      var item = cartController.cartItems[index];
                      return _buildCartItem(item);
                    },
                  ),
                ),
                // Total cost and place order button
                const Divider(),
                Container(
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Display total price
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
                              '\$${cartController.totalCost.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      // Bottom navigation bar with Cancel and Place Order buttons
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to cancel the order
                    cartController.clearCart();
                    Get.snackbar('Cancelled', 'Your order has been cancelled.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                  ),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
            // Place Order button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to place order
                    showOrderTypeBottomSheet();
                    Get.snackbar(
                      'Order Placed',
                      'Your order has been placed successfully.',
                    );
                    // Navigate to another page or show a success dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                  ),
                  child: Text(
                    'Order',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(FoodMenu item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: CatchNetworkImage(
                imageUrl: item.img!,
                width: 60,
                height: 60,
                fit: BoxFit.fill,
              )),
          title: Text(item.name ?? ''),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.dsc ?? '',
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Quantity controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          cartController.decreaseQuantity(item);
                        },
                      ),
                      // Displaying the current quantity of the item
                      Text(
                          '${item.quantity}'), // Ensure item.quantity is observed
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          cartController.increaseQuantity(item);
                        },
                      ),
                    ],
                  ),
                  // Item price
                  Text(
                    "\$${((item.price ?? 0) * (item.quantity)).toStringAsFixed(2)}", // Ensure item price calculation is observed
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              cartController.removeFromCart(item);
              // Use SnackBar for feedback
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                SnackBar(content: Text('${item.name} removed from cart')),
              );
            },
          ),
        ),
      ),
    );
  }

  void showOrderTypeBottomSheet() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Minimize the height to the content size
          children: [
            const SizedBox(height: 16),
            const Text(
              'Select Order Type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // ChoiceChip for selecting Order Type
            Wrap(
              spacing: 8.0,
              children: orderType.map((type) {
                return Obx(() => ChoiceChip(
                      label: Text(type.name!),
                      selected: cartController.selectedOrderType.value == type,
                      onSelected: (selected) {
                        cartController.selectOrderType(selected ? type : null);
                      },
                      selectedColor: Colors.blueAccent,
                      backgroundColor: Colors.grey[300],
                    ));
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Additional content based on selected order type (e.g., Table selection or Phone number)
            Obx(() {
              if (cartController.selectedOrderType.value?.id == 1) {
                // Din in selected, show table selection
                return Wrap(
                  spacing: 8.0,
                  children: List.generate(10, (index) {
                    int tableNumber = index + 1;
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.table_bar, size: 18),
                          const SizedBox(width: 4),
                          Text('Table $tableNumber'),
                        ],
                      ),
                      selected:
                          cartController.selectedTable.value == tableNumber,
                      onSelected: (selected) {
                        if (selected) {
                          cartController.selectedTable(tableNumber);
                        }
                      },
                      selectedColor: Colors.blueAccent,
                      backgroundColor: Colors.grey[300],
                    );
                  }),
                );
              } else if (cartController.selectedOrderType.value?.id == 2) {
                // Take away selected, show phone number input
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Enter Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      cartController.phoneController.text = value;
                    },
                  ),
                );
              }
              return const SizedBox.shrink(); // Empty if no order type selected
            }),
            const SizedBox(height: 16),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close the bottom sheet
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the next page (e.g., Kitchen Page)
                    if (cartController.selectedOrderType.value != null) {
                      Get.to(() => KitchenPage(
                            orderType: cartController.selectedOrderType.value!,
                            orderItems: cartController.cartItems,
                            phoneNumber: '',
                          ));
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true, // Allows the bottom sheet to be flexible
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}

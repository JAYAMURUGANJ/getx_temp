import 'package:cashcow/model/order.dart';
import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../model/order_type.dart';
import '../../utils/widgets/catch_network_img.dart';

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
            return _emptyCart(context);
          } else {
            return _cartItems();
          }
        },
      ),
      // Bottom navigation bar with Cancel and Place Order buttons
      bottomNavigationBar: _makeOrder(),
    );
  }

  BottomAppBar _makeOrder() {
    return BottomAppBar(
      height: 150, // Slightly increased height for better spacing
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Added padding for a cleaner look
        child: Column(
          children: [
            // Total cost row
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Amount To Pay:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() => Text(
                        '\$${cartController.totalCost.value.toStringAsFixed(2)}', // Dynamic total cost using Obx
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black87, // Slightly darkened for better contrast
                        ),
                      )),
                ],
              ),
            ),
            // cancel or Make order
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //cancel button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logic to cancel the order
                        cartController.clearCart();
                        Get.snackbar(
                          'Order Cancelled',
                          'Your order has been successfully cancelled.',
                          backgroundColor: Colors.redAccent, // Alert color
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.all(8.0),
                        );
                      },
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                        padding: const EdgeInsets.symmetric(
                            vertical: 14), // More padding for larger buttons
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Rounded button corners
                        ),
                      ),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ), // Spacing between buttons
                  10.pw,
                  //order button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logic to place order
                        showOrderTypeBottomSheet();
                        Get.snackbar(
                          'Order Placed',
                          'Your order has been placed successfully.',
                          backgroundColor: Colors.green,
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.all(8.0),
                        );
                      },
                      icon:
                          const Icon(Icons.shopping_cart, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Background color
                        padding: const EdgeInsets.symmetric(
                            vertical: 14), // Larger buttons
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                      label: const Text(
                        'Order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCart(context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.shopping_cart_outlined,
          size: 100,
        ),
        Text(
          'Your cart is empty.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ));
  }

  Widget _cartItems() {
    return ListView.builder(
      itemCount: cartController.cartItems.length,
      itemBuilder: (context, index) {
        var item = cartController.cartItems[index];
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
                ),
              ),
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
                          Text(
                            '${item.quantity}', // Displaying the reactive quantity
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              cartController.increaseQuantity(item);
                            },
                          ),
                        ],
                      ),
                      // Item price (Updated price based on the reactive quantity)
                      Text(
                        "\$${((item.price ?? 0) * (item.quantity)).toStringAsFixed(2)}",
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} removed from cart'),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void showOrderTypeBottomSheet() {
    final formKey = GlobalKey<FormState>(); // Add a form key
    List<Order> orders = [];
    Get.bottomSheet(
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Select Order Type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // ChoiceChip for selecting Order Type
            Wrap(
              spacing: 8.0,
              children: orderType.map(
                (type) {
                  return Obx(
                    () => ChoiceChip(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(type.ico, size: 18),
                          const SizedBox(width: 4),
                          Text("${type.name}"),
                        ],
                      ),
                      selected: cartController.selectedOrderType.value == type,
                      onSelected: (selected) {
                        cartController.selectOrderType(selected ? type : null);
                      },
                      selectedColor: Colors.blueAccent,
                      backgroundColor: Colors.grey[300],
                    ),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 10),
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
                          const Icon(Icons.deck_outlined, size: 18),
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
              }
              return const SizedBox.shrink(); // Empty if no order type selected
            }),
            Form(
              key: formKey, // Attach the form key
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  controller: cartController.phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Proceed if the form is valid
                    if (cartController.selectedOrderType.value != null) {
                      orders.add(Order(
                          type: cartController.selectedOrderType.value!,
                          items: cartController.cartItems,
                          phoneNo: cartController.phoneController.text,
                          tableNo: cartController.selectedTable.value,
                          dateTime: DateTime.now()));
                      debugPrint(orders.length.toString());
                      debugPrint(orders[0].phoneNo.toString());
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Background color
                  padding: const EdgeInsets.symmetric(
                      vertical: 14), // Larger buttons
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Confirm',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
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

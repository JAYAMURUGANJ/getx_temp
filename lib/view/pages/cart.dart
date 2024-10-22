import 'package:cashcow/model/order.dart';
import 'package:cashcow/utils/extension/datetime.dart';
import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/hive/order_controller.dart';
import '../../model/order_menus.dart';
import '../../model/order_type.dart';
import '../../utils/widgets/catch_network_img.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find();
  final OrderServiceController orderService = Get.find();

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
            return _cartItems(context);
          }
        },
      ),
      bottomNavigationBar: _makeOrder(),
    );
  }

  Widget _makeOrder() {
    return Obx(
      () {
        return cartController.cartItems.isNotEmpty
            ? BottomAppBar(
                height: 150, // Slightly increased height for better spacing
                child: Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Added padding for a cleaner look
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Cancel button
                            Row(
                              children: [
                                //cancel the order
                                IconButton(
                                  onPressed: () {
                                    cartController.clearCart();
                                    Get.snackbar(
                                      'Order Cancelled',
                                      'Your order has been successfully cancelled.',
                                      backgroundColor:
                                          Colors.redAccent, // Alert color
                                      snackPosition: SnackPosition.TOP,
                                      margin: const EdgeInsets.all(8.0),
                                    );
                                  },
                                  icon: const Icon(Icons.cancel_outlined,
                                      color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red, // Background color
                                    padding: const EdgeInsets.symmetric(
                                        vertical:
                                            14), // More padding for larger buttons
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded button corners
                                    ),
                                  ),
                                ),
                                //hold the order
                                IconButton(
                                  onPressed: () {
                                    // cartController.clearCart();
                                    // Get.snackbar(
                                    //   'Order Cancelled',
                                    //   'Your order has been successfully cancelled.',
                                    //   backgroundColor:
                                    //       Colors.redAccent, // Alert color
                                    //   snackPosition: SnackPosition.TOP,
                                    //   margin: const EdgeInsets.all(8.0),
                                    // );
                                  },
                                  icon: const Icon(Icons.pause_circle_outline,
                                      color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.blue, // Background color
                                    padding: const EdgeInsets.symmetric(
                                        vertical:
                                            14), // More padding for larger buttons
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded button corners
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Order button
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (cartController.cartItems.isNotEmpty) {
                                    String orderTrackId =
                                        DateTime.now().toOrderId();
                                    try {
                                      // Create the order
                                      Order newOrder = Order(
                                        orderTrackId: orderTrackId,
                                        orderTypeId: cartController
                                            .selectedOrderType.value,
                                        customerName: cartController
                                                .customerNameController
                                                .text
                                                .isNotEmpty
                                            ? cartController
                                                .customerNameController.text
                                            : null,
                                        phoneNo: cartController
                                                .phoneController.text.isNotEmpty
                                            ? cartController
                                                .phoneController.text
                                            : null,
                                        startDateTime: DateTime.now(),
                                        endDateTime:
                                            null, // End time will be updated when t
                                      );
                                      List<OrderMenus> orderMenus =
                                          cartController.cartItems
                                              .map((foodMenu) {
                                        return OrderMenus(
                                          id: foodMenu.id,
                                          img: foodMenu.img,
                                          name: foodMenu.name,
                                          dsc: foodMenu.dsc,
                                          price: foodMenu.price,
                                          rate: foodMenu.rate,
                                          country: foodMenu.country,
                                          quantity: foodMenu.quantity,
                                          // isPrepared: foodMenu.isPrepared,
                                          orderTrackId:
                                              orderTrackId, // Set the same orderTrackId
                                        );
                                      }).toList();
                                      await orderService.createOrder(
                                          newOrder, orderMenus);
                                      orderService.orders.refresh();

                                      // Reset the form and cart after successful creation
                                      cartController.clearCart();
                                      cartController.customerNameController
                                          .clear();
                                      cartController.phoneController.clear();

                                      Get.offAndToNamed("/kitchen");

                                      Get.snackbar(
                                        'Order Placed',
                                        'Your order has been placed successfully.',
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.TOP,
                                        margin: const EdgeInsets.all(8.0),
                                      );
                                    } catch (e) {
                                      Get.snackbar(
                                        'Error',
                                        'Failed to place order: ${e.toString()}',
                                        backgroundColor: Colors.red,
                                        snackPosition: SnackPosition.TOP,
                                        margin: const EdgeInsets.all(8.0),
                                      );
                                    }
                                  } else {
                                    Get.snackbar(
                                      'Warning',
                                      'Please select an order type and add items to the cart.',
                                      backgroundColor: Colors.orange,
                                      snackPosition: SnackPosition.TOP,
                                      margin: const EdgeInsets.all(8.0),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.shopping_cart,
                                    color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.green, // Background color
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14), // Larger buttons
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
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
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _emptyCart(BuildContext context) {
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
      ),
    );
  }

  Widget _cartItems(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTileTheme(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          selectedColor: Colors.grey,
          child: Obx(() {
            var totalOrders = orderService.getAllOrdersList().length + 1;
            return ListTile(
              leading: Container(
                width: 60,
                height: 50,
                color: cartController.selectedOrderType.value == 1
                    ? Colors.green
                    : Colors.orange,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      orderType[cartController.selectedOrderType.value - 1]
                          .name!
                          .toUpperCase(),
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
              title: Row(
                children: [
                  const Icon(Icons.person),
                  Text(
                    cartController.customerNameController.text.isNotEmpty
                        ? cartController.customerName.string
                        : "Id: $totalOrders",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.smartphone_outlined, size: 15),
                  Text(cartController.phoneController.text.isNotEmpty
                      ? cartController.phoneNumber.string
                      : "Phone Number"),
                ],
              ),
              trailing: IconButton(
                onPressed: () => updateUserandOrderType(),
                icon: const Icon(Icons.edit_note_sharp),
              ),
            );
          }),
        ),
        const Divider(),
        Expanded(
          child: ListView.separated(
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              var item = cartController.cartItems[index];
              return ListTileTheme(
                contentPadding: const EdgeInsets.all(
                    4.0), // Adjusted padding for better spacing
                child: ListTile(
                  leading: SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CatchNetworkImage(
                        imageUrl: item.img ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit
                            .cover, // Ensure image covers the container without distortion
                      ),
                    ),
                  ),
                  title: Text(
                    item.name ??
                        'Unnamed Item', // Added fallback for empty name
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            FontWeight.bold), // Bolder font for the item name
                    overflow:
                        TextOverflow.ellipsis, // Handle long names gracefully
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '( ${item.quantity}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.grey[
                                      600]), // Consistent small text styling
                        ),
                        4.pw,
                        const Text('x'),
                        4.pw,
                        Text(
                          '${item.price} )',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Center elements vertically
                    children: [
                      //Item quantity changer
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                              ),
                              onPressed: () {
                                cartController.decreaseQuantity(item);
                              },
                              splashRadius:
                                  10, // Reduced splash radius for a more compact button
                            ),
                            Text(
                              '${item.quantity}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium, // Consistent text style for quantity
                              overflow: TextOverflow.fade,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                              ),
                              onPressed: () {
                                cartController.increaseQuantity(item);
                              },
                              splashRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      // Adjusted spacing
                      //item total amount
                      Flexible(
                        child: Text(
                          '\$ ${(item.price! * item.quantity).toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold, // Bolder price
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      ],
    );
  }

  void updateUserandOrderType() {
    final formKey = GlobalKey<FormState>();
    Get.bottomSheet(
      backgroundColor: Colors.white,
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Customer Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                10.ph,
                TextFormField(
                  controller: cartController.customerNameController,
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                10.ph,
                TextFormField(
                  controller: cartController.phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                20.ph,
                const Text(
                  'Select Order Type',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                10.ph,
                Obx(
                  () => Column(
                    children: orderType.map((type) {
                      return RadioListTile(
                        title: Text(type.name ?? ''),
                        value: type.id,
                        groupValue: cartController.selectedOrderType.value,
                        onChanged: (value) {
                          cartController.selectedOrderType(value);
                        },
                      );
                    }).toList(),
                  ),
                ),
                20.ph,
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      // Update the observable values in the CartController
                      cartController.customerName.value =
                          cartController.customerNameController.text;
                      cartController.phoneNumber.value =
                          cartController.phoneController.text;
                      cartController.selectOrderType(
                          cartController.selectedOrderType.value);

                      // Update the form fields with new values
                      cartController.updateCustomerDetails();

                      Get.back(); // Close the bottom sheet
                    } else {
                      Get.snackbar(
                        'Invalid Input',
                        'Please fill in all required fields.',
                        backgroundColor: Colors.redAccent,
                        snackPosition: SnackPosition.TOP,
                        margin: const EdgeInsets.all(8.0),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/cart_controller.dart';

class KCartIcon extends StatelessWidget {
  const KCartIcon({
    super.key,
    required this.cartController,
  });

  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        icon: cartController.cartItems.isNotEmpty
            ? Badge.count(
                count: cartController
                    .cartItems.length, // Display the total quantity of items
                child: const Icon(
                  Icons.shopping_cart,
                ),
              )
            : const Icon(
                Icons.shopping_cart_outlined,
              ),
        onPressed: () => Get.toNamed("/cart"),
      ),
    );
  }
}

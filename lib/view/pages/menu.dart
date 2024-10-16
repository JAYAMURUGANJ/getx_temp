import 'package:cashcow/model/food_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/food_menu_controller.dart';
import '../../utils/widgets/catch_network_img.dart';
import 'cart.dart';

class MenuPage extends StatefulWidget {
  final FoodCategory category;
  const MenuPage({super.key, required this.category});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final FoodMenuController controller = Get.put(FoodMenuController());

  @override
  void initState() {
    super.initState();
    controller.loadMenuFromCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category.name.capitalize} Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.to(() => CartPage()),
          )
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.foodMenuList.length,
          itemBuilder: (context, index) {
            var item = controller.foodMenuList[index];
            return Card(
              child: ListTile(
                leading: CatchNetworkImage(
                  imageUrl: item.img ?? "",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),

                title: Text(item.name ?? ''),
                subtitle: Text(item.dsc ?? ''),
                //  trailing: Text("\$${item.price}"),
                onTap: () {
                  Get.find<CartController>().addToCart(item);
                  Get.snackbar('Added to Cart', '${item.name}');
                },
              ),
            );
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import '../../model/food_menu.dart';
import '../../model/order_type.dart';

class KitchenPage extends StatefulWidget {
  final OrderType orderType;
  final List<FoodMenu> orderItems;

  const KitchenPage(
      {super.key,
      required this.orderType,
      required this.orderItems,
      int? tableNumber,
      required String phoneNumber});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.orderType.name} Orders'),
      ),
      body: ListView.builder(
        itemCount: widget.orderItems.length,
        itemBuilder: (context, index) {
          var item = widget.orderItems[index];
          return ListTile(
            leading: Image.network(item.img ?? ''),
            title: Text(item.name ?? ''),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing:
                Text('\$${(item.price! * item.quantity).toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}

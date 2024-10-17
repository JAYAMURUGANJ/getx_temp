// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'food_menu.dart';
import 'order_type.dart';

class Order {
  final OrderType type;
  final List<FoodMenu> items;
  final String? phoneNo;
  final int? tableNo;
  final DateTime dateTime;
  Order({
    required this.type,
    required this.items,
    required this.phoneNo,
    required this.tableNo,
    required this.dateTime,
  });
}

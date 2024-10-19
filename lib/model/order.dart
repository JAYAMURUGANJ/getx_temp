// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'food_menu.dart';

part 'order.g.dart';

@HiveType(typeId: 3) // Ensure typeId is unique
class Order {
  @HiveField(0)
  final int orderTypeId;

  @HiveField(1)
  final List<FoodMenu> items;

  @HiveField(2)
  final String? phoneNo;

  @HiveField(3)
  final int? tableNo;

  @HiveField(4)
  final DateTime startDateTime;

  @HiveField(5)
  DateTime? endDateTime;

  @HiveField(6)
  int? orderStatus;

  @HiveField(7)
  int? payementStatus;

  @HiveField(8)
  final String? customerName;

  @HiveField(9)
  final String? orderTrackId;

  Order({
    required this.orderTypeId,
    required this.items,
    required this.phoneNo,
    required this.tableNo,
    required this.startDateTime,
    required this.endDateTime,
    required this.orderStatus,
    required this.payementStatus,
    required this.customerName,
    required this.orderTrackId,
  });
}

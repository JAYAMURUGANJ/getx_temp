import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'order_type.g.dart';

@HiveType(typeId: 4)
class OrderType {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  IconData? ico;

  OrderType({
    this.id,
    this.name,
    this.ico,
  });
}

// Example list of OrderType objects with icon code points
final List<OrderType> orderType = [
  OrderType(id: 1, name: "Din In", ico: Icons.deck_outlined),
  OrderType(id: 2, name: "Take Away", ico: Icons.takeout_dining_outlined),
];

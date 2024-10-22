import 'package:hive/hive.dart';

part 'order_status.g.dart';

@HiveType(typeId: 3)
class OrderStatus {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  OrderStatus({
    this.id,
    this.name,
  });
}

final List<OrderStatus> getOrderStatusList = [
  OrderStatus(id: 1, name: "CONFIRMED"),
  OrderStatus(id: 2, name: "COOKING"),
  OrderStatus(id: 3, name: "COMPLETED"),
  OrderStatus(id: 4, name: "CANCELLED"),
  OrderStatus(id: 5, name: "HOLDING"),
];

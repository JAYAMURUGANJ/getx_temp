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

final List<OrderStatus> orderStatusList = [
  OrderStatus(id: 1, name: "pending"),
  OrderStatus(id: 2, name: "cooking"),
  OrderStatus(id: 3, name: "ready to serve"),
  OrderStatus(id: 4, name: "packed"),
  OrderStatus(id: 5, name: "ready to deliver"),
];

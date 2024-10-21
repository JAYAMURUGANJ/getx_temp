// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 5) // Ensure typeId is unique
class Order {
  @HiveField(0)
  final int orderTypeId;

  @HiveField(1)
  final String? phoneNo;

  @HiveField(2)
  final int tableNo;

  @HiveField(3)
  final DateTime startDateTime;

  @HiveField(4)
  DateTime? endDateTime;

  @HiveField(5)
  int? orderStatus;

  @HiveField(6)
  int? payementStatus;

  @HiveField(7)
  final String? customerName;

  @HiveField(8)
  final String? orderTrackId;

  Order({
    required this.orderTypeId,
    required this.phoneNo,
    this.tableNo = 1,
    required this.startDateTime,
    required this.endDateTime,
    required this.orderStatus,
    required this.payementStatus,
    required this.customerName,
    required this.orderTrackId,
  });

  // copyWith method for creating a modified instance of Order
  Order copyWith({
    int? orderTypeId,
    String? phoneNo,
    int? tableNo,
    DateTime? startDateTime,
    DateTime? endDateTime,
    int? orderStatus,
    int? payementStatus,
    String? customerName,
    String? orderTrackId,
  }) {
    return Order(
      orderTypeId: orderTypeId ?? this.orderTypeId,
      phoneNo: phoneNo ?? this.phoneNo,
      tableNo: tableNo ?? this.tableNo,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      orderStatus: orderStatus ?? this.orderStatus,
      payementStatus: payementStatus ?? this.payementStatus,
      customerName: customerName ?? this.customerName,
      orderTrackId: orderTrackId ?? this.orderTrackId,
    );
  }
}

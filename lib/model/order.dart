// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 9) // Ensure typeId is unique
class Order {
  @HiveField(0)
  final int orderTypeId;

  @HiveField(1)
  final String? phoneNo;

  @HiveField(2)
  final DateTime startDateTime;

  @HiveField(3)
  DateTime? endDateTime;

  @HiveField(4)
  int orderStatusId;

  @HiveField(5)
  int payementStatusId;

  @HiveField(6)
  final String? customerName;

  @HiveField(7)
  final String? orderTrackId;

  @HiveField(8)
  int paymentTypeId;

  Order({
    required this.orderTypeId,
    required this.phoneNo,
    required this.startDateTime,
    required this.endDateTime,
    this.orderStatusId = 1,
    this.payementStatusId = 1,
    required this.customerName,
    required this.orderTrackId,
    this.paymentTypeId = 1,
  });

  // Factory constructor for creating an empty Order object
  factory Order.empty() {
    return Order(
      orderTypeId: 0, // or any default value you see fit
      phoneNo: null,
      startDateTime: DateTime.now(), // or any default value you see fit
      endDateTime: null,
      orderStatusId: 1,
      payementStatusId: 1,
      customerName: null,
      orderTrackId: null,
      paymentTypeId: 1,
    );
  }

  // copyWith method for creating a modified instance of Order
  Order copyWith({
    int? orderTypeId,
    String? phoneNo,
    DateTime? startDateTime,
    DateTime? endDateTime,
    int? orderStatusId,
    int? payementStatusId,
    String? customerName,
    String? orderTrackId,
    int? paymentTypeId,
  }) {
    return Order(
      orderTypeId: orderTypeId ?? this.orderTypeId,
      phoneNo: phoneNo ?? this.phoneNo,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      orderStatusId: orderStatusId ?? this.orderStatusId,
      payementStatusId: payementStatusId ?? this.payementStatusId,
      customerName: customerName ?? this.customerName,
      orderTrackId: orderTrackId ?? this.orderTrackId,
      paymentTypeId: paymentTypeId ?? this.paymentTypeId,
    );
  }
}

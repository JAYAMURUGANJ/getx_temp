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
  int orderStatusId;

  @HiveField(6)
  int payementStatusId;

  @HiveField(7)
  final String? customerName;

  @HiveField(8)
  final String? orderTrackId;

  @HiveField(9)
  int paymentTypeId;

  Order({
    required this.orderTypeId,
    required this.phoneNo,
    this.tableNo = 1,
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
      tableNo: 1,
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
    int? tableNo,
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
      tableNo: tableNo ?? this.tableNo,
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

import 'package:hive/hive.dart';

part 'payment_status_type.g.dart';

@HiveType(typeId: 6)
class PaymentStatusType {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  PaymentStatusType({
    this.id,
    this.name,
  });
}

final List<PaymentStatusType> getPaymentStatusTypes = [
  PaymentStatusType(id: 1, name: "TAP TO PAY"),
  PaymentStatusType(id: 2, name: "PAID"),
];

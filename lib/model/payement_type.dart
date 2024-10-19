import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'payement_type.g.dart';

@HiveType(typeId: 2)
class PaymentType {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  IconData? ico;

  PaymentType({
    this.id,
    this.name,
    this.ico,
  });
}

final List<PaymentType> getPaymentTypes = [
  PaymentType(id: 1, name: "cash", ico: Icons.money),
  PaymentType(id: 2, name: "card", ico: Icons.credit_card),
  PaymentType(id: 3, name: "upi", ico: Icons.mobile_friendly),
];

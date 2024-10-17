// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class OrderType {
  int? id;
  String? name;
  IconData? ico;

  OrderType({
    this.id,
    this.name,
    this.ico,
  });
}

final List<OrderType> orderType = [
  OrderType(id: 1, name: "Din In", ico: Icons.deck_outlined),
  OrderType(id: 2, name: "Take Away", ico: Icons.takeout_dining_outlined),
];

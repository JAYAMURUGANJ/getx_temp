// Build the order status card
import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:flutter/material.dart';

Widget buildOrderStatusCard(String title, int count, Color color) {
  return Card(
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          5.ph,
          Text(
            count.toString(),
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

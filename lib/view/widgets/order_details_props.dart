import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/order.dart';
import '../../model/order_status.dart';
import '../../model/order_type.dart';

class OrderDetailsCard extends StatefulWidget {
  final Order order;
  const OrderDetailsCard({super.key, required this.order});

  @override
  State<OrderDetailsCard> createState() => _OrderDetailsCardState();
}

class _OrderDetailsCardState extends State<OrderDetailsCard> {
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('MMMM dd, yyyy, hh:mm a').format(widget.order.startDateTime);
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Order Type
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0)),
            child: Container(
              width: 60,
              height: 100,
              color:
                  widget.order.orderTypeId == 1 ? Colors.green : Colors.orange,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                  child: Text(
                    orderType[widget.order.orderTypeId - 1].name!.toUpperCase(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          //Order Id & customer details & date time information
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${widget.order.orderTrackId}",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                  Text(
                    "${widget.order.customerName}",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "${widget.order.phoneNo}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  //Date Time
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          //Payment and Order status
          OrderStatusIndicator(orderStatusId: widget.order.orderStatusId)
        ],
      ),
    );
  }
}

class OrderStatusIndicator extends StatefulWidget {
  final int orderStatusId;
  const OrderStatusIndicator({super.key, required this.orderStatusId});

  @override
  State<OrderStatusIndicator> createState() => _OrderStatusIndicatorState();
}

class _OrderStatusIndicatorState extends State<OrderStatusIndicator> {
  @override
  Widget build(BuildContext context) {
    int id = widget.orderStatusId;
    String statusText =
        getOrderStatusList.firstWhere((data) => data.id == id).name.toString();
    Color color = id == 1
        ? Colors.amber
        : id == 2
            ? Colors.orangeAccent
            : id == 3
                ? Colors.greenAccent
                : id == 4
                    ? Colors.redAccent
                    : id == 5
                        ? Colors.blueAccent
                        : Colors.amber;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(vertical: 5),
        width: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            statusText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

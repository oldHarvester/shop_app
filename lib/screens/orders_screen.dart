import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.items.length,
        itemBuilder:(context, index) {
          return OrderItem(orderData.items[index]);
        },
      ),
    );
  }
}

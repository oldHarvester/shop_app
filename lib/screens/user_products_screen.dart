import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // ...
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: productsData.items.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              UserProductItem(
                title: productsData.items[index].title,
                imageUrl: productsData.items[index].imageUrl,
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
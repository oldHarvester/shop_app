import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../models/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';

enum FiltersOptions {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOptions value) {
              setState(
                () {
                  if (value == FiltersOptions.favorites) {
                    _showFavorites = true;
                  } else {
                    _showFavorites = false;
                  }
                },
              );
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: FiltersOptions.favorites,
                  child: Text('Only Favorites'),
                ),
                const PopupMenuItem(
                  value: FiltersOptions.all,
                  child: Text('Show all'),
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: child!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductsGrid(_showFavorites),
      drawer: AppDrawer(),
    );
  }
}

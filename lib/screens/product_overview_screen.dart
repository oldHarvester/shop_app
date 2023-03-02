import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../models/cart.dart';
import '../models/products.dart';
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
  var _initValues = false;

  Future<void> _obtainFuture() {
    return Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void initState() {
    setState(() {
      _initValues = true;
    });
    _obtainFuture().catchError((error) {
      showSnackBar(context);
    }).then((_) {
      setState(() {
        _initValues = false;
      });
    });
    super.initState();
  }

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
      body: RefreshIndicator(
        onRefresh: () async {
          await _obtainFuture().catchError((error) => showSnackBar(context));
        },
        child: _initValues
            ? const Center(child: CircularProgressIndicator())
            : ProductsGrid(_showFavorites),
      ),
      drawer: AppDrawer(),
    );
  }
}

void showSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Some error occurred. Try again later.',
        textAlign: TextAlign.center,
      ),
    ),
  );
}

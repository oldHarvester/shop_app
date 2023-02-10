import 'package:flutter/material.dart';

class CartItem {
  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });

  final String id;
  final String title;
  final double price;
  final int quantity;
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    // return _items.length;
    var totalCount = 0;
    _items.values.forEach((element) {
      totalCount += element.quantity;
    });
    return totalCount;
  }

  double totalAmount() {
    var total = 0.0;
    _items.forEach(
      (key, value) => total += value.price * value.quantity,
    );
    return total;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) {
          return CartItem(
            id: existingItem.id,
            price: existingItem.price,
            title: existingItem.title,
            quantity: existingItem.quantity - 1,
          );
        },
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addItem({
    required String productId,
    required String title,
    required double price,
  }) {
    final product = _items[productId];
    if (product != null) {
      _items[productId] = CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          quantity: product.quantity + 1);
    } else {
      _items[productId] = CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  // void addItem({
  //   required String productId,
  //   required String title,
  //   required double price,
  // }) {
  //   if (_items.containsKey(productId)) {
  //     _items.update(
  //       productId,
  //       (existingCartItem) => CartItem(
  //           id: productId,
  //           title: title,
  //           price: price,
  //           quantity: existingCartItem.quantity),
  //     );
  //   } else {
  //     _items.putIfAbsent(
  //       productId,
  //       () => CartItem(
  //         id: DateTime.now().toString(),
  //         title: title,
  //         price: price,
  //         quantity: 1,
  //       ),
  //     );
  //   }
  // }
}

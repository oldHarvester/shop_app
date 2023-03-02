import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem {
  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-update-60b58-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    final List<OrderItem> orderItems = [];
    final extractedData = json.decode(response.body) == null ? null : json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((key, value) {
      orderItems.add(OrderItem(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>).map((cartItem) {
            return CartItem(
              id: cartItem['id'],
              title: cartItem['title'],
              price: cartItem['price'],
              quantity: cartItem['quantity'],
            );
          }).toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });

    _items = orderItems.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final dateTime = DateTime.now();
    final url = Uri.parse(
        'https://flutter-update-60b58-default-rtdb.firebaseio.com/orders.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': dateTime.toIso8601String(),
            'products': cartProducts
                .map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'price': item.price,
                      'quantity': item.quantity,
                    })
                .toList(),
          },
        ),
      );
      _items.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: dateTime,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}

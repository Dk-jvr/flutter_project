import 'package:flutter/material.dart';
import '../beer_data.dart';

class CartItem {
  final Beer beer;
  final double liters;

  CartItem({required this.beer, required this.liters});
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Beer beer, double liters) {
    _cartItems.add(CartItem(beer: beer, liters: liters));
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(Beer beer) {
    return _cartItems.any((item) => item.beer.id == beer.id);
  }
}

import 'dart:collection';

import 'package:flutter/material.dart';

import '../core/product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;
}

class CartStore extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  UnmodifiableListView<CartItem> get items =>
      UnmodifiableListView<CartItem>(_items.values);

  double get totalPrice => _items.values.fold(
        0,
        (previousValue, item) =>
            previousValue + item.product.price * item.quantity,
      );

  void addProduct(Product product, {int quantity = 1}) {
    final key = _productKey(product);
    final existing = _items[key];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items[key] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void changeQuantity(Product product, int delta) {
    final key = _productKey(product);
    final item = _items[key];
    if (item == null) return;

    item.quantity += delta;
    if (item.quantity <= 0) {
      _items.remove(key);
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.remove(_productKey(product));
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  String _productKey(Product product) => product.name;
}

class CartProvider extends InheritedNotifier<CartStore> {
  const CartProvider({
    super.key,
    required CartStore store,
    required Widget child,
  }) : super(notifier: store, child: child);

  static CartStore of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider not found in context');
    return provider!.notifier!;
  }
}

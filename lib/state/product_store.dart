import 'dart:collection';

import 'package:flutter/material.dart';

import '../core/product.dart';

class ProductStore extends ChangeNotifier {
  ProductStore() {
    _products.addAll([
      const Product(
        name: 'Baby Boy Bodysuits Set',
        description:
            'Soft cotton bodysuits that keep your baby comfortable all day long.',
        price: 45.00,
        imageAsset: 'assets/images/Ttotoy_1.webp',
        size: '0-3M',
        color: 'Gray',
      ),
      const Product(
        name: 'Baby boy bottle',
        description: 'Pelletentesque habit...baby bottle with silicone nipple.',
        price: 12.00,
        imageAsset: 'assets/images/Ttotoy_2.webp',
        size: '0-3M',
        color: 'Gray',
      ),
      const Product(
        name: 'Baby boy toy',
        description: 'Sed ac eurt cutabular et. Soft plush toy for tummy time.',
        price: 44.00,
        imageAsset: 'assets/images/Ttotoy_3.webp',
        size: '3-6M',
        color: 'Yellow',
      ),
      const Product(
        name: 'Baby jute toys',
        description: 'Suspendisse sollicitudin classic toy bundle.',
        price: 54.00,
        imageAsset: 'assets/images/Ttotoy_4.webp',
        size: '6-12M',
        color: 'Pink',
      ),
    ]);
  }

  final List<Product> _products = [];

  UnmodifiableListView<Product> get products =>
      UnmodifiableListView<Product>(_products);

  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }
}

class ProductProvider extends InheritedNotifier<ProductStore> {
  const ProductProvider({
    super.key,
    required ProductStore store,
    required super.child,
  }) : super(notifier: store);

  static ProductStore of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ProductProvider>();
    assert(provider != null, 'ProductProvider not found in context');
    return provider!.notifier!;
  }
}

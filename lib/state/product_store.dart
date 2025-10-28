import 'dart:collection';

import 'package:flutter/material.dart';

import '../core/product.dart';

class ProductStore extends ChangeNotifier {
  ProductStore() {
    _products.addAll([
      const Product(
        name: '별모양 벨소리 장난감',
        description: '버튼을 누르면 삐용삐용 소리가 나요',
        price: 45000,
        imageAsset: 'assets/images/Ttotoy_1.webp',
        inventory: 5,
        size: '0-3M',
        color: '노랑색',
      ),
      const Product(
        name: '케이크모양 장난감',
        description: '버튼을 누르면 삐용삐용 소리가 나요',
        price: 12000,
        imageAsset: 'assets/images/Ttotoy_2.webp',
        inventory: 10,
        size: '0-3M',
        color: '흰색',
      ),
      const Product(
        name: '뽀로로 장난감',
        description: '버튼을 누르면 뽀로로가 노래를 불러요',
        price: 44000,
        imageAsset: 'assets/images/Ttotoy_3.webp',
        inventory: 8,
        size: '3-6M',
        color: '노란색',
      ),
      const Product(
        name: '주사위 장난감',
        description: '주사위의 모든면에 버튼을 누르면 소리가 나요',
        price: 54000,
        imageAsset: 'assets/images/Ttotoy_4.webp',
        inventory: 4,
        size: '6-12M',
        color: '빨강',
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

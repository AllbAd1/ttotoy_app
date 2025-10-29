import 'dart:collection'; // UnmodifiableListView 사용을 위해 기입.

import 'package:flutter/material.dart'; // Flutter 기본 패키지 임포트

import '../core/product.dart'; // Product 모델 임포트

class ProductStore extends ChangeNotifier { // ChangeNotifier 상속
  ProductStore() {
    // 생성자에서 샘플 데이터 추가 (기존 코드 유지)
    _products.addAll([ // 샘플 상품 데이터
      const Product(
        name: '별모양 벨소리 장난감',
        description: '버튼을 누르면 삐용삐용 소리가 나요',
        price: 45000,
        imageAsset: 'assets/images/Ttotoy_1.webp',
        inventory: 5,
        size: '0~3개월',
      ),
      const Product(
        name: '케이크모양 장난감',
        description: '버튼을 누르면 삐용삐용 소리가 나요',
        price: 12000,
        imageAsset: 'assets/images/Ttotoy_2.webp',
        inventory: 10,
        size: '0~3개월',
      ),
      const Product(
        name: '뽀로로 장난감',
        description: '버튼을 누르면 뽀로로가 노래를 불러요',
        price: 44000,
        imageAsset: 'assets/images/Ttotoy_3.webp',
        inventory: 8,
        size: '3~6개월',
      ),
      const Product(
        name: '주사위 장난감',
        description: '주사위의 모든면에 버튼을 누르면 소리가 나요',
        price: 54000,
        imageAsset: 'assets/images/Ttotoy_4.webp',
        inventory: 4,
        size: '6~12개월',
      ),
    ]);
  }

  final List<Product> _products = []; // 내부 상품 리스트

  UnmodifiableListView<Product> get products =>
      UnmodifiableListView<Product>(_products); // 외부에 읽기 전용 리스트 제공

  // 새 상품 추가 로직 (기존 코드 유지)
  void addProduct(Product product) {
    _products.insert(0, product); // 리스트 맨 앞에 추가
    notifyListeners(); // 상태 변경 알림
  }

  // ★★★ 상품 이름으로 Product 객체 찾기 함수 추가 ★★★
  Product? findProductByName(String name) {
    try {
      // 이름이 같은 첫 번째 상품 반환
      return _products.firstWhere((p) => p.name == name);
    } catch (e) {
      // 상품을 찾지 못하면 null 반환
      return null;
    }
  }
  // ★★★ (여기까지 추가) ★★★

  // ★★★ 재고 업데이트 함수 (Debug Print 추가) ★★★
  void updateInventory(Product product, int delta) {
    debugPrint("updateInventory called for ${product.name}, delta: $delta"); // <-- 로그 추가

    final index = _products.indexWhere((p) => p.name == product.name);

    if (index != -1) {
      final currentInventory = _products[index].inventory;
      final newInventory = currentInventory + delta;
      final finalInventory = newInventory < 0 ? 0 : newInventory;

      debugPrint("Updating inventory for ${product.name}: $currentInventory -> $finalInventory"); // <-- 로그 추가

      _products[index] = Product(
        name: _products[index].name,
        description: _products[index].description,
        price: _products[index].price,
        imageAsset: _products[index].imageAsset,
        inventory: finalInventory, // 업데이트된 재고 적용
        size: _products[index].size,
        // color: _products[index].color, // color 필드가 있다면 포함
      );

      notifyListeners(); // 상태 변경을 알립니다.
      debugPrint("notifyListeners called from ProductStore after inventory update."); // <-- 로그 추가
    } else {
      debugPrint('Error: Product not found in ProductStore for inventory update - ${product.name}');
    }
  }
  // ★★★ (여기까지 수정) ★★★

} // ProductStore 클래스 끝

// ProductProvider 구현 (기존 코드 유지)
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

import 'dart:collection'; // UnmodifiableListView 사용을 위해 기입.
import 'package:flutter/material.dart'; // Flutter 기본 패키지 임포트
import '../core/product.dart'; // Product 모델 임포트
import '../state/product_store.dart'; // ★★★ ProductStore import는 유지 (재고 확인용) ★★★
import 'package:intl/intl.dart'; // 원화 포맷을 위해 import 추가

//    가격을 ₩20,000 형식의 문자열로 변환하는 함수
String formatCurrency(double price) {
  final formatter = NumberFormat.currency(
    locale: 'ko_KR', //   한국 로케일 사용 (통화 기호와 쉼표 사용)
    symbol: '₩',    //    통화 기호는 원화 기호(₩)
    decimalDigits: 0, //    소수점 이하 자리수는 0 (정수만 표시)
  );
  return formatter.format(price);
}


class CartItem { // CartItem 클래스 정의
  CartItem({required this.product, this.quantity = 1});

  final Product product; // 상품 정보
  int quantity;
}

class CartStore extends ChangeNotifier {
  // ★★★ ProductStore 참조는 유지 (재고 확인용) ★★★
  final ProductStore _productStore;
  CartStore(this._productStore); // 생성자에서 ProductStore 인스턴스 받기

  final Map<String, CartItem> _items = {}; // 상품 이름을 키로 하는 장바구니 아이템 맵

  UnmodifiableListView<CartItem> get items =>
      UnmodifiableListView<CartItem>(_items.values); // 읽기 전용 장바구니 아이템 리스트

  double get totalPrice => _items.values.fold( // 장바구니 총 가격 계산
        0,
        (previousValue, item) =>
            previousValue + item.product.price * item.quantity, // 각 아이템의 가격 * 수량 합산
      );

  bool addProduct(Product product, {int quantity = 1}) {
    final key = _productKey(product);
    final existing = _items[key];
    final currentQuantity = existing?.quantity ?? 0;
    final newQuantity = currentQuantity + quantity;

    // ★★★ ProductStore에서 최신 재고 확인 (유지) ★★★
    final currentProductState = _productStore.findProductByName(product.name);
    if (currentProductState == null) {
      debugPrint("Error: Product ${product.name} not found in ProductStore during add.");
      return false; // ProductStore에 상품이 없으면 추가 불가
    }
    final currentInventory = currentProductState.inventory;
    // ★★★

    // 최신 재고 기준으로 확인 (유지)
    if (newQuantity > currentInventory) {
      return false; // 재고 부족
    }

    if (existing != null) {
      existing.quantity = newQuantity;
    } else {
      _items[key] = CartItem(product: currentProductState, quantity: newQuantity);
    }

    // ★★★ ProductStore 재고 업데이트 호출 제거 ★★★
    // _productStore.updateInventory(product, -quantity); // <-- 삭제

    notifyListeners();
    return true;
  }

  bool changeQuantity(Product product, int delta) {
    final key = _productKey(product);
    final item = _items[key];
    if (item == null) return false;

    final updatedQuantity = item.quantity + delta;

    // 최소 수량 1 유지
    if (updatedQuantity <= 0) {
      // ★★★ removeProduct 호출 시 내부에서 재고 복원 로직 제거됨 ★★★
      removeProduct(product); // 수량이 0 이하면 제거
      return true; // 제거는 성공으로 간주
    }

    // ★★★ ProductStore에서 최신 재고 확인 (유지) ★★★
    final currentProductState = _productStore.findProductByName(product.name);
    if (currentProductState == null) {
      debugPrint("Error: Product ${product.name} not found in ProductStore during change quantity.");
      return false;
    }
    final currentInventory = currentProductState.inventory;
    // ★★★

    // 최신 재고 기준으로 확인 (유지)
     if (updatedQuantity > currentInventory) {
       return false; // 재고 초과
     }

    item.quantity = updatedQuantity;

    // ★★★ ProductStore 재고 업데이트 호출 제거 ★★★
    // _productStore.updateInventory(product, -delta); // <-- 삭제

    notifyListeners();
    return true;
  }

  void removeProduct(Product product) {
    final key = _productKey(product);
    final item = _items[key];
    if (item != null) {
      // ★★★ ProductStore 재고 복원 호출 제거 ★★★
      // _productStore.updateInventory(product, item.quantity); // <-- 삭제
      _items.remove(key);
      notifyListeners();
    }
  }

  void clear() {
     // ★★★ ProductStore 재고 복원 호출 제거 ★★★
    // for (var item in _items.values) {
    //   _productStore.updateInventory(item.product, item.quantity);
    // }
    _items.clear();
    notifyListeners();
  }

  String _productKey(Product product) => product.name; // ID 필드가 있다면 그것을 사용하는 것이 더 안전합니다.
}

class CartProvider extends InheritedNotifier<CartStore> {
  const CartProvider({
    super.key,
    required CartStore store,
    required super.child,
  }) : super(notifier: store);

  static CartStore of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider not found in context');
    return provider!.notifier!;
  }
}


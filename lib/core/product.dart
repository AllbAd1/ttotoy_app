class Product {
  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    // inventory를 필수 매개변수로 하나만 정의합니다.
    required this.inventory, 
    // size와 color는 선택적 매개변수로 정의합니다.
    this.size = '', 
    this.color = '', 
  });

  final String name;
  final String description;
  final double price;
  final String imageAsset;
  final int inventory; // 필드 역시 하나만 정의됩니다.
  final String size;
  final String color;
}

class CartItem {
  CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;
}
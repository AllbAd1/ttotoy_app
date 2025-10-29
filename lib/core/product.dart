// Product 모델 (데이터 구조) 정의
class Product {
  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageAssets, // ★★★ imageAssets (List<String>)로 사용 ★★★
    required this.inventory,
    this.size = '',
    // this.color = '', // color 필드는 사용하지 않으므로 주석 처리 (기존 코드 반영)
  });

  final String name;
  final String description;
  final double price;
  final List<String> imageAssets; // ★★★ String -> List<String>으로 변경 ★★★
  final int inventory;
  final String size;
  // final String color;
}

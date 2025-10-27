class Product {
  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    this.size = '0-3M',
    this.color = 'Gray',
  });

  final String name;
  final String description;
  final double price;
  final String imageAsset;
  final String size;
  final String color;
}

class Product {
  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.inventory,
    this.size = '',
    this.color = '',
    
  });

  final String name;
  final String description;
  final double price;
  final String imageAsset;
  final int inventory;
  final String size;
  final String color;
  
}

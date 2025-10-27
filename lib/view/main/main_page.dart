import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../core/product.dart';
import '../cart/cart_page.dart';
import '../ttotoy_detail/ttotoy_detail_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static final List<Product> _products = [
    const Product(
      name: 'Baby boy bottle',
      description: 'Pelletentesque habit...baby bottle with silicone nipple.',
      price: 12.00,
      imageAsset: 'assets/images/Ttotoy_logo.webp',
      size: '0-3M',
      color: 'Gray',
    ),
    const Product(
      name: 'Baby boy toy',
      description: 'Sed ac eurt cutabular et. Soft plush toy for tummy time.',
      price: 44.00,
      imageAsset: 'assets/images/Ttotoy_under_title.webp',
      size: '3-6M',
      color: 'Yellow',
    ),
    const Product(
      name: 'Baby jute toys',
      description: 'Suspendisse sollicitudin classic toy bundle.',
      price: 54.00,
      imageAsset: 'assets/images/mom_and_baby.webp',
      size: '6-12M',
      color: 'Pink',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'TtoToy',
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            color: AppColors.descriptionGray,
            onPressed: () => _openCart(context, null),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchBar(theme: theme),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return _ProductCard(
                    product: product,
                    onTap: () => _openDetail(context, product),
                    onAdd: () => _openCart(context, product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: AppColors.primaryPeach,
        unselectedItemColor: AppColors.descriptionGray,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
        ],
        onTap: (index) => _handleBottomNavTap(context, index),
      ),
    );
  }

  void _openDetail(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: product),
      ),
    );
  }

  void _openCart(BuildContext context, Product? product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CartPage(
          initialItems: product == null
              ? null
              : [
                  CartItem(product: product, quantity: 1),
                ],
        ),
      ),
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    if (index == 2) {
      _openCart(context, null);
    } else if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add Product is coming soon!')),
      );
    }
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                product.imageAsset,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryPeach,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onAdd,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io'; // ★★★ 파일 이미지를 위해 import 추가 ★★★
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ★★★ 1. 원화 포맷을 위해 import 추가 ★★★

import '../../constants/colors.dart';
import '../../core/product.dart';
import '../../state/cart_store.dart';
import '../../state/product_store.dart';
import '../cart/cart_page.dart';
import '../product/add_product_page.dart';
import '../ttotoy_detail/ttotoy_detail_page.dart';

// ★★★ 2. 원화 포맷 함수 정의 추가 ★★★
String formatCurrency(double price) {
  final format =
      NumberFormat.currency(locale: 'ko_KR', symbol: '₩', decimalDigits: 0);
  return format.format(price.round());
}
// ★★★

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productStore = ProductProvider.of(context); // 전역 상품 상태
    final cartStore = CartProvider.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'TtoToy',
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        /*
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            color: AppColors.descriptionGray,
            onPressed: () => _openCart(context),
          ),
        ],
        */
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* 검색바 삭제 (주석처리)
            _SearchBar(theme: theme),
            const SizedBox(height: 20),
            */
            Expanded(
              child: AnimatedBuilder(
                animation: productStore,
                builder: (context, _) {
                  final products = productStore.products;
                  if (products.isEmpty) {
                    return const Center(child: Text('등록된 상품이 없습니다.'));
                  }
                  return ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 12);
                    },
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _ProductCard(
                        product: product,
                        onTap: () => _openDetail(context, product),
                        onAdd: () => _addToCart(context, cartStore, product),
                      );
                    },
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
            label: 'Upload',
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

  void _openCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    if (index == 2) {
      _openCart(context);
    } else if (index == 1) {
      _openAddProduct(context);
    }
  }

  void _openAddProduct(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddProductPage()),
    );
  }

  void _addToCart(
    BuildContext context,
    CartStore cartStore,
    Product product,
  ) {
    final added = cartStore.addProduct(product);
    final messenger = ScaffoldMessenger.of(context);
    if (added) {
      messenger.showSnackBar(
        SnackBar(content: Text('${product.name}이(가) 장바구니에 담겼어요.')),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('재고 수량을 초과하여 담을 수 없어요.')),
      );
    }
  }
}
// 검색바 클래스 삭제 (주석처리)
/*class _SearchBar extends StatelessWidget {
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
*/
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
              color: Colors.black.withValues(alpha: 0.04),
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
              child: _ProductImage(
                imageUrl: product.imageAsset,
                width: 70,
                height: 70,
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
                  const SizedBox(height: 6),
                  Text(
                    '재고: ${product.inventory}개',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: AppColors.descriptionGray),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    //'₩${product.price.toStringAsFixed(0)}',
                    formatCurrency(product.price), //   ★ 이제 정상 작동합니다 ★
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryPeach,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 90,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                ),
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ★★★ URL, 로컬 파일, 앱 에셋을 모두 처리하는 이미지 위젯 (변경 없음) ★★★
class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.imageUrl,
    this.width = 70.0,
    this.height = 70.0,
  });

  final String imageUrl;
  final double width;
  final double height;

  // 공통 에러 위젯
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.broken_image_outlined,
        color: Colors.grey[400],
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http')) {
      // 1. 인터넷 URL 이미지
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } else if (imageUrl.startsWith('assets/')) {
      // 2. 앱 내부 에셋 이미지
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } else {
      // 3. 기기 갤러리에서 가져온 로컬 파일 이미지
      final file = File(imageUrl);
      if (imageUrl.isNotEmpty && file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      } else {
        // 4. 경로가 잘못되었거나 파일이 없는 경우
        return _buildErrorWidget();
      }
    }
  }
}

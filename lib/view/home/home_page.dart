import 'dart:io'; // 파일 이미지를 위해 import 추가
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 원화 포맷을 위해 import 추가

import '../../constants/colors.dart';
import '../../core/product.dart';
import '../../state/cart_store.dart';
import '../../state/product_store.dart';
import '../cart/cart_page.dart';
import '../product/add_product_page.dart';
import '../ttotoy_detail/ttotoy_detail_page.dart';

// 원화 포맷 함수 정의
String formatCurrency(double price) {
  final format =
      NumberFormat.currency(locale: 'ko_KR', symbol: '₩', decimalDigits: 0);
  return format.format(price.round());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // CartStore는 여기서 한번만 가져와도 괜찮습니다.
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
        /* actions 생략 */
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* 검색바 삭제 (주석처리) */
            Expanded(
              child: AnimatedBuilder(
                // ★★★ ProductProvider.of(context)를 직접 animation으로 전달하여 구독 ★★★
                animation: ProductProvider.of(context),
                builder: (context, _) {
                  // ★★★ builder 내부에서 Provider.of를 다시 호출하여 최신 상태 가져오기 ★★★
                  final productStore = ProductProvider.of(context);
                  final allProducts = productStore.products;

                  // 디버그 로그 (유지)
                  debugPrint("--- HomePage Rebuilding ---");
                  allProducts.forEach((p) => debugPrint("  ${p.name}: inventory=${p.inventory}"));
                  debugPrint("-------------------------");

                  // 재고 필터링 (기존 로직 유지)
                  final products = allProducts
                      .where((p) => p.inventory > 0)
                      .toList();

                  if (products.isEmpty) {
                    return const Center(child: Text('판매중인 상품이 없습니다.'));
                  }
                  return ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 12);
                    },
                    itemBuilder: (context, index) {
                      final product = products[index];
                      debugPrint("  Building card for ${product.name} with inventory: ${product.inventory}");
                      return _ProductCard(
                        product: product,
                        onTap: () => _openDetail(context, product),
                        // ★★★ cartStore는 build 메서드에서 가져온 것을 사용 ★★★
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

  // ★★★ _addToCart 함수에서 불필요한 주석 및 임시 코드 제거 완료 ★★★
  void _addToCart(
    BuildContext context,
    CartStore cartStore,
    Product product,
  ) {
    final added = cartStore.addProduct(product); // CartStore가 ProductStore 재고 업데이트 처리
    final messenger = ScaffoldMessenger.of(context);
    const quickDuration = Duration(milliseconds: 1200);

    if (added) {
      messenger.showSnackBar(
        SnackBar(content: Text('${product.name}이(가) 장바구니에 담겼어요.'),
        duration: quickDuration, //   duration 설정 추가
      ));
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('재고 수량을 초과하여 담을 수 없어요.'),
        duration: quickDuration, //   duration 설정 추가),
      ));
    }
  }
}

// _ProductCard 클래스 (변경 없음)
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
                    '재고: ${product.inventory}개', // 재고 표시
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: AppColors.descriptionGray),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatCurrency(product.price), // 원화 형식 변경 ₩20,000원 형태
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

// _ProductImage 위젯 (변경 없음)
class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.imageUrl,
    this.width = 70.0,
    this.height = 70.0,
  });

  final String imageUrl;
  final double width;
  final double height;

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
        return _buildErrorWidget();
      }
    }
  }
}


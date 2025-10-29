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
                  for (var p in allProducts) { // for-in 루프 사용
                    debugPrint("  ${p.name}: inventory=${p.inventory}");
                  }
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

  // ★★★ _addToCart 함수 (재고 로직은 CartStore가 담당) ★★★
  void _addToCart(
    BuildContext context,
    CartStore cartStore,
    Product product,
  ) {
    final added = cartStore.addProduct(product); // CartStore가 ProductStore 재고 "확인"
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

// ★★★ _ProductCard 클래스 수정 ★★★
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
  Widget build(BuildContext context) { // _ProductCard build 메서드
    final theme = Theme.of(context);
    return InkWell(  // InkWell으로 변경
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,  // 전체 카드를 누를 때 상세 페이지로 이동
      child: Container(  // 카드 컨테이너
        decoration: BoxDecoration( // 카드 스타일
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
        padding: const EdgeInsets.all(12), // 내부 패딩 추가
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // 이미지 모서리 둥글게
              child: _ProductImage(
                // ★★★ imageAsset -> imageAssets.first로 수정 ★★★
                imageUrl: product.imageAssets.isNotEmpty
                    ? product.imageAssets.first
                    : '', // 이미지가 없는 경우 에러 위젯 표시
                width: 70,
                height: 70,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleLarge, // 상품 이름 스타일
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium,  // 상품 설명 스타일
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,  // 설명이 길면 ...으로 표시
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '재고: ${product.inventory}개', // 재고 표시
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: AppColors.descriptionGray), // 재고 스타일
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatCurrency(product.price), // 원화 형식 변경 ₩20,000원 형태
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryPeach, // 가격 스타일
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12), // 이미지와 버튼 사이 간격
            SizedBox(
              width: 90,
              child: ElevatedButton( // 추가 버튼
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(  // 버튼 스타일
                  minimumSize: const Size(0, 44), // 버튼 높이 고정
                ),
                child: const Text('Add'), // 버튼 텍스트
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// _ProductImage 위젯 (기존과 동일)
class _ProductImage extends StatelessWidget {  // 이미지 로딩 위젯
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
  Widget build(BuildContext context) { // 이미지 빌드 메서드
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.contain, // 이미지 잘림 방지
        loadingBuilder: (context, child, progress) { // 로딩 중 위젯
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),  // 로딩 인디케이터
          );
        },
        errorBuilder: (context, error, stackTrace) {  // 에러 처리 위젯
          return _buildErrorWidget();  // 에러 시 대체 위젯 반환
        },
      );
    } else if (imageUrl.startsWith('assets/')) {  // 에셋 이미지 처리
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.contain, // 이미지 잘림 방지
        errorBuilder: (context, error, stackTrace) { // 에러 처리 위젯
          return _buildErrorWidget();
        },
      );
    } else {
      final file = File(imageUrl);  // 로컬 파일 이미지 처리
      if (imageUrl.isNotEmpty && file.existsSync()) {  // 파일 존재 여부 확인
        return Image.file( // 파일 이미지 로드
          file,
          width: width,
          height: height,
          fit: BoxFit.contain, // 이미지 잘림 방지
          errorBuilder: (context, error, stackTrace) {  // 에러 처리 위젯
            return _buildErrorWidget(); // 파일 로드 에러 시 대체 위젯 반환
          },
        );
      } else {
        return _buildErrorWidget(); // 파일이 없을 경우 대체 위젯 반환
      }
    }
  }
}

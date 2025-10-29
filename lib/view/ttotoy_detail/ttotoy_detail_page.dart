import 'dart:io'; // 파일 이미지를 위해 import 추가
import 'package:flutter/material.dart'; // ★★★ 오타 수정 (package. -> package:) ★★★
import 'package:intl/intl.dart'; // ★★★ 오타 수정 (package. -> package:) ★★★

import '../../constants/colors.dart'; // AppColors import
import '../../core/product.dart';  // Product 모델 import
import '../../state/cart_store.dart';  // CartStore import
import '../cart/cart_page.dart';  // CartPage import

// 원화 포맷 함수 정의
String formatCurrency(double price) {
  final format =
      NumberFormat.currency(locale: 'ko_KR', symbol: '₩', decimalDigits: 0); // 원화 포맷 설정
  return format.format(price.round());  // 소수점 없이 반올림하여 포맷팅
}

// ★★★ StatelessWidget -> StatefulWidget으로 변경 ★★★
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;  // 전달된 Product 객체

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // ★★★ 현재 이미지 페이지 추적을 위한 변수 추가 ★★★
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ★★★ StatefulWidget에서는 widget.product로 접근 ★★★
    final product = widget.product;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          product.name,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(  // 내용이 길어질 수 있어 스크롤 가능하도록 설정
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),  // 패딩 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // 왼쪽 정렬
          children: [
            // ★★★ 이미지 스와이퍼(PageView)로 변경 ★★★
            SizedBox(
              height: 240,
              child: PageView.builder(
                controller: _pageController,
                // ★★★ imageAssets 리스트 사용 ★★★
                itemCount: product.imageAssets.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final imageUrl = product.imageAssets[index];
                  // ★★★ 확대 기능을 위해 GestureDetector 추가 ★★★
                  return GestureDetector(
                    onTap: () => _showImageDialog(context, imageUrl),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: _ProductDetailImage(
                        imageUrl: imageUrl,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.contain, // 상세 페이지 이미지는 contain으로 설정
                      ),
                    ),
                  );
                },
              ),
            ),
            // ★★★ 페이지 인디케이터(점) 추가 ★★★
            if (product.imageAssets.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(product.imageAssets.length, (index) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColors.primaryPeach
                          : Colors.grey.shade400,
                    ),
                  );
                }),
              ),
            const SizedBox(height: 10), // 인디케이터와 텍스트 사이 간격

            // (이하 상세 정보는 동일)
            Text(
              product.name,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 22), // 글자 크기 조정
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              style: theme.textTheme.bodyMedium,  // 설명 텍스트 스타일
            ),
            const SizedBox(height: 20),
            _DetailTile(
              label: '사용연령',
              value: product.size, // 'size' 필드 사용
            ),
            const SizedBox(height: 8),  // 간격
            /*
            _DetailTile(
              label: '색상',
              value: product.color,
            ),
            const SizedBox(height: 8),
            */
            _DetailTile(  // 재고 정보 타일
              label: '재고',
              value: '${product.inventory}개',  // 재고 수량 표시
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 가격 정보와 버튼 사이 간격 조정
              children: [
                Text(
                  '가격',
                  style: theme.textTheme.titleMedium, // 가격 라벨 스타일
                ),
                Text(
                  formatCurrency(product.price), // ★★ 원화 포맷 함수 사용 ★★★
                  style: theme.textTheme.titleLarge?.copyWith(  // 가격 텍스트 스타일
                    color: AppColors.primaryPeach,  // 강조 색상 적용
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _addToCartAndGo(context),  // 장바구니 추가 및 이동 함수 호출
              style: ElevatedButton.styleFrom(  // 버튼 스타일 설정
                minimumSize: const Size(double.infinity, 56), // 버튼 가로 전체 너비, 높이 56
              ),
              child: const Text('Add to Cart'),  // 버튼 텍스트
            ),
          ],
        ),
      ),
    );
  }

  // ★★★ 장바구니 추가 함수 (StatefulWidget에 맞게 수정) ★★★
  void _addToCartAndGo(BuildContext context) {
    final cartStore = CartProvider.of(context);
    // ★★★ widget.product로 접근 ★★★
    final added = cartStore.addProduct(widget.product);
    if (added) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.product.name}이(가) 장바구니에 담겼어요.'),
        duration: const Duration(milliseconds: 1200),),
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CartPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('재고 수량을 초과하여 담을 수 없어요.')),
      );
    }
  }

  // ★★★ 이미지 확대 다이얼로그 함수 (신규 추가) ★★★
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10), // 화면 여백
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              // InteractiveViewer를 사용해 확대/축소/이동 가능
              InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: _ProductDetailImage(
                  imageUrl: imageUrl,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8,
                  fit: BoxFit.contain, // 확대 시에는 contain이 적합
                ),
              ),
              // 닫기 버튼
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    // ★★★ withOpacity -> withAlpha로 수정 ★★★
                    backgroundColor: Colors.black.withAlpha(128), // (0.5 * 255 = 128)
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// _DetailTile 클래스 (기존과 동일)
class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.titleMedium,
          ),
          Text(
            value,
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

// ★★★ _ProductDetailImage 클래스 (fit 속성을 매개변수로 받도록 수정) ★★★
class _ProductDetailImage extends StatelessWidget {
  const _ProductDetailImage({
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 240.0,
    this.fit = BoxFit.contain, // ★★★ fit 기본값을 contain으로 변경 ★★★
  });

  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit; // ★★★ fit 속성 추가 ★★★

  // 공통 에러 위젯
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.broken_image_outlined,
        color: Colors.grey[400],
        size: 60,
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
        fit: fit, // ★★★ 매개변수로 받은 fit 사용 ★★★
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
        fit: fit, // ★★★ 매개변수로 받은 fit 사용 ★★★
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
          fit: fit, // ★★★ 매개변수로 받은 fit 사용 ★★★
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

import 'dart:io'; // ★★★ 파일 이미지를 위해 import 추가 ★★★
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ★★★ 1. 원화 포맷을 위해 import 추가 ★★★

import '../../constants/colors.dart'; // AppColors import
import '../../core/product.dart';  // Product 모델 import
import '../../state/cart_store.dart';  // CartStore import
import '../cart/cart_page.dart';  // CartPage import

// ★★★ 2. 원화 포맷 함수 정의 추가 ★★★
String formatCurrency(double price) {
  final format =
      NumberFormat.currency(locale: 'ko_KR', symbol: '₩', decimalDigits: 0); // 원화 포맷 설정
  return format.format(price.round());  // 소수점 없이 반올림하여 포맷팅
}
// ★★★

class ProductDetailPage extends StatelessWidget {  // StatelessWidget 사용
  const ProductDetailPage({super.key, required this.product});  

  final Product product;  // 전달된 Product 객체

  @override
  Widget build(BuildContext context) {  
    final theme = Theme.of(context);
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
            ClipRRect(
              borderRadius: BorderRadius.circular(24), // 이미지 모서리 둥글게 처리
              // ★★★ 이미지 로더 위젯으로 변경 ★★★
              child: _ProductDetailImage(  // 이미지 로더 위젯 사용
                imageUrl: product.imageAsset, // 이미지 경로 전달
                height: 240,
                width: double.infinity, // 화면 가로 전체 너비
              ),
            ),
            const SizedBox(height: 20), // 이미지와 텍스트 사이 간격
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
                  //'₩${product.price.toStringAsFixed(0)}',
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

  void _addToCartAndGo(BuildContext context) {  // 장바구니 추가 및 이동 함수
    final cartStore = CartProvider.of(context);  // CartStore 가져오기
    final added = cartStore.addProduct(product); // 장바구니에 상품 추가 시도
    if (added) {
      ScaffoldMessenger.of(context).showSnackBar(  // 성공 메시지
        SnackBar(content: Text('${product.name}이(가) 장바구니에 담겼어요.')),
      );
      Navigator.of(context).push(  // 장바구니 페이지로 이동
        MaterialPageRoute(builder: (_) => const CartPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(  // 실패 메시지
        const SnackBar(content: Text('재고 수량을 초과하여 담을 수 없어요.')),
      );
    }
  }
}

class _DetailTile extends StatelessWidget {  // 상품 상세 정보 타일 위젯
  const _DetailTile({required this.label, required this.value});  

  final String label;  // 타일 라벨
  final String value;  // 타일 값

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

// ★★★ URL, 로컬 파일, 앱 에셋을 모두 처리하는 이미지 위젯 ★★★
class _ProductDetailImage extends StatelessWidget {  // 이미지 로더 위젯
  const _ProductDetailImage({  
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 240.0,
  });

  final String imageUrl;  // 이미지 경로 (URL, 로컬 파일 경로, 앱 에셋 경로)
  final double width;
  final double height;

  // 공통 에러 위젯
  Widget _buildErrorWidget() { // 에러 시 표시할 위젯
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200], // 배경색
      child: Icon(
        Icons.broken_image_outlined, // 깨진 이미지 아이콘
        color: Colors.grey[400], // 아이콘 색상
        size: 60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {  
    if (imageUrl.startsWith('http')) {  
      // 1. 인터넷 URL 이미지
      return Image.network(  // 네트워크 이미지 로드
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {  // 로딩 중 위젯
          if (progress == null) return child;  // 로딩 완료 시 이미지 반환
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
    } else if (imageUrl.startsWith('assets/')) {  
      // 2. 앱 내부 에셋 이미지
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) { // 에러 처리 위젯
          return _buildErrorWidget();  // 에러 시 대체 위젯 반환
        },
      );
    } else {
      // 3. 기기 갤러리에서 가져온 로컬 파일 이미지
      final file = File(imageUrl);
      // (경로가 비어있지 않은지 확인)
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
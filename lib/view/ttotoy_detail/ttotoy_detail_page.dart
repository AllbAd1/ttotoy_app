import 'dart:io'; // ★★★ 파일 이미지를 위해 import 추가 ★★★
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ★★★ 1. 원화 포맷을 위해 import 추가 ★★★

import '../../constants/colors.dart';
import '../../core/product.dart';
import '../../state/cart_store.dart';
import '../cart/cart_page.dart';

// ★★★ 2. 원화 포맷 함수 정의 추가 ★★★
String formatCurrency(double price) {
  final format =
      NumberFormat.currency(locale: 'ko_KR', symbol: '₩', decimalDigits: 0);
  return format.format(price.round());
}
// ★★★

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              // ★★★ 이미지 로더 위젯으로 변경 ★★★
              child: _ProductDetailImage(
                imageUrl: product.imageAsset,
                height: 240,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _DetailTile(
              label: '사용연령',
              value: product.size,
            ),
            const SizedBox(height: 8),
            /*
            _DetailTile(
              label: '색상',
              value: product.color,
            ),
            const SizedBox(height: 8),
            */
            _DetailTile(
              label: '재고',
              value: '${product.inventory}개',
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '가격',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  //'₩${product.price.toStringAsFixed(0)}',
                  formatCurrency(product.price), //   ★ 이제 정상 작동합니다 ★
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryPeach,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _addToCartAndGo(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCartAndGo(BuildContext context) {
    final cartStore = CartProvider.of(context);
    final added = cartStore.addProduct(product);
    if (added) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name}이(가) 장바구니에 담겼어요.')),
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
}

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

// ★★★ URL, 로컬 파일, 앱 에셋을 모두 처리하는 이미지 위젯 (신규 추가) ★★★
class _ProductDetailImage extends StatelessWidget {
  const _ProductDetailImage({
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 240.0,
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
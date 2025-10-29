import 'dart:io'; // ★★★ 파일 이미지를 위해 import 추가 ★★★
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../state/cart_store.dart';
// ★★★ CartItem 이름을 숨겨서 가져옵니다 ★★★
import '../../core/product.dart' hide CartItem;
// ★★★ (기존 import '../../core/product.dart'; 삭제) ★★★

import 'package:intl/intl.dart'; //   금액 포맷팅을 위해 추가

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartStore = CartProvider.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Cart',
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
      ),
      body: AnimatedBuilder(
        animation: cartStore,
        builder: (context, _) {
          // ★★★ 여기서 사용하는 items와 CartItem은 이제 cart_store.dart에서 온 것입니다 ★★★
          final items = cartStore.items;
          if (items.isEmpty) {
            return const Center(
              child: Text('장바구니가 비어 있어요.'),
            );
          }
          final totalPrice = cartStore.totalPrice;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final cartItem = items[index];
                      return _CartItemCard(cartItem: cartItem);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _CartSummary(total: totalPrice),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('결제를 하시겠습니까?'),
                            content: const Text('확인 버튼을 누르면 결제가 진행됩니다'),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(80, 40), // 버튼 크기 지정
                                  backgroundColor:
                                      Colors.grey.shade200, // 취소 버튼은 배경색을 다르게
                                  foregroundColor: Colors.black87,
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text('취소'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(80, 40), // 버튼 크기 지정
                                ),
                                onPressed: () {
                                  cartStore.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                  ),
                  child: const Text('결제하러 가기'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  // ★★★ 여기서 사용하는 CartItem은 이제 cart_store.dart에서 온 것입니다 ★★★
  const _CartItemCard({required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartStore = CartProvider.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'ko_KR', //    한국 로케일 (쉼표 그룹핑)
      symbol: '₩', //    통화 기호 설정
      decimalDigits: 0, //    소수점 자리수 없음
    );

    return Container(
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
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: AppColors.descriptionGray,
            // ★★★ 여기서 사용하는 product는 core/product.dart의 Product입니다 ★★★
            onPressed: () => cartStore.removeProduct(cartItem.product),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _CartProductImage(
              imageUrl: cartItem.product.imageAsset,
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
                  cartItem.product.name,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormat.format(cartItem.product.price),
                  //'₩${cartItem.product.price.toStringAsFixed(0)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryPeach,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _QuantityControl(
            quantity: cartItem.quantity,
            inventory: cartItem.product.inventory,
            onChanged: (delta) {
              final success =
                  cartStore.changeQuantity(cartItem.product, delta);
              if (!success && delta > 0) { // 증가 시에만 재고 부족 메시지 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('재고 수량을 초과할 수 없어요.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.inventory,
    required this.onChanged
  });

  final int quantity;
  final int inventory;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canDecrease = quantity > 1;
    final bool canIncrease = quantity < inventory;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.descriptionGray.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            color: canDecrease ? theme.colorScheme.primary : Colors.grey,
            onPressed: canDecrease ? () => onChanged(-1) : null,
          ),
          Text(
            '$quantity',
            style: theme.textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            color: canIncrease ? theme.colorScheme.primary : Colors.grey,
            onPressed: canIncrease ? () => onChanged(1) : null,
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );

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
            '합계',
            style: theme.textTheme.titleMedium,
          ),
          Text(
            currencyFormat.format(total),
            //'₩${total.toStringAsFixed(0)}',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.primaryPeach,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartProductImage extends StatelessWidget {
  const _CartProductImage({
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

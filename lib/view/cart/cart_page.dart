import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../state/cart_store.dart';

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
                    showDialog(context: context, barrierDismissible: true, builder:(BuildContext context){
                      return AlertDialog(
                        title: const Text('결제를 하시겠습니까?'),
                        content: const Text('확인 버튼을 누르면 결제가 진행됩니다'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context),
                          child: const Text('취소'),
                          ),
                          ElevatedButton(onPressed: (){
                            cartStore.clear();
                            Navigator.pop(context);
                          }, child: const Text('확인') ),
                        ],
                      );
                    } );
                  
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
  const _CartItemCard({required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartStore = CartProvider.of(context);
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
            onPressed: () => cartStore.removeProduct(cartItem.product),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              cartItem.product.imageAsset,
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
                  cartItem.product.name,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '₩${cartItem.product.price.toStringAsFixed(0)}',
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
            onChanged: (delta) {
              final success =
                  cartStore.changeQuantity(cartItem.product, delta);
              if (!success) {
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
  const _QuantityControl({required this.quantity, required this.onChanged});

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            color: theme.colorScheme.primary,
            onPressed: () => onChanged(-1),
          ),
          Text(
            '$quantity',
            style: theme.textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            color: theme.colorScheme.primary,
            onPressed: () => onChanged(1),
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
            '₩${total.toStringAsFixed(0)}',
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

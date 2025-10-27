import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../core/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.initialItems});

  final List<CartItem>? initialItems;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.initialItems != null && widget.initialItems!.isNotEmpty
        ? widget.initialItems!
            .map((item) => CartItem(product: item.product, quantity: item.quantity))
            .toList()
        : _sampleItems();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalPrice = _items.fold<double>(
      0,
      (previous, item) => previous + item.product.price * item.quantity,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cartItem = _items[index];
                  return _CartItemCard(
                    cartItem: cartItem,
                    onQuantityChanged: (delta) => _changeQuantity(index, delta),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _CartSummary(total: totalPrice),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
              ),
              child: const Text('Go to Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _changeQuantity(int index, int delta) {
    setState(() {
      final current = _items[index].quantity + delta;
      if (current > 0) {
        _items[index] = CartItem(
          product: _items[index].product,
          quantity: current,
        );
      }
    });
  }

  List<CartItem> _sampleItems() {
    return [
      CartItem(
        product: const Product(
          name: 'Baby girl sweater',
          description: 'Cozy knit sweater for girls.',
          price: 16.00,
          imageAsset: 'assets/images/Ttotoy_under_title.webp',
          size: '6-9M',
          color: 'Pink',
        ),
        quantity: 1,
      ),
      CartItem(
        product: const Product(
          name: 'Baby boy bottle',
          description: 'Silicone nipple water bottle.',
          price: 10.00,
          imageAsset: 'assets/images/Ttotoy_logo.webp',
          size: '0-3M',
          color: 'Gray',
        ),
        quantity: 1,
      ),
      CartItem(
        product: const Product(
          name: 'Baby girl dress',
          description: 'Lightweight cotton dress.',
          price: 21.00,
          imageAsset: 'assets/images/mom_and_baby.webp',
          size: '12-18M',
          color: 'Red',
        ),
        quantity: 1,
      ),
    ];
  }
}

class CartItem {
  CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.cartItem,
    required this.onQuantityChanged,
  });

  final CartItem cartItem;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
                  '\$${cartItem.product.price.toStringAsFixed(2)}',
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
            onChanged: onQuantityChanged,
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
        border: Border.all(color: AppColors.descriptionGray.withOpacity(0.4)),
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
            'TOTAL',
            style: theme.textTheme.titleMedium,
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
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

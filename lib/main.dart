import 'package:flutter/material.dart';

import 'state/cart_store.dart';
import 'state/product_store.dart';
import 'theme/app_theme.dart';
import 'view/home/start_page.dart';

void main() {
  final productStore = ProductStore();
  final cartStore = CartStore();
  runApp(
    CartProvider(
      store: cartStore,
      child: ProductProvider(
        store: productStore,
        child: const TtoToyApp(),
      ),
    ),
  );
}

class TtoToyApp extends StatelessWidget {
  const TtoToyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TtoToy',
      debugShowCheckedModeBanner: false,
      theme: ttoToyTheme,
      themeMode: ThemeMode.light,
      home: const StartPage(),
    );
  }
}

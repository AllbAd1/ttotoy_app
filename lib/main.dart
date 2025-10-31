import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'state/auth_provider.dart';
import 'state/product_store.dart';
import 'state/cart_store.dart';
import 'theme/app_theme.dart';
import 'view/auth/login_page.dart';
import 'view/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final productStore = ProductStore();
  final cartStore = CartStore(productStore);
  final authStore = AuthStore();

  runApp(
    AuthProvider(
      store: authStore,
      child: CartProvider(
        store: cartStore,
        child: ProductProvider(
          store: productStore,
          child: const TtoToyApp(),
        ),
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
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final authStore = AuthProvider.of(context, listen: false);
    return AnimatedBuilder(
      animation: authStore,
      builder: (context, _) {
        if (authStore.isInitializing) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authStore.isAuthenticated) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}


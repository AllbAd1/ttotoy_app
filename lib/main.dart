import 'package:flutter/material.dart';

// ProductProvider import 추가 (정확한 경로로 수정 필요)
import 'state/product_store.dart';
import 'state/cart_store.dart';
// theme/app_theme.dart 의 정확한 경로로 수정 필요 (core or theme)
import 'theme/app_theme.dart';
import 'view/home/start_page.dart';

void main() {
  // 1. ProductStore 인스턴스 생성
  final productStore = ProductStore();
  // 2. CartStore 생성 시 productStore 인스턴스 전달
  final cartStore = CartStore(productStore);

  runApp(
    // InheritedNotifier 방식 Provider 설정 (기존 코드 유지)
    CartProvider(
      store: cartStore,
      child: ProductProvider(
        store: productStore,
        child: const TtoToyApp(),
      ),
    ),
  );
}

class TtoToyApp extends StatelessWidget { // StatelessWidget 사용
  const TtoToyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TtoToy',
      debugShowCheckedModeBanner: false,
      theme: ttoToyTheme, // 테마 적용 확인 (app_theme.dart 경로 주의)
      themeMode: ThemeMode.light,
      home: const StartPage(), // 시작 페이지 확인
    );
  }
}


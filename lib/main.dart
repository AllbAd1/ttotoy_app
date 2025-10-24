import 'package:flutter/material.dart';
// import 'package:tasks/core/app_theme.dart'; // ★ 기존 테마 관련 Import는 제거.
import 'package:ttotoy/theme/app_theme.dart'; // ★ 새로 만든 TtoToy 테마 파일을 Import.
import 'package:tasks/view/home/home_page.dart'; // HomePage는 나중에 TtoToy의 Splash/Home으로 변경 예정.

// App 이름을 MyApp 에서 TtoToyApp으로 변경.
void main() {
  runApp(const TtoToyApp());
}

class TtoToyApp extends StatelessWidget { // ★ 클래스 이름도 TtoToyApp으로 변경
  const TtoToyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TtoToy', // ★ 앱 이름도 TtoToy로 변경
      debugShowCheckedModeBanner: false,
      
      // 1. 기존 light/darkTheme 대신, TtoToy에서 정의한 ttoToyTheme 하나만 사용.
      theme: ttoToyTheme, // ★ ttoToyTheme 적용
      
      // 2. 테마 모드도 light로 고정 ( 나중에 다크모드 지원할 계획이 있으면 변경 가능 )
      themeMode: ThemeMode.light, 

      // 3. 임시로 TtoToy의 첫 화면 (Splash Screen)으로 변경.
      //    (현재는 임시로 텍스트를 보여주지만, 나중에 SplashPage를 만들어서 연결할 예정)
      // home: const HomePage title을 임시로 TtoToy Splash Screen Ready로 변경 - 나중에 변경 예정.
      home: const Scaffold(
        body: Center(
          child: Text('TtoToy Splash Screen Ready'),
        ),
      ),
    );
  }
}
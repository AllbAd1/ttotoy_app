import 'package:flutter/material.dart';

import 'package:tasks/view/home/home_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  void _goToMainPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/mom_and_baby.webp',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Align(
                alignment: Alignment.bottomCenter,

                // >>>>>>>>>>>>>>>>>>유창수 : 여기에 로고와 버튼을 세로로 배치합니다. <<<<<<<<<<<<<<<<<<<<
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                Image.asset('assets/images/Ttotoy_under_title.webp',
                      height: 50, // 로고 크기 설정
                    ),
                const SizedBox(height: 15), // 로고와 버튼 사이 간격
                  // >>>>>>>>>>>>>>>>>>유창수 : 로고 추가 <<<<<<<<<<<<<<<<<<<<

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _goToMainPage(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      '들어가기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

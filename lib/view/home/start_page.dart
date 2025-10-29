import 'package:flutter/material.dart';

import 'package:ttotoy/view/home/home_page.dart';

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
          Positioned.fill(  // 배경 이미지와 그라데이션
            child: Image.asset(  // 배경 이미지
              'assets/images/mom_and_baby.webp',  // 배경 이미지 경로
              fit: BoxFit.cover,  // 이미지가 화면을 덮도록 설정
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(  // 그라데이션 오버레이
              decoration: BoxDecoration(  
                gradient: LinearGradient(  // 그라데이션 설정
                  begin: Alignment.topCenter,  // 그라데이션 시작점
                  end: Alignment.bottomCenter,  // 그라데이션 끝점
                  colors: [
                    Colors.black.withValues(alpha: 0.1),  // 상단 투명도 낮은 검정
                    Colors.black.withValues(alpha: 0.6),  // 하단 투명도 높은 검정
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),  // 패딩 설정
              child: Align(
                alignment: Alignment.bottomCenter,  // 하단 중앙 정렬

                // >>>>>>>>>>>>>>>>>>유창수 : 여기에 로고와 버튼을 세로로 배치합니다. <<<<<<<<<<<<<<<<<<<<
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                Image.asset('assets/images/Ttotoy_under_title.webp',
                      height: 90, // 로고 크기 설정
                    ),
                const SizedBox(height: 15), // 로고와 버튼 사이 간격
                  // >>>>>>>>>>>>>>>>>>유창수 : 로고 추가 <<<<<<<<<<<<<<<<<<<<

                SizedBox(
                  width: double.infinity,  // 버튼이 가로로 꽉 차도록 설정
                  child: ElevatedButton( // 들어가기 버튼
                    onPressed: () => _goToMainPage(context),  // 버튼 클릭 시 메인 페이지로 이동
                    style: ElevatedButton.styleFrom(  // 버튼 스타일 설정
                      padding: const EdgeInsets.symmetric(vertical: 18), // 버튼 내부 패딩
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      '들어가기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,  // 버튼 텍스트 스타일
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



// lib/theme/app_theme.dart (예시)

import 'package:flutter/material.dart';
import '../constants/colors.dart';

final ThemeData ttoToyTheme = ThemeData(
  // 1. 앱의 기본 배경색 설정
  scaffoldBackgroundColor: AppColors.backgroundLightGray, 
  
  // 2. 주요 색상 (버튼, 포커스 등) 설정
  primaryColor: AppColors.primaryPeach,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryPeach,
    surface: AppColors.widgetBackgroundWhite,
    onPrimary: AppColors.textWhite, // 버튼 폰트 색상
  ),

  // 3. 텍스트 스타일 정의 (폰트 크기 및 굵기)
  textTheme: const TextTheme(
    // 제목 폰트 (Black, Bold, 16pt)
    titleLarge: TextStyle(
      color: AppColors.textBlack,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    ),
    // 부제목 폰트 (Black, 14pt)
    titleMedium: TextStyle(
      color: AppColors.textBlack,
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
    ),
    // 설명(상세페이지) 폰트 (#8d9194, 14pt)
    bodyMedium: TextStyle(
      color: AppColors.descriptionGray,
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
    ),
    // 버튼 폰트 (White, 16pt - 여기서는 titleLarge와 동일한 크기로 설정)
    labelLarge: TextStyle(
      color: AppColors.textWhite,
      fontSize: 16.0,
      fontWeight: FontWeight.normal, 
    ),
  ),

  // 4. 버튼 스타일 정의 (Global Button Style)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryPeach, // 버튼 배경색
      foregroundColor: AppColors.textWhite,      // 버튼 텍스트 색상
      textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal), // 버튼 폰트 스타일
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // 버튼 모서리 둥글게 (선호에 따라 조정)
      ),
      minimumSize: const Size(double.infinity, 50), // 버튼 최소 크기 (full width, 높이 50)
    ),
  ),
);

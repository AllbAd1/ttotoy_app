// app_theme.dart
import 'package:flutter/material.dart'; // Flutter 기본 패키지 임포트
import 'package:ttotoy/core/variable_colors.dart'; // VariableColors import
import 'package:ttotoy/core/fixed_colors.dart'; // FixedColors import

class AppTheme {
  static final ThemeData light = ThemeData( // 라이트 테마 정의
    brightness: Brightness.light,
    textTheme: ThemeData.light().textTheme,
    extensions: const [VariableColors.light, FixedColors.constant],
  );

  static final ThemeData dark = ThemeData( // 다크 테마 정의
    brightness: Brightness.dark,
    textTheme: ThemeData.dark().textTheme,
    extensions: const [VariableColors.dark, FixedColors.constant],
  );
}

VariableColors vrc(BuildContext context) =>
    Theme.of(context).extension<VariableColors>()!; // VariableColors 접근 함수

FixedColors fxc(BuildContext context) =>
    Theme.of(context).extension<FixedColors>()!; // FixedColors 접근 함수

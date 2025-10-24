import 'package:flutter/material.dart';

/// @immutable은 package:meta에 정의된 어노테이션으로, 다트의 정적 분석기(analyzer) 에게 “이 클래스의 모든 필드는 final이어야 한다”는 규칙을 강제하도록 지시합니다.
/// Flutter의 ThemeExtension, Widget, State, TextStyle 등은 모두 불변 객체(Immutable Object) 로 설계되어 있습니다. 그 이유는 다음과 같습니다.
/// 1. 위젯 트리의 성능 최적화 : Flutter는 위젯을 매 프레임마다 새로 빌드합니다. 그래서 위젯이 내부 상태를 바꾸면, 변경 추적이 어려워지고 성능 저하나 렌더링 버그가 생깁니다.
/// 2. 참조 안정성 유지 : 테마나 스타일 객체는 여러 위젯에서 동시에 참조됩니다. 한 곳에서 색을 바꿔버리면 전체 UI가 엉킬 수 있습니다.
/// 3. 다크모드 전환 시 안전한 테마 교체 : Flutter는 테마 전환 시 전체 ThemeData를 새 인스턴스로 교체합니다. 불변성을 보장하면 예측 가능한 방식으로 테마를 교체할 수 있습니다.

@immutable
class VariableColors extends ThemeExtension<VariableColors> {
  const VariableColors({
    required this.background100,
    required this.background200,
    required this.background300,
    required this.textColor100,
    required this.textColor200,
  });
  final Color? background100;
  final Color? background200;
  final Color? background300;
  final Color? textColor100;
  final Color? textColor200;

  /// 배경색상은 라이트/다크 테마 다르게 설정해야하므로 따로 선언해줍니다.
  static const VariableColors light = VariableColors(
    background100: Color(0xFFF5F5F5),
    background200: Color(0xFFE0E0E0),
    background300: Color(0xFFBDBDBD),
    textColor100: Color(0xFF686868),
    textColor200: Color(0xFF202020),
  );
  static const VariableColors dark = VariableColors(
    background100: Color(0xFF2E2E2E),
    background200: Color(0xFF1F1F1F),
    background300: Color(0xFF121212),
    textColor100: Color(0xFFD4D4D4),
    textColor200: Color(0xFFFFFFFF),
  );

  /// copyWith와 lerp는 Flutter의 ThemeExtension 구조에서 필수로 오버라이드해야 하는 “핵심 메서드 두 가지”입니다.

  /// Flutter는 Theme.of(context)로 가져온 객체를 불변(immutable) 으로 간주합니다. 따라서 직접 수정(colors.background200 = ...)은 불가능해야 하고,
  /// “복사본을 기반으로 새로운 테마 상태를 만들기” 위해 copyWith()가 필요합니다.
  @override
  VariableColors copyWith({
    Color? background100,
    Color? background200,
    Color? background300,
  }) => VariableColors(
    background100: background100 ?? this.background100,
    background200: background200 ?? this.background200,
    background300: background300 ?? this.background300,
    textColor100: textColor100 ?? this.textColor100,
    textColor200: textColor200 ?? this.textColor200,
  );

  /// 라이트/다크 테마 전환처럼 Theme이 교체될 때, 색상이 자연스럽게 변경(transition) 되도록 하는 메서드입니다.
  /// 라이트 → 다크 테마 전환 시, 각 색상이 “뚝” 바뀌는 게 아니라 부드럽게 fade in/out 되게 됩니다.
  @override
  VariableColors lerp(ThemeExtension<VariableColors>? other, double t) {
    if (other is! VariableColors) return this;
    return VariableColors(
      background100: Color.lerp(background100, other.background100, t),
      background200: Color.lerp(background200, other.background200, t),
      background300: Color.lerp(background300, other.background300, t),
      textColor100: Color.lerp(textColor100, other.textColor100, t),
      textColor200: Color.lerp(textColor200, other.textColor200, t),
    );
  }
}

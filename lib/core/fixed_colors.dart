import 'package:flutter/material.dart';

/// @immutable은 package:meta에 정의된 어노테이션으로, 다트의 정적 분석기(analyzer) 에게 “이 클래스의 모든 필드는 final이어야 한다”는 규칙을 강제하도록 지시합니다.
/// Flutter의 ThemeExtension, Widget, State, TextStyle 등은 모두 불변 객체(Immutable Object) 로 설계되어 있습니다. 그 이유는 다음과 같습니다.
/// 1. 위젯 트리의 성능 최적화 : Flutter는 위젯을 매 프레임마다 새로 빌드합니다. 그래서 위젯이 내부 상태를 바꾸면, 변경 추적이 어려워지고 성능 저하나 렌더링 버그가 생깁니다.
/// 2. 참조 안정성 유지 : 테마나 스타일 객체는 여러 위젯에서 동시에 참조됩니다. 한 곳에서 색을 바꿔버리면 전체 UI가 엉킬 수 있습니다.
/// 3. 다크모드 전환 시 안전한 테마 교체 : Flutter는 테마 전환 시 전체 ThemeData를 새 인스턴스로 교체합니다. 불변성을 보장하면 예측 가능한 방식으로 테마를 교체할 수 있습니다.

@immutable
class FixedColors extends ThemeExtension<FixedColors> {
  const FixedColors({required this.brandColor});
  final Color? brandColor;

  /// 브랜드 컬러 같은 고정된 컬러는 라이트/다크로 나눠서 선언할 필요가 없습니다.
  static const FixedColors constant = FixedColors(
    brandColor: Color(0xFFD73300),
  );

  /// copyWith와 lerp는 Flutter의 ThemeExtension 구조에서 필수로 오버라이드해야 하는 “핵심 메서드 두 가지”입니다.

  /// Flutter는 Theme.of(context)로 가져온 객체를 불변(immutable) 으로 간주합니다. 따라서 직접 수정(colors.background200 = ...)은 불가능해야 하고,
  /// “복사본을 기반으로 새로운 테마 상태를 만들기” 위해 copyWith()가 필요합니다.
  @override
  FixedColors copyWith({Color? brandColor}) =>
      FixedColors(brandColor: brandColor ?? this.brandColor);

  /// 라이트/다크 테마 전환처럼 Theme이 교체될 때, 색상이 자연스럽게 변경(transition) 되도록 하는 메서드입니다.
  /// 라이트 → 다크 테마 전환 시, 각 색상이 “뚝” 바뀌는 게 아니라 부드럽게 fade in/out 되게 됩니다.
  @override
  FixedColors lerp(ThemeExtension<FixedColors>? other, double t) {
    if (other is! FixedColors) return this;
    return FixedColors(brandColor: Color.lerp(brandColor, other.brandColor, t));
  }
}

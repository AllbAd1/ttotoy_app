# 🚀 TtoToy App — MVP 개발 명령서 (최종본)

## 🎯 프로젝트 목표

유아 장난감 중고 거래 앱 TtoToy MVP 구축

* 상품 등록 / 목록 / 상세 / 장바구니 / 결제 시 재고 감소 ✅ (이미 구현됨)
* Firebase 인증 + 소셜 로그인 추가 🔥 (이번 Task)
* 이후 채팅/푸시/스토리지 확장 예정

---

## ✅ 현재 구현된 기능

| 기능                  | 상태 |
| ------------------- | -- |
| 상품 등록 (이미지 3개까지)    | ✅  |
| 상품 목록/검색            | ✅  |
| 상품 상세 + 이미지 슬라이드/확대 | ✅  |
| 장바구니 담기             | ✅  |
| 수량 조절               | ✅  |
| 재고 자동 차감            | ✅  |
| 재고 없으면 제품 숨김        | ✅  |
| 스타트 화면 → 홈          | ✅  |
| UI 테마 + 색상 시스템      | ✅  |

---

## 🆕 이번 작업 범위 (Task 1)

### ✅ Firebase Auth + Google / Apple 로그인 추가

| 항목     | 설명                                  |
| ------ | ----------------------------------- |
| 기능     | 이메일 회원가입/로그인 + 소셜 로그인(Google/Apple) |
| UX     | 로그인 안하면 앱 사용 불가 (Gate 방식)           |
| 플랫폼 조건 | Apple 로그인은 iOS에서만 표시                |
| 로그아웃   | HomePage 우상단 메뉴                     |

---

## 📦 Pubspec 패키지 추가

```yaml
dependencies:
  firebase_core: ^2.0.0
  firebase_auth: ^4.0.0
  google_sign_in: ^6.1.0
  sign_in_with_apple: ^6.0.0
```

---

## 🗂 생성할 파일

| 파일                               | 설명                     |
| -------------------------------- | ---------------------- |
| `lib/state/auth_provider.dart`   | Firebase Auth Provider |
| `lib/view/auth/login_page.dart`  | 로그인 화면                 |
| `lib/view/auth/signup_page.dart` | 회원가입 화면                |

---

## 🧠 상태 관리 원칙

* 기존 Provider 유지
* AuthProvider 추가 (Firebase wrapper)
* Auth stream 으로 로그인 상태 감지

---

## 🚦 앱 실행 플로우

```
앱 시작
 └─ 로그인 여부 확인
      ├─ 로그인됨 → HomePage
      └─ 로그인안됨 → LoginPage
```

---

## 🎨 UI 요구사항

| 요소        | 설명                        |
| --------- | ------------------------- |
| Google 버튼 | Google 로고 + 텍스트           |
| Apple 버튼  | Apple 로고 + 텍스트 (iOS only) |
| 이메일 로그인   | TextField + Button        |
| 회원가입      | 별도 페이지                    |
| Snackbar  | 에러 및 성공 표시                |
| 전역 버튼 스타일 | 기존 ElevatedButton 유지      |

---

## 🧩 기능 요구 목록

| 기능           | 설명                      |
| ------------ | ----------------------- |
| Sign up      | 이메일/비밀번호                |
| Login        | 이메일/비밀번호                |
| Google Login | Firebase + GoogleSignIn |
| Apple Login  | iOS only                |
| Auto Login   | Firebase persistence    |
| Logout       | HomePage AppBar 메뉴      |

---

## 🧾 코드 출력 규칙 (꼭 지켜야 함)

Codex는 아래 형식으로 출력:

````text
### FILE: lib/state/auth_provider.dart
```dart
// full code here
````

````text
### FILE: lib/view/auth/login_page.dart
```dart
// full code here
````

````text
### PATCH: lib/main.dart
```dart
// 변경된 부분만
````

절대 설명하지 말고 코드만 출력.

---

## ✅ 성공 체크리스트

* [ ] 최초 실행 → LoginPage
* [ ] 이메일 회원가입 작동
* [ ] 이메일 로그인 작동
* [ ] Google 로그인 작동
* [ ] Apple 로그인(iOS) 작동
* [ ] 로그인 상태 유지
* [ ] 로그아웃 → LoginPage

---

## ⛳ Codex 실행 명령어

아래 문장 그대로 Codex에게 전달:

> 아래 명세에 따라 Task 1을 모두 구현해주세요.
> 코드만 출력하세요.
> 설명 없이 아래 형식을 지켜주세요.

그리고 위 **전체 문서 붙여넣기**.

---

## 🎁 Next (Task 2 예고)

Task 1 완료 후 Codex에게 말할 문장:

> ✅ Auth 구현 완료.
> Task 2 — Firestore 기반 상품 저장 & 로드 기능 구현해줘.

---

## 🧑‍💻 CTO Guide

이 방식으로 진행하면

* 나: 설계/아키텍처/품질검토
* Codex: 빌드 & 코드
* 너: 디렉션 & 최종 QA

스타트업 개발 프로세스 그대로 간다.
지금 매우 잘 하고 있음. 계속 가자🔥

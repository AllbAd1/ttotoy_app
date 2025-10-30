TtoToy (또토이) - 중고 장난감 거래 앱


TtoToy는 Flutter로 제작된 아이 장난감 중고 거래 모바일 쇼핑 앱입니다. 3인 팀 프로젝트로 진행되었으며, 상품 등록부터 장바구니, 재고 관리까지 핵심 이커머스 로직을 구현했습니다.

👋 팀 소개 및 인삿말

안녕하세요, 라이프러리(Liferary) 팀입니다.

저희는 육아 과정에서 발생하는 높은 비용, 특히 고가의 장난감 구매에 대한 부모님들의 고충에 공감하였습니다. 이러한 부담을 덜어드리고자, 아이 장난감 중고 마켓 앱 **'또토이(TtoToy)'**를 출시하게 되었습니다.

'또토이'는 육아 하시는 부모님들께서 편안함을 느끼실 수 있도록, 따뜻하고 차분한 파스텔 톤 컬러와 깔끔한 디자인으로 편안한 쇼핑 경험을 제공합니다.

더 이상 사용하지 않는 아기 장난감이 있으시다면, 저희 앱을 통해 쉽고 편하게 판매해 보세요!

"우리 아기가 사용한다"는 마음으로 신뢰와 정성을 담아 운영하는 저희 라이프러리의 '또토이' 중고 마켓 앱을 이용해 주셔서 대단히 감사합니다!

📱 주요 기능 (Features)

앱에 구현된 핵심 기능은 다음과 같습니다.

1. 상품 등록 (판매 기능)

다중 이미지 업로드 (최대 3개):

휴대폰 갤러리에서 여러 장의 사진을 동시에 선택할 수 있습니다.

인터넷 이미지 URL을 직접 붙여넣기 하여 이미지를 첨부할 수 있습니다.

이미지 미리보기 및 삭제: 첨부된 이미지를 수평 스크롤 뷰에서 썸네일로 확인하고, 개별적으로 삭제(X)할 수 있습니다.

가격 입력 포맷팅: 가격 입력 시 intl 패키지를 활용하여 실시간으로 1,000단위 콤마(,)가 자동 적용됩니다.

입력 유효성 검사: 이름, 가격, 재고 등 필수 항목이 비어있지 않은지 검증합니다.

2. 홈 (상품 목록)

실시간 재고 필터링: ProductStore의 재고가 1개 이상(inventory > 0)인 상품만 사용자에게 노출됩니다.

이미지 로더: URL, 로컬 파일(갤러리), 앱 내부 에셋(샘플) 등 모든 종류의 이미지 경로를 자동으로 인식하여 올바르게 표시합니다.

원화(₩) 포맷팅: 모든 상품 가격에 콤마(,)와 원화 기호(₩)가 적용됩니다.

3. 상품 상세

다중 이미지 스와이퍼: 등록된 모든 이미지를 좌우로 넘겨볼 수 있는 PageView를 구현했습니다.

페이지 인디케이터: 현재 보고 있는 이미지의 순서를 점(.)으로 표시합니다.

이미지 확대 보기: 이미지를 탭하면 InteractiveViewer를 사용한 전체 화면 다이얼로그가 나타나, 사진을 자유롭게 확대/축소/이동할 수 있습니다.

장바구니 담기: 'Add to Cart' 버튼을 누르면 CartStore의 재고 확인 로직을 거쳐 상품이 장바구니에 담기고, 페이지는 이동하지 않습니다.

4. 장바구니 (핵심 로직)

실시간 재고 연동:

장바구니에 담긴 상품이라도 결제가 완료되기 전까지는 메인 재고(ProductStore)가 차감되지 않습니다.

상품 추가 또는 수량 변경 시, ProductStore의 최신 재고를 확인하여 현재 재고 이상으로 담을 수 없도록 제한합니다.

수량 조절:

+ 버튼: 현재 재고 수량에 도달하면 버튼이 비활성화됩니다.

- 버튼: 수량이 1일 때 버튼이 비활성화되어 0으로 내려가지 않습니다.

항목 삭제: 휴지통 아이콘을 탭하여 원하는 항목만 장바구니에서 제거할 수 있습니다.

결제 처리:

'결제하러 가기' 버튼 클릭 시 확인 다이얼로그가 나타납니다.

"확인"을 누르는 시점에 ProductStore의 실제 재고가 차감되며, 장바구니가 비워집니다.

🛠️ 기술 스택 (Tech Stack)

Framework: Flutter

Language: Dart

State Management: ChangeNotifier와 InheritedNotifier를 활용한 커스텀 Provider 패턴

ProductStore: 앱의 전체 상품 목록과 재고를 관리합니다.

CartStore: 장바구니 상태를 관리하며, 재고 확인을 위해 ProductStore와 연동됩니다.

Packages:

image_picker: 갤러리 접근 및 다중 이미지 선택

intl: 원화(₩) 및 숫자 포맷팅

📁 프로젝트 구조

lib/
├── constants/
│   └── colors.dart         # 앱 공통 색상 정의
├── core/
│   └── product.dart        # Product 데이터 모델 (imageAssets 리스트 포함)
├── state/
│   ├── cart_store.dart     # 장바구니 상태 관리 (CartStore)
│   └── product_store.dart  # 상품 목록 및 재고 관리 (ProductStore)
├── view/
│   ├── cart/
│   │   └── cart_page.dart  # 5. 장바구니 페이지
│   ├── home/
│   │   ├── home_page.dart  # 2. 메인 상품 목록 페이지
│   │   └── start_page.dart # 1. 표지 (시작) 페이지
│   ├── product/
│   │   └── add_product_page.dart # 4. 상품 등록 페이지
│   └── ttotoy_detail/
│       └── ttotoy_detail_page.dart # 3. 상품 상세 페이지
├── theme/
│   └── app_theme.dart      # 앱 전역 테마 (디자인 시스템)
└── main.dart               # 앱 진입점 (Provider 설정)



🚀 설치 및 실행

프로젝트 복제:

git clone [https://github.com/AllbAd1/ttotoy_app.git](https://github.com/AllbAd1/ttotoy_app.git)


폴더 이동:

cd ttotoy_app


Flutter 패키지 설치:

flutter pub get


(필수) iOS 권한 설정:
image_picker를 사용하기 위해, ios/Runner/Info.plist 파일에 다음 권한을 추가해야 합니다.

<key>NSPhotoLibraryUsageDescription</key>
<string>상품 등록을 위해 갤러리 접근 권한이 필요합니다.</string>
<key>NSCameraUsageDescription</key>
<string>상품 등록을 위해 카메라 접근 권한이 필요합니다.</string>


앱 실행:

flutter run


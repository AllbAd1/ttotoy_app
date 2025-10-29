import 'dart:io'; // ★★★ 파일 이미지를 위해 import 추가 ★★★
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../state/cart_store.dart';
import '../../core/product.dart' hide CartItem;  // CartItem 이름이 중복으로 사용되기 때문에 숨겨서 가져오는것으로 적용
// (기존 import '../../core/product.dart'; 삭제) 

import 'package:intl/intl.dart'; //   금액 포맷팅을 위해 추가

class CartPage extends StatelessWidget { //cart page 클래스 시작
  const CartPage({super.key}); //cart page 생성자

  @override 
  Widget build(BuildContext context) {  
    final theme = Theme.of(context); // 테마 가져오기
    final cartStore = CartProvider.of(context); // cart store 가져오기

    return Scaffold( // Scaffold 위젯 반환
      backgroundColor: theme.scaffoldBackgroundColor, // 배경색 설정
      appBar: AppBar( // 앱바 설정
        backgroundColor: theme.colorScheme.surface, // 앱바 배경색 설정
        elevation: 0, // 그림자 제거
        centerTitle: true, // 제목 중앙 정렬
        title: Text( // 제목 텍스트 설정
          'Cart',
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20), // 제목 스타일 설정
        ),
      ),
      body: AnimatedBuilder(  // 애니메이션 빌더 사용
        animation: cartStore,  // cartStore를 애니메이션으로 사용
        builder: (context, _) {  
          
          final items = cartStore.items;//  여기서 사용하는 items와 CartItem은 cart_store.dart에서 가져옴
          if (items.isEmpty) {  // 장바구니가 비어있는 경우
            return const Center(  // 중앙에 텍스트 표시
              child: Text('장바구니가 비어 있어요.'),
            );
          }
          final totalPrice = cartStore.totalPrice;  // 총 가격 계산
          return Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),  
            child: Column(  
              children: [  
                Expanded(  // 남은 공간을 모두 차지
                  child: ListView.separated(  // 구분자가 있는 리스트뷰
                    itemCount: items.length,  //  아이템 개수 설정
                    separatorBuilder: (_, __) => const SizedBox(height: 12),  // 아이템 사이 간격 설정
                    itemBuilder: (context, index) {  // 아이템 빌더
                      final cartItem = items[index];  
                      return _CartItemCard(cartItem: cartItem);  // _CartItemCard 위젯 반환
                    },
                  ),
                ),
                const SizedBox(height: 20),  // 아이템과 합계 사이 간격
                _CartSummary(total: totalPrice),  // 합계 위젯
                const SizedBox(height: 12),  // 합계와 버튼 사이 간격
                ElevatedButton(  // 결제 버튼
                  onPressed: () {  // 버튼 눌렀을 때
                    showDialog(  // 다이얼로그 표시
                        context: context,  
                        barrierDismissible: true,  // 바깥쪽 터치로 닫기 가능
                        builder: (BuildContext context) {  
                          return AlertDialog(  // 알림 대화상자
                            title: const Text('결제를 하시겠습니까?'),
                            content: const Text('확인 버튼을 누르면 결제가 진행됩니다'),
                            actions: [  // 액션 버튼들
                              ElevatedButton(  // 취소 버튼
                                style: ElevatedButton.styleFrom(  // 버튼 스타일 설정
                                  minimumSize: const Size(80, 40), // 버튼 크기 지정
                                  backgroundColor:  
                                      Colors.grey.shade200, // 취소 버튼은 배경색을 다르게
                                  foregroundColor: Colors.black87, // 취소 버튼 텍스트 색상
                                ),
                                onPressed: () => Navigator.pop(context), // 다이얼로그 닫기
                                child: const Text('취소'),  // 버튼 텍스트
                              ),
                              ElevatedButton(  // 확인 버튼
                                style: ElevatedButton.styleFrom(  // 버튼 스타일 설정
                                  minimumSize: const Size(80, 40), // 버튼 크기 지정
                                ),
                                onPressed: () {  // 확인 버튼 눌렀을 때
                                  cartStore.clear();  //  장바구니 비우기
                                  Navigator.pop(context);  // 다이얼로그 닫기
                                },
                                child: const Text('확인'),  
                              ),
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(  // 버튼 스타일 설정
                    minimumSize: const Size(double.infinity, 54),  // 버튼 크기 지정
                  ),
                  child: const Text('결제하러 가기'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {  // CartItem 카드 위젯
 
  const _CartItemCard({required this.cartItem}); // 여기서 사용하는 CartItem도  cart_store.dart에서 가져옴

  final CartItem cartItem; // CartItem 속성

  @override
  Widget build(BuildContext context) { 
    final theme = Theme.of(context);
    final cartStore = CartProvider.of(context); // cart store 가져오기
    final currencyFormat = NumberFormat.currency(  //   금액 포맷터 설정
      locale: 'ko_KR', //    한국 로케일 (쉼표 그룹핑)
      symbol: '₩', //    통화 기호 설정
      decimalDigits: 0, //    소수점 자리수 없음
    );

    return Container(  
      decoration: BoxDecoration(  // 카드 스타일 설정
        color: theme.colorScheme.surface,  // 카드 배경색
        borderRadius: BorderRadius.circular(16),  // 모서리 둥글게
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),  // 그림자 색상
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12), // 카드 내부 여백
      child: Row(  // 가로 레이아웃
        children: [
          IconButton(
            icon: const Icon(Icons.delete_outline), // 삭제 아이콘
            color: AppColors.descriptionGray, // 아이콘 색상
            
            onPressed: () => cartStore.removeProduct(cartItem.product),// 여기서 사용하는 product는 core/product.dart의 Product를 가져옴.
            padding: EdgeInsets.zero, // 아이콘 버튼 패딩 제거
            constraints: const BoxConstraints(), // 아이콘 버튼 크기 제약 제거
          ),
          const SizedBox(width: 8),  // 아이콘과 이미지 사이 간격
          ClipRRect(
            borderRadius: BorderRadius.circular(12), // 이미지 모서리 둥글게
            child: _CartProductImage(  // 커스텀 이미지 위젯
              imageUrl: cartItem.product.imageAsset,  // 이미지 URL
              width: 70,
              height: 70,
            ),
          ),
          const SizedBox(width: 12), // 이미지와 텍스트 사이 간격
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
              children: [
                Text(
                  cartItem.product.name, // 상품 이름
                  style: theme.textTheme.titleLarge, // 제목 스타일
                ),
                const SizedBox(height: 4), // 이름과 가격 사이 간격
                Text(
                  currencyFormat.format(cartItem.product.price), // 금액 포맷팅 적용
                  //'₩${cartItem.product.price.toStringAsFixed(0)}', // 기존 금액 표시 방식 주석으로 변경
                  style: theme.textTheme.titleLarge?.copyWith( // 가격 스타일
                    color: AppColors.primaryPeach, // 주요 색상 적용
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12), // 텍스트와 수량 조절기 사이 간격
          _QuantityControl( // 수량 조절기 위젯
            quantity: cartItem.quantity,  // 현재 수량
            inventory: cartItem.product.inventory,  // 재고 수량
            onChanged: (delta) { // 수량 변경 콜백
              final success =  // 변경 성공 여부
                  cartStore.changeQuantity(cartItem.product, delta);  // 수량 변경 시도
              if (!success && delta > 0) { // 증가 시에만 재고 부족 메시지 표시
                ScaffoldMessenger.of(context).showSnackBar( // 스낵바 표시
                  const SnackBar(content: Text('재고 수량을 초과할 수 없어요.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget { // 수량 조절기 위젯
  const _QuantityControl({  
    required this.quantity, // 현재 수량
    required this.inventory,  // 재고 수량
    required this.onChanged  // 수량 변경 콜백
  });

  final int quantity;  // 현재 수량
  final int inventory;  // 재고 수량
  final ValueChanged<int> onChanged;  // 수량 변경 콜백

  @override
  Widget build(BuildContext context) {   
    final theme = Theme.of(context);
    final bool canDecrease = quantity > 1;  // 감소 가능 여부
    final bool canIncrease = quantity < inventory;  // 증가 가능 여부

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),  // 모서리 둥글게
        border: Border.all(  // 테두리 설정
          color: AppColors.descriptionGray.withValues(alpha: 0.4), // 테두리 색상
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,  // 최소 크기
        children: [
          IconButton(  // 감소 버튼
            icon: const Icon(Icons.remove),  // 아이콘
            color: canDecrease ? theme.colorScheme.primary : Colors.grey,  // 활성화 여부에 따른 색상
            onPressed: canDecrease ? () => onChanged(-1) : null,  // 감소 가능 시에만 콜백 호출
          ),
          Text(
            '$quantity',  // 현재 수량 표시
            style: theme.textTheme.titleMedium, // 텍스트 스타일
          ),
          IconButton(
            icon: const Icon(Icons.add), // 증가 버튼 아이콘
            color: canIncrease ? theme.colorScheme.primary : Colors.grey,  // 활성화 여부에 따른 색상
            onPressed: canIncrease ? () => onChanged(1) : null,  // 증가 가능 시에만 콜백 호출
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {  // 장바구니 합계 위젯
  const _CartSummary({required this.total}); // 생성자

  final double total;  // 총 금액 속성

  @override
  Widget build(BuildContext context) {  
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(  //   금액 포맷터 설정
      locale: 'ko_KR',  //    한국 로케일 (쉼표 그룹핑)
      symbol: '₩',  //    통화 기호 설정
      decimalDigits: 0,  //    소수점 자리수 없음
    );

    return Container(   // 합계 컨테이너
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),  // 내부 여백
      decoration: BoxDecoration(  //
        color: theme.colorScheme.surface,  // 배경색
        borderRadius: BorderRadius.circular(16),  // 모서리 둥글게
      ),
      child: Row(  // 가로 레이아웃
        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 양쪽 정렬
        children: [
          Text(
            '합계',
            style: theme.textTheme.titleMedium,  // 텍스트 스타일
          ),
          Text(
            currencyFormat.format(total),  //   금액 포맷팅 적용
            //'₩${total.toStringAsFixed(0)}',  // 기존 금액 표시 방식 주석으로 변경
            style: theme.textTheme.titleLarge?.copyWith( // 텍스트 스타일
              color: AppColors.primaryPeach,  // 주요 색상 적용
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartProductImage extends StatelessWidget {  // 장바구니 상품 이미지 위젯
  const _CartProductImage({  
    required this.imageUrl,  // 이미지 URL
    this.width = 70.0,  
    this.height = 70.0,
  });

  final String imageUrl;  
  final double width;  // 이미지 너비
  final double height; // 이미지 높이

  Widget _buildErrorWidget() {  // 에러 위젯 빌더
    return Container(  // 에러 위젯 컨테이너
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.broken_image_outlined,
        color: Colors.grey[400],
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {  
    if (imageUrl.startsWith('http')) {  // URL 이미지 처리
      return Image.network(  // 네트워크 이미지
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) { // 로딩 빌더
          if (progress == null) return child;  // 로딩 완료 시 이미지 반환
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),  // 로딩 인디케이터
          );
        },
        errorBuilder: (context, error, stackTrace) {  // 에러 빌더
          return _buildErrorWidget();  // 에러 위젯 반환
        },
      );
    } else if (imageUrl.startsWith('assets/')) {  // 앱 에셋 이미지 처리
      return Image.asset(  // 에셋 이미지
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {  // 에러 빌더
          return _buildErrorWidget();  // 에러 위젯 반환
        },
      );
    } else {
      final file = File(imageUrl);  // 로컬 파일 이미지 처리
      if (imageUrl.isNotEmpty && file.existsSync()) {  // 파일 존재 여부 확인
        return Image.file(  // 파일 이미지
          file,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) { 
            return _buildErrorWidget(); // 에러 위젯 반환
          },
        );
      } else {  // 파일이 없을 경우
        return _buildErrorWidget();  // 에러 위젯 반환
      }
    }
  }
}

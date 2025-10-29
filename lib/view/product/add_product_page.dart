import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 패키지 임포트

import '../../constants/colors.dart';
import '../../core/product.dart';
import '../../state/product_store.dart';

import 'package:flutter/services.dart'; //    TextInputFormatter를 위해 추가
import 'package:intl/intl.dart'; //   금액 포맷팅을 위해 추가


// 가격 입력 필드 포맷터 (쉼표 추가)
class _PriceFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat('#,###', 'ko_KR');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. 숫자 이외의 문자 제거
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 2. 입력값이 없으면 빈 문자열 반환
    if (newText.isEmpty) {
      return TextEditingValue.empty;
    }

    // 3. 숫자로 변환
    int value = int.tryParse(newText) ?? 0;

    // 4. 포맷팅 적용
    String formattedText = formatter.format(value);

    // 5. 커서 위치 조정
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}


class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // 이미지 파일 상태 관리를 위한 변수
  File? _selectedFile; // 갤러리에서 선택한 파일
  String? _selectedUrl; // URL로 입력받은 이미지 주소

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _inventoryController = TextEditingController();
  final _sizeController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _inventoryController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: _onSave,
            child: Text(
              'Save',
              style: theme.textTheme.labelLarge?.copyWith(color: AppColors.primaryPeach), // 저장 버튼 색상 적용
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 선택 영역
              _PhotoPlaceholder(
                onTap: _onPickPhoto, // 선택 UI 띄우기
                imageFile: _selectedFile,
                imageUrl: _selectedUrl,
              ),
              const SizedBox(height: 24),
              // 상품 이름
              _buildTextField(
                controller: _titleController,
                label: '이름',
                hint: '이름을 입력 해주세요!',
              ),
              const SizedBox(height: 16),
              // 상품 설명
              _buildTextField(
                controller: _descriptionController,
                label: '설명',
                hint: '설명을 입력 해주세요!',
                maxLines: 6, // 입력칸 늘림
              ),
              const SizedBox(height: 16),
              // 가격
              _buildTextField(
                 controller: _priceController,
                 label: '가격',
                 hint: '20,000',
                 keyboardType: TextInputType.number,
                 inputFormatters: [
                   _PriceFormatter(), // 쉼표 포맷터 적용
                   LengthLimitingTextInputFormatter(11), // 자리수 제한
                 ],
               ),
              const SizedBox(height: 16),
              // 재고 수량
              _buildTextField(
                controller: _inventoryController,
                label: '재고수량',
                hint: '숫자만 입력하세요',
                keyboardType: TextInputType.number,
                 inputFormatters: [
                   FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 허용
                   LengthLimitingTextInputFormatter(5), // 예: 최대 5자리
                 ]
              ),
              const SizedBox(height: 16),
              // 사용 연령
              _buildTextField(
                 controller: _sizeController,
                 label: '사용연령',
                 hint: '3~6개월',
               ),
            ],
          ),
        ),
      ),
      // 하단 저장 버튼
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Save', style: TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }

  // 공통 텍스트 필드 빌더
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters, // 포맷터 추가
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,// inputFormatters 적용
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: (controller == _priceController) ? '₩' : null, // 가격 필드에 '₩' 추가
        hintStyle: TextStyle(
          color: Colors.grey.shade400, // 힌트 텍스트 색상 연하게
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 패딩 조정
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder( // 기본 테두리
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder( // 포커스 시 테두리
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primaryPeach, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label을(를) 입력해 주세요.';
        }
        if (controller == _priceController) {
          final priceInput = value.trim().replaceAll(RegExp(r'[^0-9]'), '');
          if (priceInput.isEmpty || (double.tryParse(priceInput) ?? 0) <= 0) {
            return '올바른 가격을 입력해 주세요.';
          }
        }
         if (controller == _inventoryController) {
          final invInput = value.trim();
          if (invInput.isEmpty || (int.tryParse(invInput) ?? -1) < 0) {
             return '올바른 재고 수량을 입력해 주세요.';
          }
        }
        return null;
      },
    );
  }

  // 갤러리 또는 URL 선택 UI 띄우기
  void _onPickPhoto() {
    FocusScope.of(context).unfocus(); // 키보드 닫기
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리에서 선택'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('URL로 입력'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showUrlInputDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 갤러리에서 이미지 가져오기
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _selectedUrl = null; // URL 선택 초기화
      });
    }
  }

  // URL 입력 다이얼로그
  Future<void> _showUrlInputDialog() async {
    final urlController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('이미지 URL 입력'),
          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(hintText: 'https://...'),
            keyboardType: TextInputType.url,
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                final url = urlController.text.trim();
                if (url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'))) {
                   Navigator.of(context).pop(url);
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('유효한 URL을 입력해 주세요.')),
                   );
                }
              },
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedUrl = result;
        _selectedFile = null; // 파일 선택 초기화
      });
    }
  }

  // 저장 로직
  void _onSave() {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedFile == null && _selectedUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 선택해 주세요.')),
      );
      return;
    }

    final priceInput = _priceController.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(priceInput);
    final inventory = int.tryParse(_inventoryController.text.trim());

    if (price == null || price <= 0 || inventory == null || inventory < 0) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('가격 또는 재고 수량이 올바르지 않습니다.')),
       );
       return;
     }

    final String imageAssetPath;
    if (_selectedUrl != null && _selectedUrl!.isNotEmpty) {
      imageAssetPath = _selectedUrl!;
    } else {
      imageAssetPath = _selectedFile!.path;
    }

    final product = Product(
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      imageAsset: imageAssetPath,
      inventory: inventory,
      size: (_sizeController.text.trim().isEmpty)
          ? '0-3개월' // 기본값 설정
          : _sizeController.text.trim(),
    );

    ProductProvider.of(context, listen: false).addProduct(product);
    Navigator.of(context).pop();
  }
}

// ★★★ _PhotoPlaceholder 위젯 수정 (BoxFit.contain 적용) ★★★
class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({
    required this.onTap,
    this.imageFile,
    this.imageUrl, // URL을 받도록 추가
  });

  final VoidCallback onTap;
  final File? imageFile;
  final String? imageUrl; // URL 변수

  @override
  Widget build(BuildContext context) {
    Widget content;

    // 1. URL 이미지가 있으면 네트워크 이미지 표시
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = Image.network(
        imageUrl!,
        width: double.infinity,
        height: 220, //   이미지 입력칸 높이 수정
        // ★★★ BoxFit.contain으로 변경하여 이미지 전체가 보이도록 함 ★★★
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
        errorBuilder: (context, error, stackTrace) {
          // URL 로드 실패 시 에러 아이콘 표시
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.grey.shade400,
                  size: 48,
                ),
                 const SizedBox(height: 8),
                 Text(
                   '이미지 로드 실패',
                   style: TextStyle(color: Colors.grey.shade600),
                 ),
              ],
            ),
          );
        },
      );
    }
    // 2. 갤러리 파일이 있으면 파일 이미지 표시
    else if (imageFile != null) {
      content = Image.file(
        imageFile!,
        width: double.infinity,
        height: 220, //   이미지 입력칸 높이 수정
        // ★★★ BoxFit.contain으로 변경하여 이미지 전체가 보이도록 함 ★★★
        fit: BoxFit.contain,
      );
    }
    // 3. 둘 다 없으면 기본 아이콘 표시
    else {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            color: Colors.grey.shade400,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'Photo',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.descriptionGray,
                ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220, //   이미지 입력칸 높이 수정
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100, // 배경색 약간 추가
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300, // 테두리 색상 연하게
          ),
        ),
        // ClipRRect는 이미지 비율과 관계없이 둥근 모서리를 적용하기 위해 유지
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: content,
        ),
      ),
    );
  }
}



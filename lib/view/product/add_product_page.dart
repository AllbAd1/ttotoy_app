import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 패키지 임포트

import '../../constants/colors.dart';
import '../../core/product.dart';
import '../../state/product_store.dart';

import 'package:flutter/services.dart'; // ★★★ 오타 수정 (package. -> package:) ★★★
import 'package:intl/intl.dart'; // ★★★ 오타 수정 (package. -> package:) ★★★


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
  // ★★★ 이미지 리스트 (기존과 동일) ★★★
  final List<dynamic> _images = []; // File 또는 String(URL)을 담는 리스트

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  //final _categoryController = TextEditingController();    카테고리 입력칸 삭제
  final _inventoryController = TextEditingController();
  final _sizeController = TextEditingController();
  //final _colorController = TextEditingController();   컬러 입력칸 삭제

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    //_categoryController.dispose();    카테고리 입력칸 삭제
    _inventoryController.dispose();
    _sizeController.dispose();
    //_colorController.dispose();   컬러 입력칸 삭제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);//    앱 바 우측 상단 save 텍스트버튼 테마 비활성화
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(fontSize: 20)),
        /* 앱바 옆 저장버튼 비활성화
        actions: [
          TextButton(
            onPressed: _onSave,
            child: Text(
              'Save',
              style: theme.textTheme.labelLarge?.copyWith(color: AppColors.primaryPeach), // 저장 버튼 색상 적용
            ),
          ),
        ],
        */
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ★★★ 이미지 선택 UI (_PhotoGrid 위젯) ★★★
              _PhotoGrid(
                images: _images,
                onAdd: _onPickPhoto,
                onRemove: (index) {
                  setState(() {
                    _images.removeAt(index);
                  });
                },
              ),
              const SizedBox(height: 24),
              // (이하 폼 필드는 동일)
              _buildTextField(
                controller: _titleController,
                label: '이름',
                hint: '이름을 입력 해주세요!',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: '설명',
                hint: '설명을 입력 해주세요!',
                maxLines: 6, //   입력칸 늘림
              ),
              const SizedBox(height: 16),
              _buildTextField(
                 controller: _priceController,
                 label: '가격',
                 hint: '20,000', //    힌트 텍스트 변경 ₩ >> ₩20,000 >> 20,000
                 keyboardType: TextInputType.number,
                 inputFormatters: [
                   _PriceFormatter(), // 쉼표 포맷터 적용
                   LengthLimitingTextInputFormatter(11), // 11자리 (9,999,999,999) 제한 (이제 정상 작동)
                 ],
               ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _inventoryController,
                label: '재고수량', //   '재고 수량' >> '재고수량'으로 변경
                hint: '숫자만 입력하세요',
                keyboardType: TextInputType.number,
                 inputFormatters: [
                   FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 허용 (이제 정상 작동)
                   LengthLimitingTextInputFormatter(5), // 예: 최대 5자리
                 ]
              ),
              const SizedBox(height: 16),
              _buildTextField(
                 controller: _sizeController,
                 label: '사용연령',
                 hint: '3~6개월', //    영어를 한글로 변경, '예시 0~3개월' >> '3~6개월' 변경
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

  // 공통 텍스트 필드 빌더 (기존과 동일)
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters, //   추가된 매개변수
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,//   inputFormaters 적용
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: (controller == _priceController) ? '₩' : null, //   가격입력 시, ₩자동설정
        hintStyle: TextStyle(
        color: Colors.grey.shade400, //   힌트텍스트 컬러 변경 : 기존보다 더 연한 회색 (예: grey.shade400)
      ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12), //    설명 텍스트 위로 정렬
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

  // 갤러리 또는 URL 선택 UI 띄우기 (기존과 동일)
  void _onPickPhoto() {
    if (_images.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진은 최대 3개까지 추가할 수 있습니다.')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
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
                  _getImagesFromGallery(); // 여러 이미지 선택 함수 호출
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

  // 갤러리에서 "여러" 이미지 가져오기 로직 (기존과 동일)
  Future<void> _getImagesFromGallery() async {
    final picker = ImagePicker();
    // pickMultiImage 사용
    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 80, // 이미지 품질 조절 (선택적)
    );

    if (pickedFiles.isNotEmpty) {
      setState(() {
        for (var file in pickedFiles) {
          if (_images.length < 3) {
            _images.add(File(file.path));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('사진은 최대 3개까지 추가할 수 있습니다.')),
            );
            break; // 3개 초과 시 반복 중단
          }
        }
      });
    }
  }

  // URL 입력 다이얼로그 (기존과 동일)
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
        if (_images.length < 3) {
          _images.add(result); // URL을 리스트에 추가
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('사진은 최대 3개까지 추가할 수 있습니다.')),
          );
        }
      });
    }
  }

  // ★★★ 저장 로직 (imageAssets로 수정) ★★★
  void _onSave() {
    if (_formKey.currentState?.validate() != true) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 1개 이상 선택해 주세요.')),
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

    // _images 리스트를 String 리스트로 변환
    final List<String> imagePaths = _images.map((image) {
      if (image is File) {
        return image.path;
      }
      return image as String;
    }).toList();


    final product = Product(
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      // ★★★ imageAsset -> imageAssets로 수정 (Product 모델과 일치) ★★★
      imageAssets: imagePaths,
      inventory: inventory,
      size: (_sizeController.text.trim().isEmpty)
          ? '0-3개월'
          : _sizeController.text.trim(),
    );

    ProductProvider.of(context, listen: false).addProduct(product);
    Navigator.of(context).pop();
  }
}

// ( _PhotoGrid, _AddPhotoButton, _ImageThumbnail 위젯은 기존과 동일 )
class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  final List<dynamic> images;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddPhotoButton(onTap: onAdd);
          }
          final imageIndex = index - 1;
          final image = images[imageIndex];
          return _ImageThumbnail(
            image: image,
            onRemove: () => onRemove(imageIndex),
          );
        },
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  const _AddPhotoButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade600),
              const SizedBox(height: 4),
              Text(
                '${context.findAncestorStateOfType<_AddProductPageState>()?._images.length ?? 0}/3',
                style: TextStyle(color: Colors.grey.shade600),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  const _ImageThumbnail({required this.image, required this.onRemove});
  final dynamic image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (image is File) {
      imageWidget = Image.file(image, fit: BoxFit.cover, width: 100, height: 100,);
    } else if (image is String) {
      imageWidget = Image.network(image, fit: BoxFit.cover, width: 100, height: 100,
        errorBuilder: (c, e, s) => const Icon(Icons.error_outline),);
    } else {
      imageWidget = const Icon(Icons.error);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageWidget,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


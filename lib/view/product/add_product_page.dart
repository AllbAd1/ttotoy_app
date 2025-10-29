import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 패키지 임포트

import '../../constants/colors.dart';
import '../../core/product.dart';
import '../../state/product_store.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // ★★★ 이미지 파일 상태 관리를 위한 변수 추가 ★★★
  File? _selectedFile; // 갤러리에서 선택한 파일
  String? _selectedUrl; // URL로 입력받은 이미지 주소

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
    //_colorController.dispose();   카테고리 입력칸 삭제
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
              style: theme.textTheme.labelLarge,
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
              // ★★★ _selectedFile과 _selectedUrl을 PhotoPlaceholder에 전달 ★★★
              _PhotoPlaceholder(
                onTap: _onPickPhoto, // 선택 UI 띄우기
                imageFile: _selectedFile,
                imageUrl: _selectedUrl,
              ),
              const SizedBox(height: 24),
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
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: '가격',
                      hint: '₩20,000', //    힌트 텍스트 변경 ₩ >> ₩20,000
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  //    카테고리 입력칸 삭제
                  /*const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _categoryController,
                      label: '카테고리',
                      hint: '남아 or 여아',
                    ),
                  ), 
                  */
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _sizeController,
                      label: '사용연령',
                      hint: '3~6개월', //    영어를 한글로 변경, '예시 0~3개월' >> '3~6개월' 변경
                    ),
                  ),
                  //    색상 입력칸 삭제
                  /*const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _colorController,
                      label: '색상',
                      hint: '',
                    ),
                  ),*/
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _inventoryController,
                label: '재고수량', //   '재고 수량' >> '재고수량'으로 변경
                hint: '',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //    설명 텍스트 위로 정렬
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label을(를) 입력해 주세요.';
        }
        return null;
      },
    );
  }

  // ★★★ 갤러리 또는 URL 선택 UI 띄우기 (수정됨) ★★★
  void _onPickPhoto() {
    // 키보드가 열려있으면 닫기
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

  // ★★★ 갤러리에서 이미지 가져오기 로직 (수정됨) ★★★
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

  // ★★★ URL 입력 다이얼로그 띄우기 (신규 추가) ★★★
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
                if (urlController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(urlController.text.trim());
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

  void _onSave() {
    if (_formKey.currentState?.validate() != true) return;

    // ★★★ 이미지 선택 검증 (파일 또는 URL) (수정됨) ★★★
    if (_selectedFile == null && _selectedUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 선택해 주세요.')),
      );
      return;
    }

    final normalizedPrice =
        _priceController.text.trim().replaceAll(',', '.');
    final priceInput =
        normalizedPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    final price = double.tryParse(priceInput);

    final inventory = int.tryParse(_inventoryController.text.trim());

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가격이 올바르지 않습니다.')),
      );
      return;
    }

    if (inventory == null || inventory <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('재고수량을 올바르게 입력해 주세요.')), //   '재고 수량' >> '재고수량' 변경
      );
      return;
    }

    // ★★★ 이미지 경로 결정 (URL 우선) (신규 추가) ★★★
    final String imageAssetPath;
    if (_selectedUrl != null && _selectedUrl!.isNotEmpty) {
      imageAssetPath = _selectedUrl!;
    } else {
      // 실제 앱에서는 파일을 서버에 업로드하고 URL을 받아야 합니다.
      // 여기서는 시연을 위해 로컬 파일 경로를 임시로 사용합니다.
      imageAssetPath = _selectedFile!.path;
    }


    final product = Product(
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      // ★★★ 선택된 이미지 파일의 경로를 사용 (수정됨) ★★★
      imageAsset: imageAssetPath,
      inventory: inventory,
      size: (_sizeController.text.trim().isEmpty)
          ? '0-3개월' //    영어를 한글로 변경
          : _sizeController.text.trim(),
      //    컬러 입력칸 삭제
      /*color: (_colorController.text.trim().isEmpty)
          ? 'Gray'
          : _colorController.text.trim(),
          */
    );

    ProductProvider.of(context).addProduct(product);
    Navigator.of(context).pop();
  }
}

// ★★★ _PhotoPlaceholder 위젯 수정 (URL 표시 기능 추가) ★★★
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
        fit: BoxFit.cover,
        width: double.infinity,
        height: 180,
        // URL 로딩 중 에러 처리
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.error_outline,
              color: AppColors.descriptionGray,
              size: 48,
            ),
          );
        },
      );
    } 
    // 2. 갤러리 파일이 있으면 파일 이미지 표시
    else if (imageFile != null) {
      content = Image.file(
        imageFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 180,
      );
    } 
    // 3. 둘 다 없으면 기본 아이콘 표시
    else {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            color: AppColors.descriptionGray,
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
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.descriptionGray.withValues(alpha: 0.3),
          ),
        ),
        // ClipRRect로 감싸서 이미지가 둥근 모서리를 넘지 않도록 함
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: content,
        ),
      ),
    );
  }
}



import 'dart:io';// dart:io와 image_picker를 사용하기 위해 추가.

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _selectedImage;
  // ★★★

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _inventoryController = TextEditingController();
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _inventoryController.dispose();
    _sizeController.dispose();
    _colorController.dispose();
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
              // ★★★ _selectedImage 상태를 PhotoPlaceholder에 전달 ★★★
              _PhotoPlaceholder(
                onTap: _onPickPhoto,
                imageFile: _selectedImage,
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
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: '가격',
                      hint: '₩',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _categoryController,
                      label: '카테고리',
                      hint: '남아 or 여아',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _sizeController,
                      label: '사용연령',
                      hint: '예시 0~3M',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _colorController,
                      label: '색상',
                      hint: '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _inventoryController,
                label: '재고 수량',
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  // ★★★ 이미지 피커 로직으로 대체 ★★★
  void _onPickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState?.validate() != true) return;
    
    // 이미지 선택 검증
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    final normalizedPrice =
        _priceController.text.trim().replaceAll(',', '.');
    final priceInput =
        normalizedPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    final price = double.tryParse(priceInput);
    
    final inventory = int.tryParse(_inventoryController.text.trim()) ?? 0;
    
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price.')),
      );
      return;
    }

    final product = Product(
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      // ★★★ 선택된 이미지 파일의 경로를 사용 (실제 앱에서는 서버에 업로드 후 URL 사용) ★★★
      imageAsset: _selectedImage!.path, 
      inventory: inventory,
      size: (_sizeController.text.trim().isEmpty)
          ? '0-3M'
          : _sizeController.text.trim(),
      color: (_colorController.text.trim().isEmpty)
          ? 'Gray'
          : _colorController.text.trim(),
    );

    ProductProvider.of(context).addProduct(product);
    Navigator.of(context).pop();
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  // ★★★ imageFile 매개변수 추가 ★★★
  const _PhotoPlaceholder({required this.onTap, this.imageFile}); 

  final VoidCallback onTap;
  final File? imageFile; // ★★★ File 타입 변수 추가

  @override
  Widget build(BuildContext context) {
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
        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                // ★★★ 선택된 이미지를 화면에 표시 ★★★
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              )
            // ★★★ 이미지가 없을 때 기존 플레이스홀더 표시 ★★★
            : Column(
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
              ),
      ),
    );
  }
}

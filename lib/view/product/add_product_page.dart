import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../core/product.dart';
import '../../state/product_store.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
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
        title: const Text('Add Product', style: TextStyle(fontSize: 20),),
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
              _PhotoPlaceholder(onTap: _onPickPhoto),
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
                hint:
                    '설명을 입력 해주세요!',
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: '가격',
                      hint: '\₩',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  /*
                  const SizedBox(width: 16),
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
                      hint: '예시 0~3M',
                    ),
                  ),
                  /*
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _colorController,
                      label: '색상',
                      hint: '',
                    ),
                  ),
                  */
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
            child: const Text('Save', style: TextStyle(fontSize: 20),),
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

  void _onPickPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo picker will be added soon.')),
    );
  }

  void _onSave() {
    if (_formKey.currentState?.validate() != true) return;
    final normalizedPrice =
        _priceController.text.trim().replaceAll(',', '.');
    final priceInput =
        normalizedPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    final price = double.tryParse(priceInput);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price.')),
      );
      return;
    }

    final inventory = int.tryParse(_inventoryController.text.trim());
    if (inventory == null || inventory <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('재고 수량을 올바르게 입력해 주세요.')),
      );
      return;
    }

    final product = Product(
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      imageAsset: 'assets/images/Ttotoy_5.webp',
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
  const _PhotoPlaceholder({required this.onTap});

  final VoidCallback onTap;

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
        child: Column(
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

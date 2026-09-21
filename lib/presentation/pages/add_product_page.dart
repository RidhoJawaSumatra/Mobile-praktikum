import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/add_product.dart';

class AddProductPage extends StatefulWidget {
  final ProductRepository repository;

  const AddProductPage({
    super.key,
    required this.repository,
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  late final AddProduct addProduct;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final imageUrlController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    addProduct = AddProduct(widget.repository);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    imageUrlController.dispose();
    categoryController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      price: double.parse(priceController.text),
      quantity: int.parse(quantityController.text),
      imageUrl: imageUrlController.text.trim(),
      category: categoryController.text.trim(),
      description: descriptionController.text.trim(),
    );

    addProduct(product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produk berhasil ditambahkan'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextField(
              controller: nameController,
              label: 'Nama Produk',
              icon: Icons.shopping_bag,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: priceController,
              label: 'Price',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price wajib diisi';
                }

                if (double.tryParse(value) == null) {
                  return 'Price harus berupa angka';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: quantityController,
              label: 'Quantity',
              icon: Icons.inventory,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Quantity wajib diisi';
                }

                final quantity = int.tryParse(value);

                if (quantity == null) {
                  return 'Quantity harus berupa angka';
                }

                if (quantity < 0) {
                  return 'Quantity tidak boleh negatif';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: imageUrlController,
              label: 'Image URL',
              icon: Icons.image,
              hint: 'https://example.com/image.jpg',
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: categoryController,
              label: 'Category',
              icon: Icons.category,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: descriptionController,
              label: 'Deskripsi Produk',
              icon: Icons.description,
              maxLines: 5,
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan Produk',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label wajib diisi';
            }

            return null;
          },
    );
  }
}
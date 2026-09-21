import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/search_products.dart';
import 'add_product_page.dart';
import 'product_detail_page.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  static final repository = ProductRepositoryImpl();

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late final GetProducts getProducts;
  late final DeleteProduct deleteProduct;
  late final SearchProducts searchProducts;

  List<Product> products = [];

  @override
  void initState() {
    super.initState();

    getProducts = GetProducts(
      ProductListPage.repository,
    );

    deleteProduct = DeleteProduct(
      ProductListPage.repository,
    );

    searchProducts = SearchProducts(
      ProductListPage.repository,
    );

    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      products = getProducts();
    });
  }

  void _search(String keyword) {
    setState(() {
      products = searchProducts(keyword);
    });
  }

  void _deleteProduct(String id) {
    deleteProduct(id);

    _loadProducts();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produk berhasil dihapus'),
      ),
    );
  }

  Future<void> _openAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductPage(
          repository: ProductListPage.repository,
        ),
      ),
    );

    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: _openAddProduct,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    _search('');
                  },
                  icon: const Icon(Icons.clear),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: products.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada produk',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return ProductCard(
                        product: product,

                        onViewMore: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                product: product,
                              ),
                            ),
                          );
                        },

                        onDelete: () {
                          _showDeleteConfirmation(product);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Produk?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus "${product.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteProduct(product.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
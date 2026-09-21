import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [];

  @override
  List<Product> getProducts() {
    return List.unmodifiable(_products);
  }

  @override
  void addProduct(Product product) {
    _products.add(product);
  }

  @override
  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
  }

  @override
  List<Product> searchProducts(String keyword) {
    if (keyword.trim().isEmpty) {
      return getProducts();
    }

    final searchKeyword = keyword.toLowerCase();

    return _products.where((product) {
      return product.name.toLowerCase().contains(searchKeyword) ||
          product.category.toLowerCase().contains(searchKeyword) ||
          product.description.toLowerCase().contains(searchKeyword);
    }).toList();
  }
}
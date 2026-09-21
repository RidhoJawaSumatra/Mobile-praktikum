import '../entities/product.dart';

abstract class ProductRepository {
  List<Product> getProducts();

  void addProduct(Product product);

  void deleteProduct(String id);

  List<Product> searchProducts(String keyword);
}

// Ini adalah kontrak repository.

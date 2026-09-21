import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProducts {
  final ProductRepository repository;

  SearchProducts(this.repository);

  List<Product> call(String keyword) {
    return repository.searchProducts(keyword);
  }
}
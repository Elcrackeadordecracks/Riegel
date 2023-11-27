// lib/product_model.dart
class ProductModel {
  final String title;
  final String category;
  final String imageUrl;
  final double price;
  final int ranking;

  ProductModel({
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.ranking,
  });
}

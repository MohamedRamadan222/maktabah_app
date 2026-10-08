import 'package:maktabah_app/shared/books/domain/entities/category.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final int bookCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.bookCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      bookCount: json['bookCount'] as int,
    );
  }

  Category toEntity() {
    return Category(id: id, name: name, icon: icon, bookCount: bookCount);
  }
}

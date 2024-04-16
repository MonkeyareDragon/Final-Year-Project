// meal.model.Category
import 'package:loginsignup/controller/helper/url_helper.dart';

class Category {
  int id;
  String categoryImage;
  String name;
  String description;

  Category(
      {required this.id,
      required this.categoryImage,
      required this.name,
      required this.description}) {
    this.categoryImage = UrlUtil.getImageUrl(categoryImage);
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryImage: json['category_image'],
      name: json['name'],
      description: json['description'],
    );
  }
}

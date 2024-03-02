// meal.model.Nutrition
import 'package:loginsignup/common/url_helper.dart';

class Nutrition {
  int id;
  String nutritionImage;
  String name;
  double quantity;
  String property;

  Nutrition(
      {required this.id,
      required this.nutritionImage,
      required this.name,
      required this.quantity,
      required this.property}){
        this.nutritionImage = UrlUtil.getImageUrl(nutritionImage);
      }

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      id: json['id'],
      nutritionImage: json['nutrition_image'],
      name: json['name'],
      quantity: json['quantity'],
      property: json['property'],
    );
  }
}

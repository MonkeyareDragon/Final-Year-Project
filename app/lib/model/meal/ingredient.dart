// meal.model.Ingredient
import 'package:loginsignup/controller/helper/url_helper.dart';

class Ingredient {
  int id;
  String ingredientImage;
  String name;
  String quantityRequired;

  Ingredient(
      {required this.id,
      required this.ingredientImage,
      required this.name,
      required this.quantityRequired}){
        this.ingredientImage = UrlUtil.getImageUrl(ingredientImage);
      }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      ingredientImage: json['ingredient_image'],
      name: json['name'],
      quantityRequired: json['quantity_required'],
    );
  }
}

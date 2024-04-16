import 'package:loginsignup/controller/helper/url_helper.dart';

class SimilarMeal {
  String name;
  String cookingDifficulty;
  int timeRequired;
  int calories;
  String foodImage;

  SimilarMeal({
    required this.name,
    required this.cookingDifficulty,
    required this.timeRequired,
    required this.calories,
    required this.foodImage,
  }) {
    this.foodImage = UrlUtil.getImageUrl(foodImage);
  }

  factory SimilarMeal.fromJson(Map<String, dynamic> json) {
    return SimilarMeal(
      name: json['name'],
      cookingDifficulty: json['cooking_difficulty'],
      timeRequired: json['time_required'],
      calories: json['calories'],
      foodImage: json['food_image'],
    );
  }
}

// meal.model.Food
import 'package:loginsignup/common/url_helper.dart';

class Food {
  int id;
  String foodImage;
  String name;
  String cookingDifficulty;
  int timeRequired;
  int calories;
  String author;
  String description;

  Food(
      {required this.id,
      required this.foodImage,
      required this.name,
      required this.cookingDifficulty,
      required this.timeRequired,
      required this.calories,
      required this.author,
      required this.description}) {
    this.foodImage = UrlUtil.getImageUrl(foodImage);
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      foodImage: json['food_image'],
      name: json['name'],
      cookingDifficulty: json['cooking_difficulty'],
      timeRequired: json['time_required'],
      calories: json['calories'],
      author: json['author'],
      description: json['description'],
    );
  }
}

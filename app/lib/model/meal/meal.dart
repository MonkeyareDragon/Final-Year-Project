// meal.model.meal
class Meal {
  int id;
  String mealImage;
  String name;
  int foodCount;

  Meal(
      {required this.id,
      required this.mealImage,
      required this.name,
      required this.foodCount});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      mealImage: json['meal_image'],
      name: json['name'],
      foodCount: json['food_count'],
    );
  }
}

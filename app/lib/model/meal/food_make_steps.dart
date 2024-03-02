// meal.model.FoodMakingSteps
class FoodMakingSteps {
  int id;
  String description;
  int stepNumber;

  FoodMakingSteps(
      {required this.id,
      required this.description,
      required this.stepNumber,});

  factory FoodMakingSteps.fromJson(Map<String, dynamic> json) {
    return FoodMakingSteps(
      id: json['id'],
      description: json['description'],
      stepNumber: json['step_no'],
    );
  }
}

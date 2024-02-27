class Exercise {
  final String name;
  final String description;
  final String difficulty;
  final int caloriesBurn;
  final int customRepeats;
  final String timeRequired;

  Exercise({
    required this.name,
    required this.description,
    required this.difficulty,
    required this.caloriesBurn,
    required this.customRepeats,
    required this.timeRequired,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
      difficulty: json['difficulty'],
      caloriesBurn: json['calories_burn'],
      customRepeats: json['custom_repeats'],
      timeRequired: json['time_required'],
    );
  }
}

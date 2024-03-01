import 'package:loginsignup/common/url_helper.dart';

class Exercise {
  int id;
  String exercieImage;
  String name;
  String description;
  String difficulty;
  int caloriesBurn;
  int customRepeats;
  String timeRequired;

  Exercise({
    required this.id,
    required this.exercieImage,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.caloriesBurn,
    required this.customRepeats,
    required this.timeRequired,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      exercieImage: json['exercise_image'],
      name: json['name'],
      description: json['description'],
      difficulty: json['difficulty'],
      caloriesBurn: json['calories_burn'],
      customRepeats: json['custom_repeats'],
      timeRequired: json['time_required'],
    );
  }
}

class ExerciseSet {
  int setCount;
  List<Set> exerciseSetSet;

  ExerciseSet({
    required this.setCount,
    required this.exerciseSetSet,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
  return ExerciseSet(
    setCount: json['set_count'],
    exerciseSetSet: (json['set'] as List)
        .map((exercise) => Set.fromJson(exercise))
        .toList(),
  );
}

}

class Set {
  String exerciseImage;
  String exerciseName;
  String exerciseTimeRequired;

  Set({
    required this.exerciseImage,
    required this.exerciseName,
    required this.exerciseTimeRequired,
  }){
    this.exerciseImage = UrlUtil.getImageUrl(exerciseImage);
  
  }

  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      exerciseImage: json['exercise_image'],
      exerciseName: json['exercise_name'],
      exerciseTimeRequired: json['exercise_time_required'],
    );
  }
}

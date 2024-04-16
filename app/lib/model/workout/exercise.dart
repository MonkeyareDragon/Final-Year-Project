import 'package:loginsignup/controller/helper/url_helper.dart';

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
  int exerciseId;
  String exerciseImage;
  String exerciseName;
  String exerciseTimeRequired;
  String exerciseDifficulty;
  int exerciseCaloriesBurn;
  String exerciseDescription;
  int exerciseCustomRepeats;

  Set({
    required this.exerciseId,
    required this.exerciseImage,
    required this.exerciseName,
    required this.exerciseTimeRequired,
    required this.exerciseDifficulty,
    required this.exerciseCaloriesBurn,
    required this.exerciseDescription,
    required this.exerciseCustomRepeats,
  }) {
    this.exerciseImage = UrlUtil.getImageUrl(exerciseImage);
  }

  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      exerciseId: json['exercise_id'],
      exerciseImage: json['exercise_image'],
      exerciseName: json['exercise_name'],
      exerciseTimeRequired: json['exercise_time_required'],
      exerciseDifficulty: json['exercise_difficulty'],
      exerciseCaloriesBurn: json['exercise_calories_burn'],
      exerciseDescription: json['exercise_description'],
      exerciseCustomRepeats: json['exercise_custom_repeats'],
    );
  }
}

class ExerciseDescription {
  String header;
  String description;
  int stepNo;

  ExerciseDescription({
    required this.header,
    required this.description,
    required this.stepNo,
  });

  factory ExerciseDescription.fromJson(Map<String, dynamic> json) {
    return ExerciseDescription(
      header: json['header'],
      description: json['description'],
      stepNo: json['step_no'],
    );
  }
}
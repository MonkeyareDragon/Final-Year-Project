// model_workout.dart
import 'package:loginsignup/model/equipment.dart';
import 'package:loginsignup/model/exercise.dart';

class Workout {
  final int id;
  final String name;
  final Duration timeRequired;
  final int caloriesBurn;
  final String difficulty;
  final List<Exercise> exercises;
  final List<Equipment> equipments;

  Workout({
    required this.id,
    required this.name,
    required this.timeRequired,
    required this.caloriesBurn,
    required this.difficulty,
    required this.exercises,
    required this.equipments,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    // Exercise list
    List<Exercise> exercises = (json['exercises'] as List)
        .map((exerciseJson) => Exercise.fromJson(exerciseJson))
        .toList();

    // Equipment list
    List<Equipment> equipments = (json['equipments'] as List)
        .map((equipmentJson) => Equipment.fromJson(equipmentJson))
        .toList();

    return Workout(
      id: json['id'],
      name: json['name'],
      timeRequired: Duration(seconds: json['time_required']),
      caloriesBurn: json['calories_burn'],
      difficulty: json['difficulty'],
      exercises: exercises,
      equipments: equipments,
    );
  }
}

// model_workout.dart
import 'package:loginsignup/model/equipment.dart';
import 'package:loginsignup/model/exercise.dart';

class Workout {
  final int id;
  final String name;
  final Duration timeRequired;
  final int caloriesBurn;
  final int exerciseCount;
  final String difficulty;
  final List<Exercise> exercises;
  final List<Equipment> equipments;

  Workout({
    required this.id,
    required this.name,
    required this.timeRequired,
    required this.caloriesBurn,
    required this.exerciseCount,
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

    // Check if the time_required value is in the correct format
    final timeRequiredString = json['time_required'];
    final durationRegExp = RegExp(r'^\d{2}:\d{2}:\d{2}$');
    if (!durationRegExp.hasMatch(timeRequiredString)) {
      throw FormatException(
          'Invalid time_required format: $timeRequiredString');
    }

    // Parse the time_required into Duration
    final timeComponents = timeRequiredString.split(':');
    final hours = int.parse(timeComponents[0]);
    final minutes = int.parse(timeComponents[1]);
    final seconds = int.parse(timeComponents[2]);

    return Workout(
      id: json['id'],
      name: json['name'],
      timeRequired: Duration(hours: hours, minutes: minutes, seconds: seconds),
      caloriesBurn: json['calories_burn'],
      exerciseCount: json['exercise_count'],
      difficulty: json['difficulty'],
      exercises: exercises,
      equipments: equipments,
    );
  }
}

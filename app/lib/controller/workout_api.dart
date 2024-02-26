import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loginsignup/model/equipment.dart';
import 'package:loginsignup/model/exercise.dart';
import 'package:loginsignup/model/workout.dart';
import 'package:loginsignup/model/workout_exercise.dart';

const String baseUrl = 'http://10.0.2.2:8000/api/v1';
String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzExNTI2MDQzLCJqdGkiOiIxYTBmNDdmYzQzNjY0NjYwYmIxNWJmMWI1YjljYmI0YSIsInVzZXJfaWQiOjJ9.Bn7VD-KbEJKJUluxoaS1DoGzMMhlJIiR7-twjhXr1Y0';



// API call to fetch all the data of equipments
Future<List<Equipment>> fetchEquipments() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/users/equipment/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Equipment.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load equipments');
    }
  } catch (e) {
    print('Error fetching equipments: $e');
    throw Exception('Failed to fetch equipments: $e');
  }
}

// API call to fetch details of a specific equipment by ID
Future<Equipment> fetchEquipmentById(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/users/equipment/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Equipment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load equipments');
    }
  } catch (e) {
    print('Error fetching equipments: $e');
    throw Exception('Failed to fetch equipments: $e');
  }
}






// API call to fetch all the data of exercises
Future<List<Exercise>> fetchExercises() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/users/exercises/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Exercise.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  } catch (e) {
    print('Error fetching workout: $e');
    throw Exception('Failed to fetch exercises: $e');
  }
}

// API call to fetch details of a specific exercises by ID
Future<Exercise> fetchExercisesById(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/users/exercises/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load exercises');
    }
  } catch (e) {
    print('Error fetching exercises: $e');
    throw Exception('Failed to fetch exercises: $e');
  }
}






// API call to fetch all the data of workout
Future<List<Workout>> fetchWorkout() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/users/workout/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Workout.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load workout');
    }
  } catch (e) {
    print('Error fetching workout: $e');
    throw Exception('Failed to fetch workout: $e');
  }
}

// API call to fetch details of a specific workout by ID
Future<Workout> fetchWorkoutById(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/users/workout/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Workout.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load workout');
    }
  } catch (e) {
    print('Error fetching workout: $e');
    throw Exception('Failed to fetch workout: $e');
  }
}






// API call to fetch all the data of workout-exercises
Future<List<WorkoutExercise>> fetchWorkoutExercises() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/users/workout-exercise/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => WorkoutExercise.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load workout-exercises');
    }
  } catch (e) {
    print('Error fetching workout-exercises: $e');
    throw Exception('Failed to fetch workout-exercises: $e');
  }
}

// API call to fetch details of a specific workout-exercises by ID
Future<WorkoutExercise> fetchWorkoutExercisesById(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/users/workout-exercise/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return WorkoutExercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load workout-exercises');
    }
  } catch (e) {
    print('Error fetching workout-exercises: $e');
    throw Exception('Failed to fetch workout-exercises: $e');
  }
}
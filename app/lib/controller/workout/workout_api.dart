import 'package:http/http.dart' as http;
import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'package:loginsignup/model/session/user_session.dart';
import 'dart:convert';
import 'package:loginsignup/model/workout/equipment.dart';
import 'package:loginsignup/model/workout/exercise.dart';
import 'package:loginsignup/model/workout/workout.dart';
import 'package:loginsignup/model/workout/workout_exercise.dart';

// API call to fetch all the data of equipments
Future<List<Equipment>> fetchEquipments() async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/equipment/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
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
Future<List<Equipment>> fetchEquipmentById(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/equipment/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      // Assuming the response is a list of equipment objects
      List<Equipment> equipments =
          responseData.map((data) => Equipment.fromJson(data)).toList();

      return equipments;
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
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/exercises/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      // Assuming the response is a list of equipment objects
      List<Exercise> exercise =
          responseData.map((data) => Exercise.fromJson(data)).toList();

      return exercise;
    } else {
      throw Exception('Failed to load exercise');
    }
  } catch (e) {
    print('Error fetching exercise: $e');
    throw Exception('Failed to fetch exercise: $e');
  }
}

// API call to fetch details of a specific exercises by ID
Future<List<Exercise>> fetchExercisesById(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/workout/$id/exercises-details/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Exercise> exercise =
          responseData.map((data) => Exercise.fromJson(data)).toList();

      return exercise;
    } else {
      throw Exception('Failed to load exercise');
    }
  } catch (e) {
    print('Error fetching exercise: $e');
    throw Exception('Failed to fetch exercise: $e');
  }
}

// API call to fetch all the data of workout
Future<List<Workout>> fetchWorkout() async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/workout/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
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
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/workout/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
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
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/workout-exercise/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
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

// API call to fetch details of a specific ExerciseSet by ID
Future<List<ExerciseSet>> fetchWorkoutExercisesSetById(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/workout-exercise/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<ExerciseSet> exerciseSets = [];

      for (var data in responseData) {
        if (data['set'] != null && data['set'] is List) {
          exerciseSets.add(ExerciseSet.fromJson(data));
        }
      }
    
      return exerciseSets;
    } else {
      throw Exception('Failed to load workout-exercises');
    }
  } catch (e) {
    print('Error fetching workout-exercises: $e');
    throw Exception('Failed to fetch workout-exercises: $e');
  }
}


// API call to fetch details of a specific Exercise Description (How to do it) by ID
Future<List<ExerciseDescription>> fetchExerciseDescriptionById(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/exercise-description/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<ExerciseDescription> exercisedescription =
          responseData.map((data) => ExerciseDescription.fromJson(data)).toList();

      return exercisedescription;
    } else {
      throw Exception('Failed to load Exercise Description');
    }
  } catch (e) {
    print('Error fetching Exercise Description: $e');
    throw Exception('Failed to fetch Exercise Description: $e');
  }
}

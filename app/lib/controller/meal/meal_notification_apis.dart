import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loginsignup/model/meal/meal_notification.dart';

const String baseUrl = 'http://10.0.2.2:8000/api/v1';
String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzExNTI2MDQzLCJqdGkiOiIxYTBmNDdmYzQzNjY0NjYwYmIxNWJmMWI1YjljYmI0YSIsInVzZXJfaWQiOjJ9.Bn7VD-KbEJKJUluxoaS1DoGzMMhlJIiR7-twjhXr1Y0';

Future<void> createFoodSchedule(Map<String, dynamic> requestData) async {
  final String apiUrl = '$baseUrl/meal/users/food-schedule/create/';
  print(requestData);
  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 201) {
      print('FoodSchedule created successfully');
    } else {
      print(
          'Failed to create FoodSchedule. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error creating FoodSchedule: $e');
  }
}

// API call to fetch all the data of meal notification based on user id
Future<List<MealNotification>> fetchMealNotificationsOnUserID(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/meal/users/notifications/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => MealNotification.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meal notification');
    }
  } catch (e) {
    print('Error fetching meal notification: $e');
    throw Exception('Failed to fetch meal notification: $e');
  }
}

// API call to fetch all the data of meal schedule details based on user id
Future<List<MealSchedule>> fetchMealSchedulerDetailsOnUserID(
    int id, String requiredDate) async {
  try {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/meal/users/meals-schedule/user/$id/date/$requiredDate/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<MealSchedule> mealSchedule = [];
      for (var data in responseData) {
        if (data['details'] != null && data['details'] is List) {
          mealSchedule.add(MealSchedule.fromJson(data));
        }
      }

      return mealSchedule;
    } else {
      throw Exception('Failed to load meal schedule details');
    }
  } catch (e) {
    print('Error fetching meal schedule details: $e');
    throw Exception('Failed to fetch meal schedule details: $e');
  }
}

// API call to fetch all the data of meal schedule nurition details based on user id
Future<DailyMealScheduleNutritions> fetchDailyMealSchedulerNutritionOnUserID(
    int id, String requiredDate) async {
  try {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/meal/users/schedule-nutrition/user/$id/date/$requiredDate/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return DailyMealScheduleNutritions.fromJson(
          data); // Return a single ActivityGoal object
    } else {
      throw Exception('Failed to load meal schedule nurition details');
    }
  } catch (e) {
    print('Error fetching meal schedule nurition details: $e');
    throw Exception('Failed to fetch meal schedule nurition details: $e');
  }
}

// API call to patch all the status of the meal schedule
Future<void> patchMealSchedulerStatus(int scheduleid) async {
  try {
    final response = await http.patch(
      Uri.parse(
          '$baseUrl/meal/users/food-schedule/$scheduleid/complete/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Meal schedule status updated successfully');
    } if (response.statusCode == 403) {
      print('Forbidden to update meal schedule status');
    }
    else {
      print('Failed to update meal schedule status. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error updating meal schedule status: $e');
    throw Exception('Failed to update meal schedule status: $e');
  }
}


// API call to delete the given id of the meal schedule
Future<void> deleteMealScheduler(int scheduleid) async {
  try {
    final response = await http.delete(
      Uri.parse(
          '$baseUrl/meal/users/food-schedule/$scheduleid/delete/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      print('Meal schedule have successfully deleted');
    } else if (response.statusCode == 403) {
      print('Forbidden to delete this meal schedule');
    }
    else {
      print('Failed to delete meal schedule. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error deleting meal schedule status: $e');
    throw Exception('Failed to deleting meal schedule status: $e');
  }
}

// API call to fetch all the data of meal details which are schedule today
Future<List<TodayMeal>> fetchTodayScheduleMeals(
    int id, String requiredDate, String requestTime) async {
  try {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/meal/users/meals/up-comming-bar/$id/$requiredDate/$requestTime/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<TodayMeal> todayScheduleMeal = [];
      for (var data in responseData) {
        if (data['details'] != null && data['details'] is List) {
          todayScheduleMeal.add(TodayMeal.fromJson(data));
        }
      }

      return todayScheduleMeal;
    } else {
      throw Exception('Failed to load meal details which are schedule today');
    }
  } catch (e) {
    print('Error fetching meal details which are schedule today: $e');
    throw Exception('Failed to fetch meal details which are schedule today: $e');
  }
}
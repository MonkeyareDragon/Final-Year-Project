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

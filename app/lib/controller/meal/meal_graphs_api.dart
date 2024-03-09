import 'package:http/http.dart' as http;
import 'package:loginsignup/model/meal/meal_line_graph.dart';
import 'dart:convert';

const String baseUrl = 'http://10.0.2.2:8000/api/v1';
String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzExNTI2MDQzLCJqdGkiOiIxYTBmNDdmYzQzNjY0NjYwYmIxNWJmMWI1YjljYmI0YSIsInVzZXJfaWQiOjJ9.Bn7VD-KbEJKJUluxoaS1DoGzMMhlJIiR7-twjhXr1Y0';

// API call to fetch all the data of weekly progress of meal plan
Future<List<WeeklyMealProgress>> fetchWeeklyProgressMealPlan(int userid) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/meal/users/weekly-progress/$userid/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => WeeklyMealProgress.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load weekly progress of meal plan');
    }
  } catch (e) {
    print('Error fetching weekly progress of meal plan: $e');
    throw Exception('Failed to fetch weekly progress of meal plan: $e');
  }
}

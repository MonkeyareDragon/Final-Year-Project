import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loginsignup/model/workout/workout_schedule.dart';

const String baseUrl = 'http://10.0.2.2:8000/api/v1';
String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzExNTI2MDQzLCJqdGkiOiIxYTBmNDdmYzQzNjY0NjYwYmIxNWJmMWI1YjljYmI0YSIsInVzZXJfaWQiOjJ9.Bn7VD-KbEJKJUluxoaS1DoGzMMhlJIiR7-twjhXr1Y0';

Future<void> createWorkoutSchedule(Map<String, dynamic> requestData) async {
  final String apiUrl = '$baseUrl/workout/users/workout-schedule/create/';
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

// API call to fetch all the data of workout schedule on meal id
Future<List<WorkSchedule>> fetchWorkoutSchedulebyUser(int id, String requestData) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/users/workout-schedule/user/$id/date/$requestData/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => WorkSchedule.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load workout schedule ');
    }
  } catch (e) {
    print('Error fetching workout schedule : $e');
    throw Exception('Failed to fetch workout schedule : $e');
  }
}
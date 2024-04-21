import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'package:loginsignup/model/session/user_session.dart';
import 'package:loginsignup/model/workout/workout_schedule.dart';

Future<void> createWorkoutSchedule(Map<String, dynamic> requestData) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final http.Response response = await http.post(
      ApiUrlHelper.buildUrl('workout/users/workout-schedule/create/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
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
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('workout/users/workout-schedule/user/$id/date/$requestData/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
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
import 'package:loginsignup/model/activity/activity_goal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


const String baseUrl = 'http://10.0.2.2:8000/api/v1';
// const String baseUrl = 'http://192.168.1.79:8000/api/v1';
String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE0MDMwNDQwLCJqdGkiOiI4MWQzYWExYzkzMmM0NWIyOTVjYWYxOGRkNWNiNjcyNiIsInVzZXJfaWQiOjR9.xOiputdX31IUXoSz8qQTgx885dwF3n5-5NglSkIDq7M';


// API call to fetch all the data of user activity goal
Future<ActivityGoal> fetchUserActiviytGoal(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/activity/users/activity-goals/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return ActivityGoal.fromJson(data); // Return a single ActivityGoal object
    } else {
      throw Exception('Failed to load user activity goal');
    }
  } catch (e) {
    print('Error fetching user activity goal: $e');
    throw Exception('Failed to fetch user activity goal: $e');
  }
}

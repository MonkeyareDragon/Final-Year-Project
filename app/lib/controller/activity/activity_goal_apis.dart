import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'package:loginsignup/model/activity/activity_goal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loginsignup/model/session/user_session.dart';

// API call to fetch all the data of user activity goal
Future<ActivityGoal> fetchUserActiviytGoal(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('activity/users/activity-goals/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return ActivityGoal.fromJson(data);
    } else {
      throw Exception('Failed to load user activity goal');
    }
  } catch (e) {
    print('Error fetching user activity goal: $e');
    throw Exception('Failed to fetch user activity goal: $e');
  }
}

//Update the user activity goal
Future<bool> updateUserActivityGoal(int id, Map<String, dynamic> body) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.patch(
      ApiUrlHelper.buildUrl('activity/users/activity-goals/${id}/update-target/'),
      headers: <String, String>{
        'Authorization': 'Bearer ${session.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error updating user activity goal: $e');
    throw Exception('Failed to updating user activity goal: $e');
  }
}
import 'package:http/http.dart' as http;
import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'package:loginsignup/model/meal/meal_line_graph.dart';
import 'dart:convert';
import 'package:loginsignup/model/session/user_session.dart';


// API call to fetch all the data of weekly progress of meal plan
Future<List<WeeklyMealProgress>> fetchWeeklyProgressMealPlan(int userid) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/weekly-progress/$userid/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
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

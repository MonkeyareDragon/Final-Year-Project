import 'package:http/http.dart' as http;
import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'dart:convert';
import 'package:loginsignup/model/session/user_session.dart';

Future<Map<String, dynamic>> calculateBMI() async {
  final UserSession session = await getSessionOrThrow();

  final response = await http.get(
    ApiUrlHelper.buildUrl('activity/users/calculate-bmi/'),
    headers: {
      'Authorization': 'Bearer ${session.accessToken}',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    double bmi = data['bmi'];
    String condition = data['condition'];
    return {'bmi': bmi, 'condition': condition};
  } else {
    throw Exception('Failed to load BMI');
  }
}

Future<Map<String, dynamic>> fetchHomeCalorieData() async {
  final UserSession session = await getSessionOrThrow();

  final response = await http.get(
    ApiUrlHelper.buildUrl('activity/users/calorie-data/'),
    headers: {
      'Authorization': 'Bearer ${session.accessToken}',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else if (response.statusCode == 404) {
    throw Exception('No data found for the current date');
  } else {
    throw Exception('Failed to load calorie data');
  }
}

Future<Map<int, int>> fetchHomeStepCountData() async {
  final UserSession session = await getSessionOrThrow();

  final response = await http.get(
    ApiUrlHelper.buildUrl('activity/users/step-data/'),
    headers: {
      'Authorization': 'Bearer ${session.accessToken}',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = json.decode(response.body);
    Map<int, int> stepCountData = {};

    for (var entry in responseData.entries) {
      stepCountData[int.parse(entry.key)] = entry.value;
    }

    return stepCountData;
  } else {
    throw Exception('Failed to load step count data');
  }
}
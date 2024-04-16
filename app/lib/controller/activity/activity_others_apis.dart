import 'package:http/http.dart' as http;
import 'package:loginsignup/common/sesson_helper.dart';
import 'dart:convert';

import 'package:loginsignup/model/session/user_session.dart';

const String baseUrl = 'http://10.0.2.2:8000/api/v1';
// const String baseUrl = 'http://192.168.1.79:8000/api/v1';

Future<Map<String, dynamic>> calculateBMI() async {
  final UserSession session = await getSessionOrThrow();

  final response = await http.get(
    Uri.parse('$baseUrl/activity/users/calculate-bmi/'),
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

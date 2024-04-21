import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:loginsignup/common/sesson_helper.dart';
import 'dart:convert';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'package:loginsignup/model/session/user_session.dart';

Future<String?> sendSensorDataToAPI(List<List<double>> sensorData) async {
  final UserSession session = await getSessionOrThrow();
  final jsonData = jsonEncode({
    "user": session.userId,
    "data": sensorData,
  });
  log('Headers: {\'Authorization\': \'Bearer ${session.accessToken}\', \'Content-Type\': \'application/json\'}');
  log('Body: $jsonData');
  try {
    final http.Response response = await http.post(
      ApiUrlHelper.buildUrl('activity/users/predict/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
      },
      body: jsonData,
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(
          "Data sent successfully. Predicted class: ${responseBody['predicted_activity']}");
      return responseBody['predicted_activity'];
    } else {
      print('Failed to send sensor data. Status Code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error sending sensor data: $e');
    return null;
  }
}
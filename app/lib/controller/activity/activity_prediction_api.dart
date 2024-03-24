import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://10.0.2.2:8000/api/v1';
// const String baseUrl = 'http://192.168.1.79:8000/api/v1';

Future<String?> sendSensorDataToAPI(List<List<double>> sensorData) async {
  final String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzEzNzIwNjc0LCJqdGkiOiIzZWVkMWRkZTcwYmI0OGU1YTUzOWRkMDFiYmFiN2MyYiIsInVzZXJfaWQiOjR9.uulxgW1hiaVGoZGJeLLaPorSAEsneO8I6a-DoUukHQo';
  final jsonData = jsonEncode({
    "user": 4,
    "data": sensorData,
  });
  log('Sending request to: $baseUrl/activity/users/predict/');
  log('Headers: {\'Authorization\': \'Bearer $token\', \'Content-Type\': \'application/json\'}');
  log('Body: $jsonData');
  final String apiUrl = '$baseUrl/activity/users/predict/';
  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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
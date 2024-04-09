import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:8000';

Future<Map<String, dynamic>> setUserProfile({
  required int userId,
  required String gender,
  required String dob,
  required String weight,
  required String height,
  required String goal,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/v1/users/profile/'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'user': userId,
      'gender': gender,
      'dob': dob,
      'weight': weight,
      'height': height,
      'goal': goal,
    }),
  );

  if (response.statusCode == 201) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    return {'success': true, 'message': 'Profile set successfully'};
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    return {'success': false, 'error': 'Failed to set profile'};
  }
}

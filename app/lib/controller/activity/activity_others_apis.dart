import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://10.0.2.2:8000/api/v1';
// const String baseUrl = 'http://192.168.1.79:8000/api/v1';
String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE0NDQ2Njg3LCJqdGkiOiJiMTRiMTM3MGQwM2I0ODM4YWNhZTFhMTJmODhiZDllMiIsInVzZXJfaWQiOjJ9.59dRIQYHj348UYHmF6DDef5s94mOysGjs1Kl669b-aI';


Future<Map<String, dynamic>> calculateBMI() async {
    final response = await http.get(
      Uri.parse('$baseUrl/activity/users/calculate-bmi/'),
      headers: {
        'Authorization': 'Bearer $token',
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
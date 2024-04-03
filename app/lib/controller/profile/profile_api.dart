import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loginsignup/model/profile/profile.dart';

const String baseUrl = 'http://10.0.2.2:8000/api/v1';
String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE0NDQ2Njg3LCJqdGkiOiJiMTRiMTM3MGQwM2I0ODM4YWNhZTFhMTJmODhiZDllMiIsInVzZXJfaWQiOjJ9.59dRIQYHj348UYHmF6DDef5s94mOysGjs1Kl669b-aI';

// API call to fetch all the data of similar meals base on meal id
Future<UserProfile> fetchUserProfileDetails(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/users/get-profile/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Similar Meals');
    }
  } catch (e) {
    print('Error fetching Similar Meals: $e');
    throw Exception('Failed to fetch Similar Meals: $e');
  }
}
import 'package:http/http.dart' as http;
import 'package:loginsignup/model/meal/meal_rec.dart';
import 'dart:convert';

const String baseUrl = 'http://10.0.2.2:8000/api/v1';
String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE0NDQ2Njg3LCJqdGkiOiJiMTRiMTM3MGQwM2I0ODM4YWNhZTFhMTJmODhiZDllMiIsInVzZXJfaWQiOjJ9.59dRIQYHj348UYHmF6DDef5s94mOysGjs1Kl669b-aI';

// API call to fetch all the data of similar meals base on meal id
Future<List<SimilarMeal>> fetchSimilarMealsBaseOnFood(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/meal/users/recommend/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => SimilarMeal.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Similar Meals');
    }
  } catch (e) {
    print('Error fetching Similar Meals: $e');
    throw Exception('Failed to fetch Similar Meals: $e');
  }
}

// API call to fetch all the data of similar meal based on user data
Future<List<SimilarMeal>> fetchDietMealsBaseOnUserActivity(int id, String date) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/meal/users/recommend-based-activity/$id/$date/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => SimilarMeal.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Meals base on your Diet');
    }
  } catch (e) {
    print('Error fetching Meals base on your Diet: $e');
    throw Exception('Failed to fetch Meals base on your Diet: $e');
  }
}
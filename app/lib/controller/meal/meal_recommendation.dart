import 'package:http/http.dart' as http;
import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'package:loginsignup/model/meal/meal_rec.dart';
import 'dart:convert';
import 'package:loginsignup/model/session/user_session.dart';

// API call to fetch all the data of similar meals base on meal id
Future<List<SimilarMeal>> fetchSimilarMealsBaseOnFood(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/recommend/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
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
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/recommend-based-activity/$id/$date/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
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
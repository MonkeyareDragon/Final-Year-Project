import 'package:http/http.dart' as http;
import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'dart:convert';
import 'package:loginsignup/model/profile/profile.dart';
import 'package:loginsignup/model/session/user_session.dart';

// API call to fetch all the data of similar meals base on meal id
Future<UserProfile> fetchUserProfileDetails(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('users/get-profile/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
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

//Update the user profile
Future<bool> updateUserProfile(Map<String, dynamic> body) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.patch(
      ApiUrlHelper.buildUrl('users/profile/update/${session.userId}/'),
      headers: <String, String>{
        'Authorization': 'Bearer ${session.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error updating user profile: $e');
    throw Exception('Failed to updating user profile: $e');
  }
}
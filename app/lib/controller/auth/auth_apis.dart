import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loginsignup/controller/helper/session_manager.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'package:loginsignup/model/session/user_session.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      ApiUrlHelper.buildUrl('users/token/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Successful login
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData); // Print the response data
      int userId = responseData['user_id'];
      String accessToken = responseData['access'];
      String firstName = responseData['first_name'];
      String lastName = responseData['last_name'];
      
       await SessionManager.saveSession(UserSession(
        userId: userId,
        accessToken: accessToken,
        firstName: firstName,
        lastName: lastName,
      ));

      return {'success': true, 'token': responseData['access']};
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return {'success': false, 'error': 'Invalid credentials'};
    }
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String firstName, String lastName) async {
    final response = await http.post(
      ApiUrlHelper.buildUrl('users/registration/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName
      }),
    );

    if (response.statusCode == 201) {
      // Successful register
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData); // Print the response data
      return {'success': true, "detail": "Verification email sent."};
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return {'success': false, 'error': '${response.body}'};
    }
  }

  Future<Map<String, dynamic>> verifyOTP(
      String email, String otp, String firstName, String lastName) async {
    final response = await http.post(
      ApiUrlHelper.buildUrl('users/verify-otp/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'otp_code': otp,
      }),
    );

    if (response.statusCode == 200) {
      // Successful login
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData); // Print the response data
      int userId = responseData['user_id'];
      String accessToken = responseData['access'];

      await SessionManager.saveSession(UserSession(
        userId: userId,
        accessToken: accessToken,
        firstName: firstName,
        lastName: lastName,
      ));
      return {
        'success': true,
        "detail": "Email verified.",
        'user_id': userId,
      };
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return {'success': false, 'error': '${response.body}'};
    }
  }

  Future<Map<String, dynamic>> resendOTP(String email) async {
    final response = await http.post(
      ApiUrlHelper.buildUrl('users/resend-otp/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );

    if (response.statusCode == 200) {
      // Successful login
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData); // Print the response data
      return {'success': true, "detail": "Send OTP code to email."};
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return {'success': false, 'error': 'Invalid credentials'};
    }
  }

  Future<Map<String, dynamic>> passwordReset(String email) async {
    final response = await http.post(
      ApiUrlHelper.buildUrl('users/password-reset/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );

    if (response.statusCode == 200) {
      // Successful login
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData); // Print the response data
      return {'success': true, "detail": "Send OTP code to email."};
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return {'success': false, 'error': '${response.body}'};
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/users/jwt/token/'),
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
      return {'success': true, 'token': responseData['access']};
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return {'success': false, 'error': 'Invalid credentials'};
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/users/registration/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Successful login
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData); // Print the response data
      return {'success': true, "detail":"Verification email sent."};
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return {'success': false, 'error': 'Invalid credentials'};
    }
  }

  //write the code for sending otp from email_otp.dart
  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/users/verify-otp-code/'),
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
      return {'success': true, "detail": "Email verified."};
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return {'success': false, 'error': 'Invalid credentials'};
    }
  }

  Future<Map<String, dynamic>> resendOTP(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/users/resend/verification-code/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email
      }),
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
}

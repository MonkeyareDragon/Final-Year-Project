import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loginsignup/controller/auth/auth_apis.dart';
import '../../common/color_extension.dart';
import '../../common_widget/base_widget/primary_button.dart';
import '../../common_widget/base_widget/textfield.dart';
import 'login_profile.dart';

class EmailOtpPage extends StatefulWidget {
  final String email;

  EmailOtpPage({required this.email});

  @override
  _EmailOtpPageState createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends State<EmailOtpPage> {
  late String email;
  final otpController = TextEditingController();
  final ApiService apiService = ApiService();
  int countdownTime = 180; // 3 minutes in seconds
  bool isResending = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    email = widget.email;
  }

  Future<void> _submitOTP() async {
    final String otp = otpController.text.trim();
    final Map<String, dynamic> result = await apiService.verifyOTP(email, otp);

    if (result['success']) {
      _showSuccessDialog('Success', 'Your Email is successfully verified!', result['user_id']);
    } else {
      String errorMessage = 'Invalid code! Please try again.';
      final errorBody = jsonDecode(result['error']);

      errorBody.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          errorMessage = value[0];
          return;
        }
      });

      _showErrorDialog('OTP Failed', errorMessage);
    }
  }

  void _navigateToProfile(int userId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginProfileView(userId: userId)),
  );
}

  void _showSuccessDialog(String title, String message, int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToProfile(userId);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void updateCountdownTime(int newTime) {
    if (mounted) {
      setState(() {
        countdownTime = newTime;
        if (newTime == 0) {
          isResending = false;
        }
      });
    }
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var threeMinutes = 3 * 60; // 3 minutes in seconds

    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (threeMinutes < 1) {
          timer.cancel();
        } else {
          setState(() {
            threeMinutes = threeMinutes - 1;
            updateCountdownTime(threeMinutes);
          });
        }
      },
    );
  }

  void _resendOtp() async {
    isResending = true;
    // Call the API to resend the OTP
    final Map<String, dynamic> result = await apiService.resendOTP(email);

    if (result['success']) {
      print('OTP resent successfully');
      // Start the countdown timer
      startCountdownTimer();
    } else {
      print('Failed to resend OTP. Error: ${result['error']}');
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: media.width * 0.27,
              ),
              Text(
                "Enter Code",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 15),
              Text(
                "We’ve sent a mail with an activation code\n to your email address.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 35),
              RoundTextField(
                hitText: "Activation Code",
                icon: "assets/img/signup/Message.png",
                keywordtype: TextInputType.numberWithOptions(),
                controller: otpController,
                rigtIcon: TextButton(
                  onPressed: isResending ? null : _resendOtp,
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (isResending)
                Text(
                  'Resend Cooldown: $countdownTime seconds',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 16,
                  ),
                ),
              SizedBox(height: 15),
              RoundButton(title: "Verify", onPressed: _submitOTP),
            ],
          ),
        ),
      ),
    );
  }
}

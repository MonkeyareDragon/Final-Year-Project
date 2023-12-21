import 'package:flutter/material.dart';
import 'package:loginsignup/constant/api.dart';

import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/textfield.dart';
import 'login_profile.dart';

class EmailOtpPage extends StatefulWidget {
  final String email;

  EmailOtpPage({super.key, required this.email});

  @override
  _EmailOtpPageState createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends State<EmailOtpPage> {
  late String email;
  final otpController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    email = widget.email;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    otpController.dispose();
    super.dispose();
  }

  Future<void> _submitOTP() async {
    final String otp = otpController.text.trim();

    final Map<String, dynamic> result =
        await apiService.sendOTP(email, otp);

    if (result['success']) {
      print('Login successful! Token: ${result['token']}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginProfileView()));
    } else {
      print('Login failed. Error: ${result['error']}');
    }
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
                    onPressed: () {},
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 16,
                      ),
                    ),
                  )),
              SizedBox(height: 35),
              RoundButton(title: "Login", onPressed: _submitOTP),
            ],
          ),
        ),
      ),
    );
  }
}

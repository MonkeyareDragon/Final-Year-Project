import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/base_widget/primary_button.dart';
import 'package:loginsignup/common_widget/base_widget/textfield.dart';
import 'package:loginsignup/controller/api.dart';
import 'package:loginsignup/view/login/link_send_confirm.dart';

class EmailConfirmScreen extends StatefulWidget {
  const EmailConfirmScreen({super.key});

  @override
  State<EmailConfirmScreen> createState() => _EmailConfirmScreen();
}

class _EmailConfirmScreen extends State<EmailConfirmScreen> {
  final emailController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    final String email = emailController.text.trim();

    final Map<String, dynamic> result = await apiService.passwordReset(email);

    if (result['success']) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LinkSendConfirmPage()));
    } else {
      // Create an alert dialog to display some errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(result['error']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      print('Register failed. Error: ${result['error']}');
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: media.width * 0.27,
              ),
              Text(
                "Getting back into\n your account",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 15),
              Text(
                "Tell us some information about\n your account.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 35),
              RoundTextField(
                hitText: "Email",
                icon: "assets/img/signup/Message.png",
                keywordtype: TextInputType.emailAddress,
                controller: emailController,
              ),
              SizedBox(height: 20),
              RoundButton(
                title: "Continue",
                onPressed: _verifyOTP,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

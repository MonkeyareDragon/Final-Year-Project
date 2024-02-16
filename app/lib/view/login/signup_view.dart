import 'package:flutter/material.dart';
import 'package:loginsignup/view/login/login_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/textfield.dart';
import '../../controller/api.dart';
import 'email_otp.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;
  bool _isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();

    final Map<String, dynamic> result =
        await apiService.register(email, password, firstName, lastName);

    if (result['success']) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmailOtpPage(
                    key: null,
                    email: email,
                  )));
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

  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Hey there,",
                style: TextStyle(color: AppColor.gray, fontSize: 16),
              ),
              Text(
                "Create an Account",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              RoundTextField(
                hitText: "First Name",
                icon: "assets/img/signup/Profile.png",
                controller: firstNameController,
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              RoundTextField(
                hitText: "Last Name",
                icon: "assets/img/signup/Profile.png",
                controller: lastNameController,
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              RoundTextField(
                hitText: "Email",
                icon: "assets/img/signup/Message.png",
                keywordtype: TextInputType.emailAddress,
                controller: emailController,
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              RoundTextField(
                hitText: "Password",
                icon: "assets/img/signup/Lock.png",
                obscureText: !_isPasswordVisible,
                controller: passwordController,
                rigtIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          _isPasswordVisible
                              ? "assets/img/signup/ShowPasswordEye.png"
                              : "assets/img/signup/HidePasswordEye.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: AppColor.gray,
                        ))),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isCheck = !isCheck;
                      });
                    },
                    icon: Icon(
                      isCheck
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank_outlined,
                      color: AppColor.gray,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "By continuing you accept our Privacy Policy and\nTerm of Use",
                      style: TextStyle(color: AppColor.gray, fontSize: 10),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: media.width * 0.3,
              ),
              RoundButton(
                title: "Register",
                onPressed: _register,
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 1,
                    color: AppColor.gray.withOpacity(0.5),
                  )),
                  Text(
                    "  Or  ",
                    style: TextStyle(color: AppColor.black, fontSize: 12),
                  ),
                  Expanded(
                      child: Container(
                    height: 1,
                    color: AppColor.gray.withOpacity(0.5),
                  )),
                ],
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(
                          width: 1,
                          color: AppColor.gray.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        "assets/img/signup/Google.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          color: AppColor.secondaryColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

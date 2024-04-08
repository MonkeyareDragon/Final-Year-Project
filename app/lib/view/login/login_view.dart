import 'package:flutter/material.dart';
import 'package:loginsignup/view/login/password_recovery.dart';
import 'package:loginsignup/view/login/signup_view.dart';
import 'package:loginsignup/view/login/welcome_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/base_widget/primary_button.dart';
import '../../common_widget/base_widget/textfield.dart';
import '../../controller/api.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isCheck = false;
  bool _isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    final Map<String, dynamic> result = await apiService.login(email, password);

    if (result['success']) {
      print('Login successful! Token: ${result['token']}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomeView()));
    } else {
      print('Login failed. Error: ${result['error']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: AppColor.gray, fontSize: 16),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
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
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordRecoveryScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot your password?",
                        style: TextStyle(
                            color: AppColor.gray,
                            fontSize: 12,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                RoundButton(title: "Login", onPressed: _login),
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
                          builder: (context) => const SignUpView()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don’t have an account yet? ",
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                            color: AppColor.secondaryColor1,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

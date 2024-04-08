import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/authentication/on_boarding_page.dart';
import '../login/signup_view.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      selectPage = controller.page?.round() ?? 0;

      setState(() {});
    });
  }

  List pageArray = [
    {
      "title": "Goal Tracking",
      "subtitle":
          "Effortlessly define and monitor your objectives. Our expertise can assist you in setting and tracking meaningful goals.",
      "image": "assets/img/onboarding/1.png"
    },
    {
      "title": "Achieve Excellence",
      "subtitle":
          "Persist through challenges to achieve your aspirations. Temporary discomfort is a small price for everlasting success.",
      "image": "assets/img/onboarding/2.png"
    },
    {
      "title": "Nutritional Guidance",
      "subtitle":
          "Explore tailored dietary plans for a healthier lifestyle and embrace well-balanced, nutritious meals.",
      "image": "assets/img/onboarding/3.png"
    },
    {
      "title": "Enhance Sleep Quality",
      "subtitle":
          "Elevate your sleep quality with our specialized solutions. Experience the positive impact of sound sleep on your overall well-being.",
      "image": "assets/img/onboarding/4.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
              controller: controller,
              itemCount: pageArray.length,
              itemBuilder: (context, index) {
                var pageObj = pageArray[index] as Map? ?? {};
                return OnBoardingPage(pageObj: pageObj);
              }),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor1,
                    value: (selectPage + 1) / 4,
                    strokeWidth: 2,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppColor.primaryColor1,
                      borderRadius: BorderRadius.circular(35)),
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: AppColor.white,
                    ),
                    onPressed: () {
                      if (selectPage <= 2) {
                        selectPage = selectPage + 1;

                        controller.animateToPage(selectPage,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.bounceInOut);
                        setState(() {});
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpView()));
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

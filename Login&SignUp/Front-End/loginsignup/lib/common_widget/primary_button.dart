import 'package:flutter/material.dart';
import '../common/color_extension.dart';

enum RoundButtonType { bgGradient, bgSGradient, textGradient }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;

  const RoundButton(
      {super.key,
      required this.title,
      this.type = RoundButtonType.bgGradient,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: AppColor.primaryG,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(25),
            boxShadow: type == RoundButtonType.bgGradient
                ? const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5))
                  ]
                : null),
        child: MaterialButton(
          onPressed: onPressed,
          height: 50,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          textColor: AppColor.primaryColor1,
          minWidth: double.maxFinite,
          elevation: type == RoundButtonType.bgGradient ? 0 : 1,
          color: type == RoundButtonType.bgGradient
              ? Colors.transparent
              : AppColor.white,
          child: type == RoundButtonType.bgGradient
              ? Text(title,
                  style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700))
              : ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                            colors: AppColor.primaryG,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)
                        .createShader(
                            Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                  },
                  child: Text(title,
                      style: TextStyle(
                          color: AppColor.primaryColor1,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
        ),
      ),
    );
  }
}

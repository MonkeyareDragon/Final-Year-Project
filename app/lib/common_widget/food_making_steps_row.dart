import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';

class FoodMakingStepsRow extends StatelessWidget {
  final Map sObj;
  final bool isLast;
  const FoodMakingStepsRow({super.key, required this.sObj, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColor.secondaryColor1,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.white, width: 3),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            if (!isLast)
              DottedDashedLine(
                  height: 50,
                  width: 0,
                  dashColor: AppColor.secondaryColor1,
                  axis: Axis.vertical)
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Step ${ sObj["step_no"].toString()}",
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                sObj["description"].toString(),
                style: TextStyle(color: AppColor.gray, fontSize: 12),
              ),
            ],
          ),
        )
      ],
    );
  }
}
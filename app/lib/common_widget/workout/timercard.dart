import 'package:flutter/material.dart';
import 'package:loginsignup/controller/workout/timer_service.dart';
import 'package:provider/provider.dart';

class TimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeService>(context);
    return Column(
      children: [
        Text(
          provider.currentStatus,
          style: TextStyle(fontSize: 50),
        )
      ],
    );
  }
}

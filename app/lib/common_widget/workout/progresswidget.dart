import 'package:flutter/material.dart';
import 'package:loginsignup/controller/workout/timer_service.dart';
import 'package:provider/provider.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeService>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Text("${provider.rounds}/4", style: TextStyle(fontSize: 30 , color: Colors.grey[350], fontWeight: FontWeight.bold),),
          Text("${provider.goal}/12", style: TextStyle(fontSize: 30 , color: Colors.grey[350], fontWeight: FontWeight.bold),),
        ],)
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:loginsignup/controller/workout/timer_service.dart';
import 'package:provider/provider.dart';

class TimeController extends StatefulWidget {
  const TimeController({super.key});

  @override
  State<TimeController> createState() => _TimeControllerState();
}

class _TimeControllerState extends State<TimeController> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeService>(context);

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
      child: Center(
        child: IconButton(
          icon: provider.timerPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
          color: Colors.white,
          iconSize: 55,
          onPressed: (){
            provider.timerPlaying ? Provider.of<TimeService>(context, listen: false).pause() : Provider.of<TimeService>(context, listen: false).start();
          },
        ),
      ),
    );
  }
}

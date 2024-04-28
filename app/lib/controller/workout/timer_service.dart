import 'dart:async';

import 'package:flutter/material.dart';

class TimeService extends ChangeNotifier {
  late Timer timer;
  double currentDuration = 10;
  double selectedTime = 10;
  bool timerPlaying = false;
  int rounds = 0;
  int goal = 0;
  String currentStatus = "FOCUS";

  void start() {
    timerPlaying = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentDuration == 0) {
        handleNextRound();
      } else {
        currentDuration--;
        notifyListeners();
      }
      currentDuration--;
      notifyListeners();
    });
  }

  void pause() {
    timer.cancel();
    timerPlaying = false;
    notifyListeners();
  } 

  void selectTime(double seconds) {
    selectedTime = seconds;
    currentDuration = seconds;
    notifyListeners();
  }

  void handleNextRound() {
    if(currentStatus == "FOCUS" && rounds != 3) {
      currentStatus = "BREAK";
      currentDuration = 5;
      selectedTime = 5;
      rounds++;
      goal++;
    } else if (currentStatus == "BREAK") {
      currentStatus = "FOCUS";
      currentDuration = 10;
      selectedTime = 10;
    } else if (currentStatus == "FOCUS" && rounds == 3) {
      currentStatus = "LONGBREAK";
      currentDuration = 10;
      currentDuration = 10;
      rounds++;
      goal++;
    } else if (currentStatus == "LONGBREAK") {
      currentStatus = "FOCUS";
      currentDuration = 10;
      selectedTime = 10;
      rounds = 0;
    }
    notifyListeners();
  }
}

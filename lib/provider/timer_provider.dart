import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  late Timer _timer;
  int _countDown = 30;

  TimerProvider() {
    startTimer();
  }

  int get countDown => _countDown;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_countDown == 0) {
          timer.cancel();
        } else {
          _countDown--;
          notifyListeners();
        }
      },
    );
  }

  void resetTimer() {
    _countDown = 30;
    startTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatchState with ChangeNotifier {
  StopWatchTimer stopWatchTimer = StopWatchTimer();

  void inital(int min, VoidCallback onEnded) {
    stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromMinute(min),
      onEnded: onEnded,
    );

    notifyListeners();
  }

  void changeTime(int newTime) {
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);

    stopWatchTimer.setPresetMinuteTime(newTime);

    notifyListeners();
  }

  void toggleTime(StopWatchExecute execute) {
    stopWatchTimer.onExecute.add(execute);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class SettingState with ChangeNotifier {
  bool screenAlive = false;
  int defaultTime = 60;
  int totalTask = 5;

  void setData(Map d) async {
    screenAlive = d['screenAlive'];
    defaultTime = d['defaultTime'];

    notifyListeners();

    await Wakelock.toggle(enable: screenAlive);
  }

  Future<void> toggleScreenAlive(bool value) async {
    await Wakelock.toggle(enable: value);
    screenAlive = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("screenAlive", value);
  }

  Future<void> changeTime(int time) async {
    defaultTime = time;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("minute", time);
  }
}

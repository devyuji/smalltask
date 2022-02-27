import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smalltask/constraint.dart';
import 'package:smalltask/provider.dart/setting_state.dart';
import 'package:smalltask/provider.dart/stopwatch_state.dart';
import 'package:smalltask/provider.dart/task_state.dart';
import 'package:smalltask/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kBackgroundColor,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskState()),
        ChangeNotifierProvider(create: (_) => SettingState()),
        ChangeNotifierProvider(create: (_) => StopWatchState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      title: 'SmallTask',
      color: kBackgroundColor,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: "Montserrat",
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      home: const Home(),
    );
  }
}

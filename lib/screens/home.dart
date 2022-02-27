import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smalltask/constraint.dart';
import 'package:smalltask/database/db.dart';
import 'package:smalltask/provider.dart/setting_state.dart';
import 'package:smalltask/provider.dart/stopwatch_state.dart';
import 'package:smalltask/provider.dart/task_state.dart';
import 'package:smalltask/widgets/animation_dialog.dart';
import 'package:smalltask/widgets/modal/add_new_task_modal.dart';
import 'package:smalltask/widgets/custom_appbar_home.dart';
import 'package:smalltask/widgets/modal/custom_bottom_modal.dart';
import 'package:smalltask/widgets/task_card.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;

  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    _prepare();

    _settingSetUp();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _prepare() async {
    final prefs = await SharedPreferences.getInstance();

    final minute = prefs.getInt("minute") ?? 60;

    Provider.of<StopWatchState>(context, listen: false)
        .inital(minute, _onEndStopWatch);

    final _data = await Db.instance.readAll();

    Provider.of<TaskState>(context, listen: false).setData(_data);

    setState(() {
      _loading = false;
    });
  }

  Future<void> _settingSetUp() async {
    final prefs = await SharedPreferences.getInstance();

    bool screenAlive = prefs.getBool("screenAlive") ?? false;
    int defaultTime = prefs.getInt("minute") ?? 60;

    Provider.of<SettingState>(context, listen: false).setData({
      "screenAlive": screenAlive,
      "defaultTime": defaultTime,
    });
  }

  Future<void> _deleteAll() async {
    if (Provider.of<TaskState>(context, listen: false).data.isEmpty) return;

    Provider.of<StopWatchState>(context, listen: false)
        .toggleTime(StopWatchExecute.reset);

    await Db.instance.deleteAll();

    Provider.of<TaskState>(context, listen: false).deleteAll();
  }

  Future<void> _toggleStopWatch() async {
    final _stopWatchTimer =
        Provider.of<StopWatchState>(context, listen: false).stopWatchTimer;

    if (Provider.of<TaskState>(context, listen: false).data.isEmpty) {
      AnimationDialoge.scaleUp(
        context,
        AlertDialog(
          backgroundColor: kdialogColor,
          contentPadding: const EdgeInsets.all(kDefaultPadding * 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding * 2),
          ),
          title: SvgPicture.asset(
            "assets/icons/add.svg",
            height: 150,
          ),
          content: const Text(
            "Add atleast 1 task to start. 🙅",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        true,
      );
      return;
    }

    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.of(context).pop();
    });

    if (!_stopWatchTimer.isRunning) {
      AnimationDialoge.slideUp(
        context,
        AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: SvgPicture.asset("assets/icons/clock.svg", height: 150),
          content: const Text(
            'Timer Started',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        false,
      );

      Provider.of<StopWatchState>(context, listen: false)
          .toggleTime(StopWatchExecute.start);

      return;
    }

    AnimationDialoge.slideDown(
      context,
      AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset("assets/icons/clock.svg", height: 150),
        content: const Text(
          'Timer Stoped',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      false,
    );

    Provider.of<StopWatchState>(context, listen: false)
        .toggleTime(StopWatchExecute.stop);
  }

  void _onEndStopWatch() {
    Provider.of<StopWatchState>(context, listen: false)
        .toggleTime(StopWatchExecute.reset);

    final totalTaskDone =
        Provider.of<TaskState>(context, listen: false).taskDone();

    AnimationDialoge.scaleUp(
      context,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding * 2),
        ),
        content: Text(
          totalTaskDone == 0
              ? "You have completed all your task. 🎉"
              : "You have $totalTaskDone task left to be complete. 😣",
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _data = Provider.of<TaskState>(context).data;
    final _stopWatchTimer = Provider.of<StopWatchState>(context).stopWatchTimer;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: kDefaultPadding * 2),
          child: Column(
            children: <Widget>[
              const CustomAppBarHome(),
              const SizedBox(height: kDefaultPadding * 3),
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 750),
                  opacity: _loading ? 0 : 1,
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2,
                      vertical: kDefaultPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(kDefaultPadding * 4),
                        topRight: Radius.circular(kDefaultPadding * 4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.more_horiz_outlined,
                              size: 60.0,
                              color: kBackgroundColor,
                            ),
                            TextButton.icon(
                              icon: const Icon(
                                Icons.schedule_outlined,
                                size: 20.0,
                              ),
                              onPressed: _toggleStopWatch,
                              onLongPress: () async {
                                if (!_stopWatchTimer.isRunning) {
                                  Provider.of<StopWatchState>(context,
                                          listen: false)
                                      .toggleTime(StopWatchExecute.reset);
                                }
                              },
                              label: StreamBuilder(
                                stream: _stopWatchTimer.rawTime,
                                initialData: _stopWatchTimer.rawTime.value,
                                builder: (context, snap) {
                                  final value = snap.data;

                                  final displayTime =
                                      StopWatchTimer.getDisplayTime(
                                    int.parse(value.toString()),
                                    milliSecond: false,
                                    hours: false,
                                  );

                                  return Text(
                                    displayTime,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: _deleteAll,
                              icon: const Icon(
                                Icons.clear_all_outlined,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: !_loading,
                          child: Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                              child: _data.isEmpty
                                  ? Center(
                                      child: SvgPicture.asset(
                                          "assets/icons/note.svg"),
                                    )
                                  : AnimatedList(
                                      key: _listKey,
                                      itemBuilder:
                                          ((context, index, animation) {
                                        return SizeTransition(
                                          sizeFactor: animation,
                                          child: TaskCard(
                                            data: _data[index],
                                            listKey: _listKey,
                                          ),
                                        );
                                      }),
                                      initialItemCount: _data.length,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        onPressed: () {
          customBottomModal(context, AddNewTaskModal(listKey: _listKey));
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.black,
          size: 35.0,
        ),
      ),
    );
  }
}

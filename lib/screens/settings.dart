import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smalltask/constraint.dart';
import 'package:smalltask/provider.dart/setting_state.dart';
import 'package:smalltask/provider.dart/stopwatch_state.dart';
import 'package:smalltask/widgets/box.dart';
import 'package:smalltask/widgets/modal/custom_bottom_modal.dart';
import 'package:smalltask/widgets/modal/edit_setting_modal.dart';
import 'package:smalltask/widgets/underline_text.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final time = Provider.of<SettingState>(context).defaultTime;

    void _saveDefaultTime(String value) {
      if (value.isEmpty) return;

      final time =
          Provider.of<SettingState>(context, listen: false).defaultTime;

      Provider.of<SettingState>(context, listen: false)
          .changeTime(int.parse(value));

      int newTime = int.parse(value) - time;

      Provider.of<StopWatchState>(context, listen: false).changeTime(newTime);

      Navigator.of(context).pop();
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: kDefaultPadding,
            right: kDefaultPadding,
            top: kDefaultPadding * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Box(
                      child: Padding(
                        padding: EdgeInsets.all(kDefaultPadding),
                        child: Icon(Icons.arrow_back_rounded),
                      ),
                      shadowColor: Colors.black,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: UnderlineText(text: 'Settings'),
                    ),
                  ),
                ],
              ),

              // main content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: kDefaultPadding * 3),
                  children: <Widget>[
                    Box(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.black,
                      child: ListTile(
                        onTap: () {
                          customBottomModal(
                            context,
                            EditModal(
                              number: time,
                              suffixText: "minute",
                              save: _saveDefaultTime,
                            ),
                          );
                        },
                        leading: const Icon(
                          Icons.update_rounded,
                          color: Colors.black,
                        ),
                        title: const Text("Change Time"),
                        trailing: Text(
                          '$time',
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding * 2),
                    Box(
                      backgroundColor: Colors.white,
                      child: SwitchListTile(
                        value: Provider.of<SettingState>(context).screenAlive,
                        onChanged: (value) async {
                          await Provider.of<SettingState>(context,
                                  listen: false)
                              .toggleScreenAlive(value);
                        },
                        secondary: const Icon(
                          Icons.light_mode_outlined,
                          color: Colors.black,
                        ),
                        title: const Text('Keep Screen Alive'),
                      ),
                      shadowColor: Colors.black,
                    ),
                    const SizedBox(height: kDefaultPadding * 5),
                    Box(
                      backgroundColor: Colors.white,
                      child: ListTile(
                        onTap: () {
                          _launchURL(
                              "https://github.com/devyuji/smalltask/issues/new");
                        },
                        leading: const Icon(
                          Icons.bug_report_outlined,
                          color: Colors.black,
                        ),
                        title: const Text("Have an issue"),
                        trailing: const Icon(
                          Icons.chevron_right_outlined,
                          color: Colors.black,
                        ),
                      ),
                      shadowColor: Colors.black,
                    ),
                    const SizedBox(height: kDefaultPadding * 2),
                    Box(
                      backgroundColor: Colors.white,
                      child: ListTile(
                        onTap: () {
                          _launchURL("https://github.com/devyuji");
                        },
                        leading: SvgPicture.asset("assets/icons/github.svg"),
                        title: const Text("Github"),
                        trailing: const Icon(
                          Icons.chevron_right_outlined,
                          color: Colors.black,
                        ),
                      ),
                      shadowColor: Colors.black,
                    ),
                    const SizedBox(height: kDefaultPadding * 2),
                    Box(
                      backgroundColor: Colors.white,
                      child: ListTile(
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationIcon:
                                Image.asset('assets/images/icon.png'),
                            applicationName: "SmallTask",
                            applicationVersion: "1.0.0",
                            applicationLegalese:
                                "Take small steps to achieve big things.",
                          );
                        },
                        leading: const Icon(Icons.info_outlined,
                            color: Colors.black),
                        title: const Text("About"),
                        trailing: const Icon(
                          Icons.chevron_right_outlined,
                          color: Colors.black,
                        ),
                      ),
                      shadowColor: Colors.black,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

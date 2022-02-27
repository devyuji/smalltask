import "package:flutter/material.dart";
import 'package:smalltask/custom_route_animation.dart';
import 'package:smalltask/screens/settings.dart';
import 'package:smalltask/widgets/box.dart';
import 'package:smalltask/widgets/underline_text.dart';

class CustomAppBarHome extends StatelessWidget {
  const CustomAppBarHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutSine,
      tween: Tween<double>(begin: 0, end: 1),
      builder: ((context, double value, child) => Padding(
            padding: EdgeInsets.symmetric(horizontal: value * 10),
            child: child,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const UnderlineText(text: "SmallTask,"),
          SizedBox(
            width: 40.0,
            height: 40.0,
            child: Box(
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, customRoute(const Settings()));
                },
                icon: const Icon(Icons.settings, size: 25.0),
              ),
              shadowColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

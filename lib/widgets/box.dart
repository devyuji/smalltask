import 'package:flutter/material.dart';
import 'package:smalltask/constraint.dart';

class Box extends StatelessWidget {
  const Box({
    Key? key,
    required this.child,
    required this.shadowColor,
    this.backgroundColor = kPrimaryColor,
  }) : super(key: key);

  final Widget child;
  final Color shadowColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(kDefaultPadding),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 5.0),
          )
        ],
      ),
      child: child,
    );
  }
}

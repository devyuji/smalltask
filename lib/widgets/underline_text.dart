import "package:flutter/material.dart";

class UnderlineText extends StatelessWidget {
  const UnderlineText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 30.0,
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 10.0,
          width: 10.0,
          color: Colors.yellow.withOpacity(0.5),
        ),
      ),
    ]);
  }
}

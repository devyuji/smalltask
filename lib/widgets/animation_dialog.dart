import 'package:flutter/material.dart';

class AnimationDialoge {
  static void slideUp(
      BuildContext context, AlertDialog alertDialog, bool isDismissed) {
    final screenHeight = MediaQuery.of(context).size.height;

    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: isDismissed,
      context: context,
      transitionDuration: const Duration(milliseconds: 550),
      pageBuilder: (context, _, __) => const SizedBox(),
      transitionBuilder: (context, _animation1, _animation2, child) {
        final curvedValue =
            Curves.easeInOutBack.transform(_animation1.value) - 1.0;

        return WillPopScope(
          onWillPop: () async => isDismissed,
          child: Transform(
            transform:
                Matrix4.translationValues(0, -curvedValue * screenHeight, 0),
            child: alertDialog,
          ),
        );
      },
    );
  }

  static void slideDown(
      BuildContext context, AlertDialog alertDialog, bool isDismissed) {
    final screenHeight = MediaQuery.of(context).size.height;
    showGeneralDialog(
      barrierDismissible: isDismissed,
      barrierLabel: "",
      context: context,
      transitionDuration: const Duration(milliseconds: 550),
      pageBuilder: (context, _, __) => const SizedBox(),
      transitionBuilder: (context, _animation1, _animation2, child) {
        final curvedValue =
            Curves.easeInOutBack.transform(_animation1.value) - 1.0;

        return WillPopScope(
          onWillPop: () async => isDismissed,
          child: Transform(
            transform:
                Matrix4.translationValues(0, curvedValue * screenHeight, 0),
            child: alertDialog,
          ),
        );
      },
    );
  }

  static void scaleUp(
      BuildContext context, AlertDialog alertDialog, bool isDissmissed) {
    showGeneralDialog(
      barrierDismissible: isDissmissed,
      barrierLabel: "",
      context: context,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, _, __) => const SizedBox(),
      transitionBuilder: (context, _animation1, _animation2, child) {
        return WillPopScope(
          onWillPop: () async => isDissmissed,
          child: ScaleTransition(scale: _animation1, child: alertDialog),
        );
      },
    );
  }
}

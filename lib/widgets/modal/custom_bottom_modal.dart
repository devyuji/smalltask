import 'package:flutter/material.dart';
import 'package:smalltask/constraint.dart';

void customBottomModal(BuildContext context, Widget widget) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(kDefaultPadding * 2),
        topRight: Radius.circular(kDefaultPadding * 2),
      ),
    ),
    context: context,
    builder: (_) => widget,
  );
}

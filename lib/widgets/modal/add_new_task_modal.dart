import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smalltask/constraint.dart';
import 'package:smalltask/database/db.dart';
import 'package:smalltask/provider.dart/setting_state.dart';
import 'package:smalltask/provider.dart/task_state.dart';
import 'package:smalltask/widgets/animation_dialog.dart';
import 'package:smalltask/widgets/box.dart';
import 'package:smalltask/widgets/underline_text.dart';

class AddNewTaskModal extends StatefulWidget {
  const AddNewTaskModal({Key? key, required this.listKey}) : super(key: key);

  final GlobalKey<AnimatedListState> listKey;

  @override
  State<AddNewTaskModal> createState() => _AddNewTaskModalState();
}

class _AddNewTaskModalState extends State<AddNewTaskModal> {
  late TextEditingController _textController;
  late FocusNode _inputFocusNode;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
    _inputFocusNode = FocusNode();

    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final _value = _textController.text.trim();

    if (_value.isEmpty) return;

    final totalTask =
        Provider.of<SettingState>(context, listen: false).totalTask;

    if (Provider.of<TaskState>(context, listen: false).taskDone() >=
        totalTask) {
      return AnimationDialoge.slideDown(
        context,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding * 2),
          ),
          backgroundColor: const Color(0xFFFFFBD6),
          title: SvgPicture.asset(
            "assets/icons/limit.svg",
            height: 80,
          ),
          content: const Text(
            'Complete your pending task.',
            style: TextStyle(
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        true,
      );
    }

    final id = await Db.instance.addTask(_value);

    widget.listKey.currentState?.insertItem(
      Provider.of<TaskState>(context, listen: false).data.length,
      duration: const Duration(milliseconds: 300),
    );

    Provider.of<TaskState>(context, listen: false).add(_value, id);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 1.1,
      padding: const EdgeInsets.all(kDefaultPadding),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const UnderlineText(text: "Add new task"),
            const SizedBox(height: kDefaultPadding * 2),
            TextField(
              maxLength: 150,
              maxLines: null,
              autocorrect: true,
              autofocus: true,
              controller: _textController,
              focusNode: _inputFocusNode,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  borderSide: BorderSide(color: Colors.yellow.shade700),
                ),
                hintText: "Enter your task..",
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            GestureDetector(
              onTap: _save,
              child: Box(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.save_rounded),
                      SizedBox(width: kDefaultPadding),
                      Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                shadowColor: Colors.black,
              ),
            ),
            const SizedBox(height: kDefaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

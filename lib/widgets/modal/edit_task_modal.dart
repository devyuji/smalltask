import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smalltask/constraint.dart';
import 'package:smalltask/database/db.dart';
import 'package:smalltask/models.dart';
import 'package:smalltask/provider.dart/task_state.dart';
import 'package:smalltask/widgets/box.dart';
import 'package:smalltask/widgets/underline_text.dart';

class EditModal extends StatefulWidget {
  const EditModal({Key? key, required this.value}) : super(key: key);

  final Task value;

  @override
  _EditModalState createState() => _EditModalState();
}

class _EditModalState extends State<EditModal> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(text: widget.value.taskName);

    _textEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _edit() async {
    final value = _textEditingController.text.trim();

    if (value != widget.value.taskName) {
      await Db.instance.update(value, widget.value.id);

      Provider.of<TaskState>(context, listen: false)
          .update(widget.value.id, value);
    }
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
            const UnderlineText(text: "Edit task"),
            const SizedBox(height: kDefaultPadding * 2),
            TextField(
              maxLength: 150,
              maxLines: null,
              autofocus: true,
              controller: _textEditingController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: kPrimaryColor,
                  ),
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                ),
                hintText: "Enter your task..",
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            GestureDetector(
              onTap: _edit,
              child: Box(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.edit_rounded),
                      SizedBox(width: kDefaultPadding),
                      Text(
                        'Edit',
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
            const SizedBox(height: kDefaultPadding * 2)
          ],
        ),
      ),
    );
  }
}

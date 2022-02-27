import "package:flutter/material.dart";
import 'package:smalltask/constraint.dart';

class EditModal extends StatefulWidget {
  const EditModal(
      {Key? key,
      required this.number,
      required this.suffixText,
      required this.save})
      : super(key: key);

  final int number;
  final String suffixText;
  final void Function(String value) save;

  @override
  State<EditModal> createState() => _EditModalState();
}

class _EditModalState extends State<EditModal> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(
      text: widget.number.toString(),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        kDefaultPadding * 2,
        kDefaultPadding * 2,
        kDefaultPadding * 2,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _textEditingController,
            autofocus: true,
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w800,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor),
              ),
              suffix: Text(widget.suffixText.toUpperCase()),
              suffixStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            onSubmitted: widget.save,
          ),
          const SizedBox(height: kDefaultPadding * 2)
        ],
      ),
    );
  }
}

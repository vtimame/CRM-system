import 'package:flutter/material.dart';

class SmallInput extends StatelessWidget {
  final String hint;
  final String value;
  final int maxLines;
  final Function onChange;
  final bool disabled;
  final TextEditingController controller;
  final TextEditingController _defaultController = TextEditingController();

  SmallInput(
      {this.hint,
      this.disabled = false,
      this.onChange,
      this.maxLines = 1,
      this.controller,
      this.value = ''});

  @override
  Widget build(BuildContext context) {
    TextEditingController inputController =
        controller != null ? controller : _defaultController;

    inputController.text = value;
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) onChange(inputController.text);
      },
      child: TextField(
        controller: inputController,
//        onSubmitted: (value) => onChange(value),
        maxLines: maxLines,
        enabled: !disabled,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[100])),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[300])),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[100])),
          isDense: true, // Added this
          contentPadding:
              EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Added this
        ),
      ),
    );
  }
}

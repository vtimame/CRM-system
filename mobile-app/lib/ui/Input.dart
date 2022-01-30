import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextInputType type;
  final Function onChanged;
  final String hint;
  final bool obscure;
  final TextEditingController controller;

  Input(
      {Key key,
      this.onChanged,
      this.hint,
      this.type,
      this.obscure = false,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: type,
        obscureText: obscure,
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            filled: true,
            fillColor: Colors.blueGrey[50],
            hintText: hint),
        onChanged: (value) => onChanged(value));
  }
}

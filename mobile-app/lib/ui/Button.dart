import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color textColor;
  final String color;
  final String text;
  final Function onPressed;
  final int colorLevel;
  final int disabledColorLevel;

  Button(
      {Key key,
      this.onPressed,
      this.color = 'green',
      this.textColor = Colors.white,
      this.colorLevel = 500,
      this.disabledColorLevel = 300,
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: renderButton(),
    );
  }

  Widget renderButton() {
    switch (Platform.operatingSystem) {
      case 'ios':
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: renderCupertinoButton(),
        );
      case 'android':
      default:
        return renderMaterialButton();
    }
  }

  Widget renderMaterialButton() {
    return RaisedButton(
      onPressed: onPressed,
      color: getColor(color, colorLevel),
      disabledColor: getColor(color, disabledColorLevel),
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }

  Widget renderCupertinoButton() {
    return CupertinoButton(
      onPressed: onPressed,
      color: getColor(color, colorLevel),
      disabledColor: getColor(color, disabledColorLevel),
      padding: EdgeInsets.all(0),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }

  Color getColor(String color, int level) {
    switch (color) {
      case "transparent":
        return Colors.transparent;
      case "blue":
        return Colors.blue[level];
      case "red":
        return Colors.red[level];
      case "yellow":
        return Colors.yellow[level];
      case "green":
      default:
        return Colors.green[level];
    }
  }
}

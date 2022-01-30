import 'package:flutter/material.dart';

class FadeRouteTransition extends PageRouteBuilder {
  final Widget page;
  FadeRouteTransition({this.page})
      : super(
          transitionDuration: Duration(milliseconds: 100),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

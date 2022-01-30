import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oycrm/utils/FadeRouteTransition.dart';
import 'package:oycrm/widgets/BoardScreen.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen.dart';
import 'package:oycrm/widgets/LoginScreen.dart';
import 'package:oycrm/widgets/NotificationsScreen.dart';
import 'package:oycrm/widgets/TasksScreen.dart';
import 'package:oycrm/widgets/UserScreen.dart';

class AppRouter {
  static const loginScreen = '/';
  static const boardScreen = '/board';
  static const tasksScreen = '/tasks';
  static const userScreen = '/user';
  static const notificationsScreen = '/notifications';
  static const openedCardScreen = '/openedCard';

  static String previousRoute;
  static String currentRoute = loginScreen;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return FadeRouteTransition(page: LoginScreen());
      case boardScreen:
        return FadeRouteTransition(page: BoardScreen());
      case tasksScreen:
        return FadeRouteTransition(page: TasksScreen());
      case userScreen:
        return FadeRouteTransition(page: UserScreen());
      case notificationsScreen:
        return FadeRouteTransition(page: NotificationsScreen());
      case openedCardScreen:
        return CupertinoPageRoute(builder: (_) => OpenedCardScreen());
      default:
        return FadeRouteTransition(
            page: Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ));
    }
  }

  static void push(BuildContext context, String routeName) {
    if (currentRoute != routeName || routeName == openedCardScreen) {
      previousRoute = currentRoute;
      currentRoute = routeName;
      Navigator.pushNamed(context, routeName);
    }
  }

  static void pushReplacementNamed(BuildContext context, String routeName) {
    if (currentRoute != routeName) {
      previousRoute = currentRoute;
      currentRoute = routeName;
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  static Future<void> pop(BuildContext context) async {
    if (previousRoute != null) currentRoute = previousRoute;
    Navigator.of(context).pop(true);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/PushNotifications.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:sentry/sentry.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final sentry = SentryClient(
    dsn: "https://404178b6154448249db37d61a1e83a7d@sentry.labilab.ru/5");

void main() async {
  await setupServiceLocator();

  FlutterError.onError = (details, {bool forceReport = false}) {
    print(details.exception);
    sentry.captureException(
      exception: details.exception,
      stackTrace: details.stack,
    );
  };

  runZonedGuarded(
    () => runApp(MyApp()),
    (error, stackTrace) async {
      print(error);
      await sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    },
  );
}

//void main() async {
//  await setupServiceLocator();
//  runApp(MyApp());
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    sl<PushNotification>().init();
    return MaterialApp(
      title: 'oycrm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      darkTheme: ThemeData(
//        brightness: Brightness.dark,
//      ),
      onGenerateRoute: AppRouter.generateRoute,
      navigatorKey: navigatorKey,
      initialRoute: AppRouter.loginScreen,
    );
  }
}

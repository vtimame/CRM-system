import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/LoginScreen/LoginCredentialsBloc.dart';
import 'package:oycrm/bloc/NotificationsBloc.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'AppRouter.dart';

class PushNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void init() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
//        var notify = _getNotificationMessage(message);
//        _pushNotification(notify);
        sl<NotificationsBloc>().loadNotifications();
      },
      onLaunch: (Map<String, dynamic> message) async {
        var notify = _getNotificationMessage(message);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("notifyCard", notify["event"]["card_id"]);
      },
      onResume: (Map<String, dynamic> message) async {
        var notify = _getNotificationMessage(message);
        _pushNotification(notify);
        _openCard(notify["event"]["card_id"]);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      sl<LoginCredentialsBloc>().setField('firebaseToken', token);
    });

    Stream<String> fcmStream = _firebaseMessaging.onTokenRefresh;
    fcmStream.listen((token) {
      sl<LoginCredentialsBloc>().setField('firebaseToken', token);
    });
  }

  _pushNotification(Map<String, dynamic> message) {
    sl<NotificationsBloc>().pushNotification(message);
  }

  _getNotificationMessage(Map<String, dynamic> message) {
    if (Platform.isAndroid) {
      return json.decode(message["data"]["body"]);
    } else if (Platform.isIOS) {
      return json.decode(message['body']);
    }
  }

  Future _openCard(String cardId) async {
    print("load card");
    await sl<OpenedCardBloc>().loadCardInstance(cardId);
    print("card loaded");
    navigatorKey.currentState.pushNamed(AppRouter.openedCardScreen);
  }
}

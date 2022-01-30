import 'package:dio/dio.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';

class NotificationRepository {
  Future loadNotifications() async {
    try {
      Response notifications = await sl<Http>().get('user/notifications');
      return notifications.data;
    } catch (e) {
      print(e);
    }
  }

  Future readNotifications(List ids) async {
    try {
      await sl<Http>().put('user/notifications', data: {"notifications": ids});
    } catch (e) {
      print(e);
    }
  }
}

import 'package:oycrm/repositories/NotificationRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsBloc {
  final _notificationsList = BehaviorSubject<List>.seeded(null);
  final _onlyNew = BehaviorSubject<bool>.seeded(false);

  Stream get notificationsListStream => _notificationsList.stream;
  Stream get onlyNewStream => _onlyNew.stream;
  Sink get notificationsListSink => _notificationsList.sink;
  Sink get onlyNewSink => _onlyNew.sink;

  List _allNotifications = [];

  Future loadNotifications() async {
    List notifications = await sl<NotificationRepository>().loadNotifications();

    _allNotifications = notifications;
    if (_onlyNew.value == true) {
      notificationsListSink.add(notifications
          .where((element) => element['read_at'] == null)
          .toList());
    } else {
      notificationsListSink.add(notifications);
    }
  }

  void pushNotification(instance) {
    print(instance);
    List newList = new List.from([instance])..addAll(_notificationsList.value);
    notificationsListSink.add(newList);
  }

  List<dynamic> cardNotificationsIds(String id) {
    return _notificationsList.value
        .where((el) => el['event']['card_id'] == id)
        .map((e) => e['_id'])
        .toList();
  }

  Future readNotifications(List ids) async {
    await sl<NotificationRepository>().readNotifications(ids);
    await sl<NotificationRepository>().loadNotifications();
    loadNotifications();
  }

  Future setOnlyNewState(bool state) async {
    onlyNewSink.add(state);
  }

  void dispose() {
    _notificationsList.close();
    _onlyNew.close();
  }
}

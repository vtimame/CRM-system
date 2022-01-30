import 'package:flutter/material.dart';
import 'package:oycrm/bloc/BoardScreen/CardsBloc.dart';
import 'package:oycrm/bloc/NotificationsBloc.dart';
import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/ui/ApplicationBottomBar.dart';
import 'package:oycrm/ui/Notification.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/widgets/NotificationsScreen/NotificationsBar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NotificationsBloc notificationsBloc = sl<NotificationsBloc>();
    final UserBloc userBloc = sl<UserBloc>();

    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    void _onRefresh() async {
      await sl<NotificationsBloc>().loadNotifications();
      _refreshController.refreshCompleted();
    }

    return WillPopScope(
      onWillPop: () => AppRouter.pop(context),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: DefaultTabController(
            length: 3,
            initialIndex: 1,
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: Scaffold(
                body: StreamBuilder(
                  stream: notificationsBloc.onlyNewStream,
                  builder: (context, state) => StreamBuilder(
                    stream: notificationsBloc.notificationsListStream,
                    builder: (context, list) {
                      if (list.connectionState == ConnectionState.active &&
                          list.data != null) {
                        List<Widget> personalNotificationsWidgets = [];
                        List<Widget> creatorNotificationsWidgets = [];
                        List<Widget> otherNotificationsWidgets = [];

                        List<dynamic> notifications = [];
                        if (state.data == true) {
                          notifications = list.data
                              .where((el) => el['read_at'] == null)
                              .toList();
                        } else {
                          notifications = list.data;
                        }

                        List<dynamic> personalNotifications =
                            notifications.where((el) {
                          return el['event']['type'] == 'cardMentionWasAdded' ||
                              el['event']['type'] == 'newSiteTicket' ||
                              el['event']['type'] == 'cardAnswerWasAdded';
                        }).toList();

                        List<dynamic> creatorNotifications =
                            notifications.where((el) {
                          var card = sl<CardsBloc>()
                              .rawCardInstance(el['event']['card_id']);

                          if (card == null) return false;

                          bool isCreator =
                              userBloc.user.value['_id'] == card['creator_id'];
                          bool isPersonal =
                              el['event']['type'] == 'cardMentionWasAdded' ||
                                  el['event']['type'] == 'cardAnswerWasAdded';

                          return isCreator && !isPersonal;
                        }).toList();

                        List<dynamic> otherNotifications =
                            notifications.where((el) {
                          var card = sl<CardsBloc>()
                              .rawCardInstance(el['event']['card_id']);

                          if (card == null) return false;

                          bool isCreator =
                              userBloc.user.value['_id'] == card['creator_id'];
                          bool isPersonal =
                              el['event']['type'] == 'cardMentionWasAdded' ||
                                  el['event']['type'] == 'cardAnswerWasAdded';

                          return !isCreator && !isPersonal;
                        }).toList();

                        if (personalNotifications.length > 0) {
                          personalNotifications.forEach((el) {
                            personalNotificationsWidgets.add(SizedBox(
                              width: double.infinity,
                              child: NotificationItem(
                                notification: el,
                              ),
                            ));

                            personalNotificationsWidgets.add(SizedBox(
                              height: 4.0,
                            ));
                          });
                        } else {
                          personalNotificationsWidgets.add(Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Здесь пока нет уведомлений',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ));
                        }

                        if (creatorNotifications.length > 0) {
                          creatorNotifications.forEach((el) {
                            creatorNotificationsWidgets.add(SizedBox(
                              width: double.infinity,
                              child: NotificationItem(
                                notification: el,
                              ),
                            ));

                            creatorNotificationsWidgets.add(SizedBox(
                              height: 4.0,
                            ));
                          });
                        } else {
                          creatorNotificationsWidgets.add(Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Здесь пока нет уведомлений',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ));
                        }

                        if (otherNotifications.length > 0) {
                          otherNotifications.forEach((el) {
                            otherNotificationsWidgets.add(NotificationItem(
                              notification: el,
                            ));

                            otherNotificationsWidgets.add(SizedBox(
                              height: 4.0,
                            ));
                          });
                        } else {
                          otherNotificationsWidgets.add(Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Здесь пока нет уведомлений',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ));
                        }

                        return TabBarView(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: creatorNotificationsWidgets,
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: personalNotificationsWidgets,
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: otherNotificationsWidgets,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                appBar: NotificationsBar(),
                bottomNavigationBar: ApplicationBottomBar(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

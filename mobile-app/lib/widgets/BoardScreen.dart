import 'package:flutter/material.dart';
import 'package:oycrm/bloc/BoardScreen/BoardsBloc.dart';
import 'package:oycrm/bloc/BoardScreen/CardsBloc.dart';
import 'package:oycrm/bloc/BoardScreen/ColumnsBloc.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/NotificationsBloc.dart';
import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/bloc/UsersBloc.dart';
import 'package:oycrm/ui/ApplicationBottomBar.dart';
import 'package:oycrm/ui/LoadingScreen.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/SocketConnection.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BoardScreen/BoardAppBar.dart';
import 'BoardScreen/BoardColumn.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await loadData();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future loadData() async {
    await sl<UsersBloc>().loadUsers();
    await sl<ColumnsBloc>().loadColumns();
    await sl<ColumnsBloc>().loadRawColumns();
    await sl<BoardsBloc>().loadBoards();
    await sl<CardsBloc>().loadRawCards();
    await sl<NotificationsBloc>().loadNotifications();
    await connectToSocketChannels();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("notifyCard") != null) {
      await sl<OpenedCardBloc>()
          .loadCardInstance(prefs.getString("notifyCard"));
      await prefs.remove("notifyCard");
      AppRouter.push(context, AppRouter.openedCardScreen);
    }
  }

  Future connectToSocketChannels() async {
    Map user = sl<UserBloc>().user.value;
    Map currentBoard = sl<BoardsBloc>().currentBoard.value;

    sl<SocketConnection>()
        .echo
        .join('board.${currentBoard['_id']}')
        .here((users) {})
        .joining((user) {})
        .leaving((user) {})
        .listen('PresenceEvent', (e) {
      sl<NotificationsBloc>().pushNotification(e);
    });

    sl<SocketConnection>()
        .echo
        .join('notifications.${user['_id']}')
        .listen('NotificationWasReceived', (e) {
      print(e);
    });

    sl<SocketConnection>()
        .echo
        .private('board.${currentBoard['_id']}')
        .listen('.client-setCardData', (event) {
      sl<CardsBloc>().updateCard(event['card_id'], event['payload']);
    });
  }

  @override
  void dispose() {
    sl<BoardsBloc>().dispose();
    sl<ColumnsBloc>().dispose();
    sl<UsersBloc>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColumnsBloc columnsBloc = sl<ColumnsBloc>();
    return WillPopScope(
      onWillPop: () => AppRouter.pop(context),
      child: StreamBuilder(
        stream: columnsBloc.columnsListStream,
        builder: (context, columnsList) {
          if (columnsList.connectionState == ConnectionState.active &&
              columnsList.data != null) {
            return StreamBuilder(
              stream: columnsBloc.boardColumnsStream,
              builder: (context, list) {
                if (list.connectionState == ConnectionState.active &&
                    list.data != null) {
                  List<Widget> columnTabs = new List();
                  List<Widget> columnViews = [];
                  list.data.forEach((el) {
                    columnTabs.add(Tab(
                      text: el['name'],
                    ));

                    columnViews.add(BoardColumn(
                      column: el,
                    ));
                  });

                  return DefaultTabController(
                    length: columnTabs.length,
                    child: Container(
                      color: Colors.white,
                      child: SafeArea(
                          child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: Scaffold(
                          backgroundColor: Colors.blueGrey[50],
                          appBar: BoardAppBar(
                            columns: columnTabs,
                          ),
                          body: TabBarView(
                            children: columnViews,
                          ),
                          bottomNavigationBar: ApplicationBottomBar(),
                        ),
                      )),
                    ),
                  );
                }

                return LoadingScreen();
              },
            );
          }

          return LoadingScreen();
        },
      ),
    );
  }
}

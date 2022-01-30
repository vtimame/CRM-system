import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:oycrm/bloc/BoardScreen/CardsBloc.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/TasksBloc.dart';
import 'package:oycrm/main.dart';
import 'package:oycrm/ui/ApplicationBottomBar.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/widgets/TasksScreen/TasksBar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<TasksScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await sl<TasksBloc>().loadTasks();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    sl<TasksBloc>().loadTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TasksBloc tasksBloc = sl<TasksBloc>();

    return WillPopScope(
      onWillPop: () => AppRouter.pop(context),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: Scaffold(
              backgroundColor: Colors.blueGrey[50],
              appBar: TasksBar(),
              bottomNavigationBar: ApplicationBottomBar(),
              body: StreamBuilder(
                stream: tasksBloc.tasksListStream,
                builder: (context, list) {
                  if (list.connectionState == ConnectionState.active &&
                      list.data != null) {
                    print(list.data);
                    List<Widget> taskWidgets = _getTaskWidgets(list.data);

                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: taskWidgets,
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getTaskWidgets(list) {
    List<Widget> widgets = [];
    list.forEach((el) {
      widgets.add(SizedBox(
        width: double.infinity,
        child: GestureDetector(
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: UserAvatar(
                      userId: el['user_id'],
                      radius: 64,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          children: <Widget>[
                            Text(
                              '${el['render_type'] == 'call' ? 'Звонок' : 'Встреча'} по карточке ',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              '${sl<CardsBloc>().rawCardInstance(el['card_id'])['title']}',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Text(
                          '${el['event_dt']}',
                          style: TextStyle(fontSize: 13),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          child: Html(
                            data: el['comment_message'],
                            style: {
                              "p": Style(margin: EdgeInsets.all(0)),
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              color: Colors.white,
            ),
          ),
          onTap: () {
            sl<OpenedCardBloc>().loadCardInstance(el['card_id']);
            navigatorKey.currentState.pushNamed(AppRouter.openedCardScreen);
          },
        ),
      ));
      widgets.add(SizedBox(height: 4.0));
    });
    return widgets;
  }
}

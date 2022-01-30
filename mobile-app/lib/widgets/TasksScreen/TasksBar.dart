import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/bloc/TasksBloc.dart';
import 'package:oycrm/ui/NotificationsButton.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class TasksBar extends StatelessWidget implements PreferredSizeWidget {
  final List columns;
  TasksBar({Key key, this.columns}) : super(key: key);

  Size get preferredSize {
    return new Size.fromHeight(45.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Задачи',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'TTcommonsBold',
                        fontSize: 20.0),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _showFilterSheet(context),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Фильтр',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'TTcommonsBold',
                                  fontSize: 20.0),
                            ),
                            Icon(
                              Feather.chevron_down,
                              color: Colors.black87,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      NotificationsButton()
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(context) {
    final TasksBloc tasksBloc = sl<TasksBloc>();
    tasksBloc.unsetFilter();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.blueGrey[50]))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              'Фильтр',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        StreamBuilder(
                          stream: tasksBloc.tasksListStream,
                          builder: (context, list) {
                            if (list.connectionState ==
                                    ConnectionState.active &&
                                list != null) {
                              List<dynamic> users =
                                  _getFilterUsers(list.data).toSet().toList();

                              List<Widget> creatorsWidgets = [];
                              users.forEach((el) => creatorsWidgets.add(Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        tasksBloc.filterTasksByCreatorId(el);
                                        Navigator.pop(context);
                                      },
                                      child: UserAvatar(
                                        userId: el,
                                        borderColor: Colors.transparent,
                                      ),
                                    ),
                                  )));

                              if (users.length > 0) {
                                return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: creatorsWidgets,
                                      ),
                                    ));
                              } else {
                                return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                        'Похоже здесь нет ни одной задачи'));
                              }
                            } else {
                              return LinearProgressIndicator();
                            }
                          },
                        ),
                      ],
                    )),
              )
            ],
          );
        });
  }

  List<dynamic> _getFilterUsers(List<dynamic> tasks) {
    return tasks.map((e) => e['user_id']).toList();
  }
}

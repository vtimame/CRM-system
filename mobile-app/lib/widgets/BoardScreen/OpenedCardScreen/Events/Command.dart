import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:html/parser.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/EventsBloc.dart';
import 'package:oycrm/bloc/CommentBloc.dart';
import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/bloc/UsersBloc.dart';
import 'package:oycrm/ui/Button.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class Command extends StatelessWidget {
  final Map command;
  Command({this.command});

  final List<DropdownMenuItem> statuses = [
    DropdownMenuItem(
      value: 'waiting',
      child: Text('Выберите статус', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'resolve',
      child: Text('Завершено', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'reject',
      child: Text('Отклонено', style: TextStyle(fontSize: 13)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Map user = sl<UsersBloc>().userInstance(command['user_id']);

    String status = 'ожидание';
    Color statusColor = Colors.orange[50];
    switch (command['status']) {
      case 'resolve':
        status = 'завершено';
        statusColor = Colors.green;
        break;
      case 'reject':
        status = 'отклонено';
        statusColor = Colors.red;
        break;
      case 'waiting':
      default:
        status = 'ожидание';
        statusColor = Colors.orange;
        break;
    }

    var document = parse(command['comment_message']);
    document.getElementsByClassName('mention').forEach((el) {
      Map mentionUser =
          sl<UsersBloc>().userInstance(el.attributes['data-mention-id']);
      el.nodes[0].remove();
      el.nodes.insert(
          0,
          parseFragment(
              '<span><strong>@${mentionUser['surname']}</strong><strong>${mentionUser['name']}</strong></span>'));
    });

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserAvatar(userId: command['user_id']),
          SizedBox(width: 8.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '${user['surname']} ${user['name']}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 4.0),
                    Text(
                        'запланировал${user['sex'] == 0 ? '' : 'а '} ${command['render_type'] == 'call' ? 'звонок' : 'встречу'} на')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      command['event_dt'],
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(width: 4.0),
                    Text('($status)',
                        style: TextStyle(fontSize: 13, color: statusColor))
                  ],
                ),
                SizedBox(
                  height: 4.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.all(Radius.circular(3.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Html(
                        data: document.outerHtml,
                        style: {
                          "p": Style(margin: EdgeInsets.all(0)),
                        },
                      ),
                      command['report_message'] != null
                          ? Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.blueGrey[100]))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Отчет',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(command['report_message'])
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(command['created_at']),
                    SizedBox(width: 8.0),
                    command['status'] == 'waiting' &&
                            sl<UserBloc>().user.value['_id'] == user['_id']
                        ? GestureDetector(
                            onTap: () => _showCommandSheet(context),
                            child: Text(
                              'Завершить',
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        : Container()
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showCommandSheet(context) {
    sl<CommentBloc>().closeCommandSink.add(command);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              StreamBuilder(
                stream: sl<CommentBloc>().closeCommandStream,
                builder: (context, instance) {
                  if (instance.connectionState == ConnectionState.active &&
                      instance.data != null) {
                    String reportMessage =
                        instance.data['report_message'] ?? '';

                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.blueGrey[50]))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Text(
                                    'Завершить ${command['render_type'] == 'call' ? 'звонок' : 'встречу'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                        width: double.infinity,
                                        child: DropdownButton(
                                            value: instance.data['status'],
                                            isExpanded: true,
                                            onChanged: (value) =>
                                                sl<CommentBloc>()
                                                    .setCloseCommandField(
                                                        'status', value),
                                            items: statuses)),
                                    Text('Отчет'),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    _ReportField(
                                      onChanged: (value) => sl<CommentBloc>()
                                          .setCloseCommandField(
                                              'report_message', value),
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Button(
                                      text: 'Завершить',
                                      onPressed: reportMessage.length > 0 &&
                                              instance.data['status'] !=
                                                  'waiting'
                                          ? () {
                                              sl<CommentBloc>().closeCommand();
                                              sl<EventsBloc>().loadEvents(
                                                  command['card_id']);
                                              Navigator.pop(context);
                                            }
                                          : null,
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    );
                  } else
                    return Container();
                },
              )
            ],
          );
        });
  }
}

class _ReportField extends StatelessWidget {
  final Function onChanged;

  _ReportField({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 4,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey[100])),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue[300])),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey[100])),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      ),
    );
  }
}

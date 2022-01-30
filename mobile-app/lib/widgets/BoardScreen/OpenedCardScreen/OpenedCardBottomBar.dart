import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/EventsBloc.dart';
import 'package:oycrm/bloc/CommentBloc.dart';
import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/bloc/UsersBloc.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class OpenedCardBottomBar extends StatefulWidget {
  @override
  _OpenedCardBottomState createState() => _OpenedCardBottomState();
}

class _OpenedCardBottomState extends State<OpenedCardBottomBar> {
  bool showMentionList = false;

  final OpenedCardBloc openedCardBloc = sl<OpenedCardBloc>();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CommentBloc commentBloc = sl<CommentBloc>();

    return StreamBuilder(
      stream: sl<EventsBloc>().eventsStream,
      builder: (context, list) {
        if (list.connectionState == ConnectionState.active &&
            list.data != null) {
          Map card = sl<OpenedCardBloc>().openedCard.value;
          Map user = sl<UserBloc>().user.value;

          bool canAddCall = sl<UserBloc>().checkColumnPermission(
              card['board_id'], card['column_id'], 'add_calls');
          bool canAddMeeting = sl<UserBloc>().checkColumnPermission(
              card['board_id'], card['column_id'], 'add_meetings');
          var userActiveCalls =
              sl<EventsBloc>().userActiveCommands(user['_id'], 'call');
          var userActiveMeetings =
              sl<EventsBloc>().userActiveCommands(user['_id'], 'meeting');

          return Container(
            child: Wrap(
              children: <Widget>[
                _mentionsList(),
                StreamBuilder(
                  stream: commentBloc.typeStream,
                  builder: (context, type) {
                    if (type.connectionState == ConnectionState.active &&
                        type.data != null) {
                      if (type.data == 'comment')
                        return Container();
                      else {
                        String title = '';
                        switch (type.data) {
                          case "call":
                            title = 'Запланировать звонок';
                            break;
                          case "meeting":
                            title = 'Запланировать встречу';
                            break;
                          case "answer":
                            title = 'В ответ на комментарий';
                            break;
                          default:
                            title = '';
                            break;
                        }

                        return Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(title),
                                GestureDetector(
                                  onTap: () {
                                    sl<CommentBloc>().typeSink.add('comment');
                                    sl<CommentBloc>().parentIdSink.add(null);
                                  },
                                  child: Icon(
                                    Feather.x,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.blueGrey[50]))),
                        );
                      }
                    } else
                      return Container();
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: messageController,
                        minLines: 1,
                        maxLines: 4,
                        onChanged: (value) {
                          _listenComment(context);
                          commentBloc.messageSink.add(value);
                          commentBloc.sendTypingEvent();
                        },
                        decoration: InputDecoration(
                            hintText: 'Комментарий',
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0)),
                      ),
                    ),
                    canAddCall && userActiveCalls.length == 0
                        ? IconButton(
                            onPressed: () => _selectDate(context, 'call'),
                            icon: Icon(
                              Feather.phone,
                              size: 18,
                            ),
                          )
                        : Container(),
                    canAddMeeting && userActiveMeetings.length == 0
                        ? IconButton(
                            onPressed: () => _selectDate(context, 'meeting'),
                            icon: Icon(
                              Feather.users,
                              size: 18,
                            ),
                          )
                        : Container(),
                    IconButton(
                      onPressed: () {
                        _sendMessage();
                        messageController.clear();
                      },
                      icon: Icon(
                        Feather.send,
                        size: 18,
                      ),
                    )
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[300]))),
          );
        } else
          return Container();
      },
    );
  }

  Widget _mentionsList() {
    List membersIds = openedCardBloc.openedCard.value['members'];
    List<Widget> members = [];
    membersIds.forEach((id) {
      Map user = sl<UsersBloc>().userInstance(id);
      if (user != null)
        members.add(Material(
          child: InkWell(
            onTap: () => _setMention(user['alias']),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  UserAvatar(userId: id, radius: 28),
                  SizedBox(width: 4.0),
                  Text(
                    '${user['surname']} ${user['name']}',
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ));
    });

    return showMentionList
        ? SizedBox(
            width: double.infinity,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: members,
              ),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))),
            ),
          )
        : SizedBox();
  }

  void _listenComment(BuildContext context) {
    if (_userWantMention()) {
      setState(() {
        showMentionList = true;
      });
    } else {
      setState(() {
        showMentionList = false;
      });
    }
  }

  bool _userWantMention() {
    List<String> leftSection = _getLeftSectionOfMessage();
    String lastWord = leftSection[leftSection.length - 1];
    return lastWord.startsWith('@');
  }

  List<String> _getLeftSectionOfMessage() {
    String message = messageController.text;
    int selection = messageController.selection.baseOffset;
    String leftSectionOfMessage = message.substring(0, selection);
    return leftSectionOfMessage.split(' ');
  }

  List<String> _getRightSectionOfMessage() {
    String message = messageController.text;
    int selection = messageController.selection.baseOffset;
    String leftSectionOfMessage = message.substring(selection);
    return leftSectionOfMessage.split(' ');
  }

  void _setMention(String alias) {
    List<String> leftSection = _getLeftSectionOfMessage();
    List<String> rightSection = _getRightSectionOfMessage();
    leftSection[leftSection.length - 1] = '@$alias';
    _setMessage('${leftSection.join(' ')} ${rightSection.join(' ')}');
    messageController.selection = TextSelection.fromPosition(
        TextPosition(offset: leftSection.join(' ').length + 1));
    setState(() {
      showMentionList = false;
    });
  }

  void _setMessage(String message) {
    messageController.text = message;
    sl<CommentBloc>().messageSink.add(message);
  }

  void _sendMessage() {
    sl<CommentBloc>().sendMessage();
  }

  Future _selectDate(BuildContext context, String eventType) async {
    DateTime today = new DateTime.now();

    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: today.add(Duration(minutes: 20)),
        currentTime: today.add(Duration(minutes: 20)),
        locale: LocaleType.ru,
        onConfirm: (date) {
          sl<CommentBloc>().typeSink.add(eventType);
          sl<CommentBloc>().dateSink.add(date);
        },
        onCancel: () => print('canceled'));
  }
}

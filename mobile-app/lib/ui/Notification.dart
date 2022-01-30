import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/bloc/BoardScreen/CardsBloc.dart';
import 'package:oycrm/bloc/BoardScreen/ColumnsBloc.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/NotificationsBloc.dart';
import 'package:oycrm/bloc/UsersBloc.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class NotificationItem extends StatefulWidget {
  final Map notification;
  NotificationItem({this.notification});

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationItem> {
  bool _cardLoading = false;
  Map _card;
  Map _initiator;

  @override
  void initState() {
    _card = sl<CardsBloc>()
        .rawCardInstance(widget.notification['event']['card_id']);
    _initiator = sl<UsersBloc>()
        .userInstance(widget.notification['event']['initiator_id']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: widget.notification['read_at'] == null
                    ? Colors.yellow[50]
                    : Colors.transparent,
                border: Border(bottom: BorderSide(color: Colors.blueGrey[50]))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: _getNotificationImage(),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_getNotificationBody() ?? 'test'),
//                        Text(widget.notification['event']['card_id']),
//                        Text(sl<CardsBloc>().rawCardInstance(
//                            widget.notification['event']['card_id'])['title'])
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: _cardLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[300],
                    minHeight: 1.0,
                  )
                : null,
          )
        ],
      ),
      onTap: () => _loadCard(),
    );
  }

  Widget _getNotificationImage() {
    if (widget.notification['event']['type'] == 'userMustCall' ||
        widget.notification['event']['type'] == 'userMustMeeting') {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child: Icon(
          widget.notification['event']['type'] == 'userMustCall'
              ? Feather.phone
              : Feather.users,
          color: Colors.black87,
          size: 20,
        ),
      );
    } else if (_initiator == null) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child: Icon(
          Feather.bell,
          color: Colors.black87,
          size: 20,
        ),
      );
    } else {
      return UserAvatar(
        radius: 64,
        userId: _initiator['_id'],
      );
    }
  }

  _getNotificationBody() {
    String message = '';

    switch (widget.notification['event']['type']) {
      case "cardCommentWasAdded":
        message = _cardCommentWasAdded();
        break;
      case "cardAnswerWasAdded":
        message = _cardAnswerWasAdded();
        break;
      case "cardContactWasAdded":
        message = _cardContactWasAdded();
        break;
      case "cardMemberWasAdded":
        message = _cardMemberWasAdded();
        break;
      case "cardMentionWasAdded":
        message = _cardMentionWasAdded();
        break;
      case "userMustCall":
        message = _userMustCall();
        break;
      case "userMustMeeting":
        message = _userMustMeeting();
        break;
      case "remindCardActivity":
        message = _remindCardActivity();
        break;
      case "reportExpiredEvents":
        message = _reportExpiredEvents();
        break;
      case "newSiteTicket":
        message = _newSiteTicket();
        break;
      case "cardWasMoved":
        message = _cardWasMoved();
        break;
      default:
        message = "Произошло что-то странное";
        break;
    }

    return message;
  }

  String _cardCommentWasAdded() {
    return '${_initiator != null ? _initiator['surname'] : ''} ${_initiator != null ? _initiator['name'] : ''} оставил комментарий в карточке ${sl<CardsBloc>().rawCardInstance(widget.notification['event']['card_id'])['title']}';
  }

  String _remindCardActivity() {
    return 'В карточке ${_card['title']} за последние 24 часа не было изменений';
  }

  String _cardAnswerWasAdded() {
    return '${_initiator != null ? _initiator['surname'] : ''} ${_initiator != null ? _initiator['name'] : ''} ответил на ваш комментарий в карточке ${sl<CardsBloc>().rawCardInstance(widget.notification['event']['card_id'])['title']}';
  }

  String _cardContactWasAdded() {
    return '${_initiator != null ? _initiator['surname'] : ''} ${_initiator != null ? _initiator['name'] : ''} добавил новый контакт в карточке ${sl<CardsBloc>().rawCardInstance(widget.notification['event']['card_id'])['title']}';
  }

  String _cardMemberWasAdded() {
    return '${_initiator != null ? _initiator['surname'] : ''} ${_initiator != null ? _initiator['name'] : ''} добавил вас в карточку ${sl<CardsBloc>().rawCardInstance(widget.notification['event']['card_id'])['title']}';
  }

  String _cardMentionWasAdded() {
    return '${_initiator != null ? _initiator['surname'] : ''} ${_initiator != null ? _initiator['name'] : ''} упомянул вас в карточке ${sl<CardsBloc>().rawCardInstance(widget.notification['event']['card_id'])['title']}';
  }

  String _userMustCall() {
    return 'У вас запланирован звонок по карточке ${sl<CardsBloc>().rawCardInstance(widget.notification['event']['card_id'])['title']}';
  }

  String _userMustMeeting() {
    return 'У вас запланирована встреча по карточке ${sl<CardsBloc>().rawCardInstance(widget.notification['event']['card_id'])['title']}';
  }

  String _reportExpiredEvents() {
    return '${_initiator != null ? _initiator['surname'] : ''} ${_initiator != null ? _initiator['name'] : ''} просрочил${_initiator != null ? _initiator['sex'] == 0 ? "" : "а" : ""} ${widget.notification['event']['command_type'] == "call" ? "звонок" : "встречу"}';
  }

  String _newSiteTicket() {
    return 'На вас назначена заявка ${sl<CardsBloc>().rawCardInstance(widget.notification['event']['card_id'])['title']}';
  }

  String _cardWasMoved() {
    var oldColumn = sl<ColumnsBloc>()
        .rawColumnInstance(widget.notification['event']['old_column_id']);
    var newColumn = sl<ColumnsBloc>()
        .rawColumnInstance(widget.notification['event']['new_column_id']);
    return "${_initiator != null ? _initiator['surname'] : ''} ${_initiator != null ? _initiator['name'] : ''} переместил карточку ${_card['title']} из ${oldColumn != null ? oldColumn['name'] : ''}  в ${newColumn != null ? newColumn['name'] : ''}";
  }

  Future _loadCard() async {
    if (!_cardLoading) {
      setState(() {
        _cardLoading = true;
      });
      await sl<OpenedCardBloc>().loadCardInstance(sl<CardsBloc>()
          .rawCardInstance(widget.notification['event']['card_id'])['_id']);
      setState(() {
        _cardLoading = false;
      });
      AppRouter.push(context, AppRouter.openedCardScreen);
    }
  }
}

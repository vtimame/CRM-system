import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/EventsBloc.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/SocketConnection.dart';

class ColumnCard extends StatelessWidget {
  final Map card;
  ColumnCard({this.card});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                renderTitle(),
                renderAddress(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    renderCounters(),
                    renderMembers(),
                  ],
                )
              ],
            ),
          ),
          onTap: () {
            openCard(context);
            connectToSocketChannel(card['_id']);
          },
        ));
  }

  Future connectToSocketChannel(String cardId) async {
    sl<SocketConnection>().echo.join('card.$cardId').here((users) {
//      print(users);
    }).joining((user) {
//      print(user);
    }).leaving((user) {
//      print(user);
    });

    sl<SocketConnection>().echo.private('card.$cardId').listen(
        '.client-eventWasAdded', (event) => sl<EventsBloc>().pushEvent(event));
  }

  Future openCard(BuildContext context) async {
    await sl<OpenedCardBloc>().loadCardInstance(card['_id']);
    AppRouter.push(context, AppRouter.openedCardScreen);
  }

  Widget renderTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
      child: Text(
        card['title'] ?? 'Неизвестная карточка',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
      ),
    );
  }

  Widget renderAddress() {
    String address = 'Адрес не указан';
    if (card['address'] != null) {
      address = '${card['address']['street']} ${card['address']['street_num']}';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        address,
        style: TextStyle(fontSize: 13.0, color: Colors.grey[700]),
      ),
    );
  }

  Widget renderCounters() {
    List<Widget> counters = [];

    if (card['attachments'] != null) {
      counters.add(Row(
        children: <Widget>[
          Icon(
            Feather.paperclip,
            size: 16,
          ),
          SizedBox(
            width: 4.0,
          ),
          Text('${card['attachments'].length.toString()}'),
          SizedBox(
            width: 8.0,
          )
        ],
      ));
    }

    if (card['comments_count'] != null && card['comments_count'] > 0) {
      counters.add(Row(
        children: <Widget>[
          Icon(
            Feather.message_circle,
            size: 18,
          ),
          SizedBox(
            width: 4.0,
          ),
          Text('${card['comments_count'].toString()}'),
          SizedBox(
            width: 8.0,
          )
        ],
      ));
    }

    if (card['waiting_calls'] != null && card['waiting_calls'].length > 0) {
      counters.add(Row(
        children: <Widget>[
          Icon(
            Feather.phone,
            size: 18,
          ),
          SizedBox(
            width: 4.0,
          ),
          Text('${card['waiting_calls'].length.toString()}'),
          SizedBox(
            width: 8.0,
          )
        ],
      ));
    }

    if (card['waiting_meetings'] != null &&
        card['waiting_meetings'].length > 0) {
      counters.add(Row(
        children: <Widget>[
          Icon(
            Feather.users,
            size: 18,
          ),
          SizedBox(
            width: 4.0,
          ),
          Text('${card['waiting_meetings'].length.toString()}'),
          SizedBox(
            width: 8.0,
          )
        ],
      ));
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: counters,
        ));
  }

  Widget renderMembers() {
    int membersLength = card['members'].length;
    List<Widget> avatars = [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
        child: UserAvatar(
          userId: card['creator_id'],
        ),
      ),
    ];

    if (membersLength > 0) {
      avatars.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: CircleAvatar(
          backgroundColor: Colors.blueGrey[50],
          radius: 20.0,
          child: Text('+${(membersLength).toString()}',
              style: TextStyle(color: Colors.grey[800])),
        ),
      ));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: avatars,
      ),
    );
  }
}

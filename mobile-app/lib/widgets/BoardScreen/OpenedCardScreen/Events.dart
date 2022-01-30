import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/EventsBloc.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/Events/Command.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/Events/Comment.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  void initState() {
    _loadEvents();
    super.initState();
  }

  void _loadEvents() {
    String cardId = sl<OpenedCardBloc>().openedCard.value["_id"];
    sl<EventsBloc>().loadEvents(cardId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 8.0),
        Text(
          'Комментарии',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.0),
        StreamBuilder(
          stream: sl<EventsBloc>().eventsStream,
          builder: (context, list) {
            if (list.connectionState == ConnectionState.active &&
                list.data != null) {
              List<Widget> eventsViews = [];
              list.data.forEach((el) {
                if (el['render_type'] == 'comment') {
                  eventsViews.add(Comment(
                    comment: el,
                  ));
                }

                if (el['render_type'] == 'call' ||
                    el['render_type'] == 'meeting') {
                  eventsViews.add(Command(
                    command: el,
                  ));
                }
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: eventsViews,
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        )
      ],
    );
  }
}

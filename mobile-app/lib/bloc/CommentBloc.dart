import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/repositories/EventRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/SocketConnection.dart';
import 'package:oycrm/utils/TipTap.dart';
import 'package:rxdart/rxdart.dart';

import 'BoardScreen/OpenedCardScreen/EventsBloc.dart';

class CommentBloc {
  final _type = BehaviorSubject<String>.seeded('comment');
  final _message = BehaviorSubject<String>.seeded('');
  final _parentId = BehaviorSubject<String>.seeded(null);
  final _date = BehaviorSubject<DateTime>.seeded(null);
  final _closeCommand = BehaviorSubject<Map>.seeded(null);

  Stream get closeCommandStream => _closeCommand.stream;
  Sink get closeCommandSink => _closeCommand.sink;

  Stream get parentIdStream => _parentId.stream;
  Sink get parentIdSink => _parentId.sink;

  Stream get messageStream => _message.stream;
  Sink get messageSink => _message.sink;

  Stream get dateStream => _date.stream;
  Sink get dateSink => _date.sink;

  Stream get typeStream => _type.stream;
  Sink get typeSink => _type.sink;

  Future sendMessage() async {
    Map jsonMessage = TipTap.buildJsonMessage(_message.value);
    Map card = sl<OpenedCardBloc>().openedCard.value;
    Map data = {};
    if (_message.value.length > 0) {
      data.putIfAbsent('card_id', () => card['_id']);
      data.putIfAbsent('parent_id', () => _parentId.value);
      data.putIfAbsent('children', () => []);
      data.putIfAbsent('render_type',
          () => _type.value == 'answer' ? 'comment' : _type.value);

      if (_type.value == 'comment' || _type.value == 'answer') {
        data.putIfAbsent('json_message', () => jsonMessage);
      }

      if (_type.value == 'call' || _type.value == 'meeting') {
        data.putIfAbsent('comment_message', () => '<p>${_message.value}</p>');
        data.putIfAbsent('event_dt', () => _date.value.toString());
        data.putIfAbsent('command_type', () => _type.value);
        data.putIfAbsent('status', () => 'waiting');
      }

      try {
        Map result = await sl<EventRepository>().store(data);
        sl<EventsBloc>().pushEvent(result);
        _pushToPrivateChannel(result, card['_id'], 'eventWasAdded');
      } catch (e) {
        print(e);
      }
    }

    messageSink.add('');
    typeSink.add('comment');
    parentIdSink.add(null);
  }

  void setCloseCommandField(String key, String value) {
    Map command = _closeCommand.value;
    command[key] = value;
    closeCommandSink.add(command);
  }

  Future closeCommand() async {
    Map data = _closeCommand.value;
    try {
      await sl<EventRepository>().update(data);
    } catch (e) {
      print(e);
    }
  }

  void sendTypingEvent() {
    Map user = sl<UserBloc>().user.value;
    Map card = sl<OpenedCardBloc>().openedCard.value;
    _pushToPrivateChannel(user, card['_id'], 'typing');
  }

  void _pushToPrivateChannel(Map data, String cardId, String eventName) {
    sl<SocketConnection>().pushToPrivate('card.$cardId', eventName, data);
  }

  void dispose() {
    _parentId.close();
    _closeCommand.close();
    _type.close();
    _message.close();
    _date.close();
  }
}

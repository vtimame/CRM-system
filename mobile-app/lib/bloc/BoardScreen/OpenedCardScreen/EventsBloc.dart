import 'package:oycrm/repositories/EventRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final _events = BehaviorSubject<List>.seeded(null);

  Stream get eventsStream => _events.stream;
  Sink get eventsSink => _events.sink;

  Future loadEvents(String cardId) async {
    List events = await sl<EventRepository>().loadEvents(cardId);
    eventsSink.add(events);
  }

  eventInstance(String eventId) {
    return _events.value.firstWhere((el) => el['_id'] == eventId);
  }

  userActiveCommands(String userId, String type) {
    return _events.value.where((el) =>
        el['user_id'] == userId &&
        el['render_type'] == type &&
        el['status'] == 'waiting');
  }

  void pushEvent(Map event) {
    if (event['parent_id'] == null) {
      List events = [];
      events.add(event);
      events.addAll(_events.value);
      eventsSink.add(events);
    } else {
      int parentIndex =
          _events.value.indexWhere((el) => el['_id'] == event['parent_id']);
      if (parentIndex != -1) {
        List newList = _events.value;
        newList[parentIndex]['children'].add(event);
        eventsSink.add(newList);
      }
    }
  }

  void updateEvent(Map event) {
    int index = _events.value.indexWhere((el) => el['_id'] == event['_id']);
    print(index);
    if (index != -1) {
      List newList = _events.value;
      newList[index] = event;
      eventsSink.add(newList);
    }
  }

  void dispose() {
    _events.close();
  }
}

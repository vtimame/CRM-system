import 'package:dio/dio.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';

class EventRepository {
  Future loadEvents(String cardId) async {
    try {
      Response events = await sl<Http>().get('kanban/cards/$cardId/events');
      return events.data;
    } catch (e) {
      print(e.response);
    }
  }

  Future store(Map event) async {
    try {
      Response result = await sl<Http>()
          .post('kanban/cards/${event['card_id']}/events', data: event);
      return result.data;
    } catch (e) {
      print(e);
    }
  }

  Future update(Map event) async {
    try {
      Response result = await sl<Http>().put(
          'kanban/cards/${event['card_id']}/events/${event['_id']}',
          data: event);
      return result.data;
    } catch (e) {
      print(e);
    }
  }
}

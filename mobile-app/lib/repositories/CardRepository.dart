import 'package:dio/dio.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';

class CardRepository {
  Future loadCardsByBoardId(String boardId) async {
    try {
      Response cards = await sl<Http>()
          .get('kanban/cards', queryParameters: {"board_id": boardId});
      return cards.data;
    } catch (e) {
      print(e);
    }
  }

  Future loadRawCards() async {
    try {
      Response cards = await sl<Http>().get('kanban/raw/cards');
      return cards.data;
    } catch (e) {
      print(e);
    }
  }

  Future find(String cardId) async {
    try {
      Response card = await sl<Http>().get('kanban/cards/$cardId');
      return card.data;
    } catch (e) {
      print(e);
    }
  }

  Future update(String cardId, Map payload) async {
    try {
      Response result =
          await sl<Http>().put('kanban/cards/$cardId', data: payload);
      return result.data;
    } catch (e) {
      print(e);
    }
  }

  Future storeContact(String cardId, Map payload) async {
    try {
      Response result =
          await sl<Http>().post('kanban/cards/$cardId/contact', data: payload);
      return result.data;
    } catch (e) {
      print(e);
    }
  }
}

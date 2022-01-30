import 'package:oycrm/repositories/CardRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/SocketConnection.dart';
import 'package:rxdart/rxdart.dart';

class OpenedCardBloc {
  final _openedCard = BehaviorSubject<Map>.seeded(null);
  final _events = BehaviorSubject<List>.seeded(null);

  BehaviorSubject get openedCard => _openedCard;

  Stream get openedCardStream => _openedCard.stream;
  Stream get eventsStream => _events.stream;

  Sink get openedCardSink => _openedCard.sink;
  Sink get eventsSink => _events.sink;

  Future loadCardInstance(String cardId) async {
    try {
      Map card = await sl<CardRepository>().find(cardId);
      openedCardSink.add(card);
    } catch (e) {
      print(e);
    }
  }

  Future update(String key, dynamic value) async {
    Map card = openedCard.value;
    try {
      await sl<CardRepository>().update(card['_id'], {key: value});
      List<String> explodeKey = key.split('.');
      sl<SocketConnection>()
          .pushToPrivate('board.${card['board_id']}', 'setCardData', {
        "card_id": card['_id'],
        "payload": {key: value}
      });
      addToSink(explodeKey, value);
    } catch (e) {
      print(e);
    }
  }

  Future storeContact(Map contact) async {
    Map card = openedCard.value;
    try {
      var result =
          await sl<CardRepository>().storeContact(card['_id'], contact);
      addContactToSink(result);
    } catch (e) {
      print(e);
    }
  }

  void addContactToSink(Map contact) {
    Map card = openedCard.value;
    card['contacts'].add(contact);
    openedCardSink.add(card);
  }

  void addToSink(List explodeKey, dynamic value) {
    Map card = openedCard.value;
    explodeKey.asMap().containsKey(1)
        ? card[explodeKey[0]][explodeKey[1]] = value
        : card[explodeKey[0]] = value;
    openedCardSink.add(card);
  }

  void dispose() {
    _openedCard.close();
    _events.close();
  }
}

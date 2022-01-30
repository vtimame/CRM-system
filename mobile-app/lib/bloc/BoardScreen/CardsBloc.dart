import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/repositories/CardRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:rxdart/rxdart.dart';

class CardsBloc {
  String _creatorId;
  List _fullCardsList;

  final _cardsList = BehaviorSubject<List>.seeded(null);
  final _rawCardsList = BehaviorSubject<List>.seeded(null);

  Stream get cardsListStream => _cardsList.stream;
  Sink get cardsListSink => _cardsList.sink;

  Stream get rawCardsListStream => _rawCardsList.stream;
  Sink get rawCardsListSink => _rawCardsList.sink;

  Future loadCards(String boardId) async {
    try {
      List cards = await sl<CardRepository>().loadCardsByBoardId(boardId);
      _fullCardsList = cards;
      cardsListSink.add(cards);
    } catch (e) {
      print(e);
    }
  }

  void unsetFilter() {
    _creatorId = null;
    cardsListSink.add(_fullCardsList);
  }

  void filterCardsByCreatorId(String creatorId) {
    if (_creatorId == creatorId) {
      cardsListSink.add(_fullCardsList);
    } else {
      _creatorId = creatorId;
      List list =
          _fullCardsList.where((el) => el['creator_id'] == creatorId).toList();
      cardsListSink.add(list);
    }
  }

  Future loadRawCards() async {
    try {
      List cards = await sl<CardRepository>().loadRawCards();
      rawCardsListSink.add(cards);
    } catch (e) {
      print(e);
    }
  }

  Map rawCardInstance(String id) {
    return _rawCardsList.value
        .firstWhere((el) => el['_id'] == id, orElse: () => null);
  }

  List columnCards(String columnId) {
    return _cardsList.value.where((el) => el['column_id'] == columnId).toList();
  }

  Future updateCard(String cardId, Map payload) async {
    List cards = _cardsList.value;
    Map currentCard = sl<OpenedCardBloc>().openedCard.value;
    int cardIndex = cards.indexWhere((el) => el['_id'] == cardId);
    if (cardIndex != -1) {
      List<String> payloadKeys = payload.keys.toList();
      payloadKeys.forEach((key) {
        List<String> explodedKey = key.split('.');
        explodedKey.asMap().containsKey(1)
            ? cards[cardIndex][explodedKey[0]][explodedKey[1]] = payload[key]
            : cards[cardIndex][explodedKey[0]] = payload[key];
        if (currentCard != null && cardId == currentCard['_id']) {
          sl<OpenedCardBloc>().addToSink(explodedKey, payload[key]);
        }
      });
      cardsListSink.add(cards);
    }
  }

  void dispatch() {
    _cardsList.close();
    _rawCardsList.close();
  }
}

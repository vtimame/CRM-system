import 'package:oycrm/bloc/BoardScreen/CardsBloc.dart';
import 'package:oycrm/bloc/BoardScreen/ColumnsBloc.dart';
import 'package:oycrm/repositories/BoardRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/SocketConnection.dart';
import 'package:rxdart/rxdart.dart';

class BoardsBloc {
  final _boardsList = BehaviorSubject<List>.seeded([]);
  final _currentBoard = BehaviorSubject<Map>.seeded(null);

  Stream get boardsListStream => _boardsList.stream;
  Stream get currentBoardStream => _currentBoard.stream;

  Sink get boardsListSink => _boardsList.sink;
  Sink get currentBoardSink => _currentBoard.sink;

  BehaviorSubject<Map> get currentBoard => _currentBoard;

  Future loadBoards() async {
    try {
      List boards = await sl<BoardRepository>().loadBoards();
      currentBoardSink.add(boards[0]);
      boardsListSink.add(boards);
      sl<ColumnsBloc>().loadBoardColumns(boards[0]['_id']);
      sl<CardsBloc>().loadCards(boards[0]['_id']);
    } catch (e) {
      print(e);
    }
  }

  Future setCurrentBoard(Map board) async {
    String currentId = _currentBoard.value['_id'];
    sl<SocketConnection>().echo.leave('board.$currentId');
    sl<SocketConnection>().echo.join('board.${board['_id']}').here((users) {
//      print(users);
    }).joining((user) {
//      print(user);
    }).leaving((user) {
//      print(user);
    });

    sl<SocketConnection>()
        .echo
        .private('board.${board['_id']}')
        .listen('.client-setCardData', (event) {
      sl<CardsBloc>().updateCard(event['card_id'], event['payload']);
    });

    currentBoardSink.add(board);
    sl<ColumnsBloc>().loadBoardColumns(board['_id']);
    sl<CardsBloc>().loadCards(board['_id']);
  }

  void dispose() {
    _boardsList.close();
    _currentBoard.close();
  }
}

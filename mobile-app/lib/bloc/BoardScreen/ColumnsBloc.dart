import 'package:oycrm/repositories/ColumnRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:rxdart/rxdart.dart';

class ColumnsBloc {
  final _columnsList = BehaviorSubject<List>.seeded(null);
  final _rawColumnsList = BehaviorSubject<List>.seeded(null);
  final _boardColumns = BehaviorSubject<List>.seeded(null);

  BehaviorSubject get boardColumnsList => _boardColumns;

  Stream get columnsListStream => _columnsList.stream;
  Stream get rawColumnsListStream => _rawColumnsList.stream;
  Stream get boardColumnsStream => _boardColumns.stream;

  Sink get columnsListSink => _columnsList.sink;
  Sink get rawColumnsListSink => _rawColumnsList.sink;
  Sink get boardColumnsSink => _boardColumns.sink;

  boardColumns(String boardId) {
    return _columnsList.value.where((el) => el['board_id'] == boardId).toList();
  }

  void loadBoardColumns(String boardId) {
    boardColumnsSink.add(boardColumns(boardId));
  }

  Future loadColumns() async {
    try {
      List columns = await sl<ColumnRepository>().loadColumns();
      columnsListSink.add(columns);
    } catch (e) {
      print(e);
    }
  }

  Map rawColumnInstance(String id) {
    return _rawColumnsList.value
        .firstWhere((el) => el['_id'] == id, orElse: () => null);
  }

  Future loadRawColumns() async {
    try {
      List columns = await sl<ColumnRepository>().loadRawColumns();
      rawColumnsListSink.add(columns);
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    _columnsList.close();
    _boardColumns.close();
    _rawColumnsList.close();
  }
}

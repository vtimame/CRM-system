import 'package:dio/dio.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';

class BoardRepository {
  Future loadBoards() async {
    try {
      Response boards = await sl<Http>().get('kanban/boards');
      return boards.data;
    } catch (e) {
      print(e);
    }
  }
}

import 'package:dio/dio.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';

class ColumnRepository {
  Future loadColumns() async {
    try {
      Response columns = await sl<Http>().get('kanban/columns');
      return columns.data;
    } catch (e) {
      print(e);
    }
  }

  Future loadRawColumns() async {
    try {
      Response columns = await sl<Http>().get('kanban/raw-columns');
      return columns.data;
    } catch (e) {
      print(e);
    }
  }
}

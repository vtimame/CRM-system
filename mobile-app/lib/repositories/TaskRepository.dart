import 'package:dio/dio.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';

class TaskRepository {
  Future loadTasks() async {
    try {
      Response tasks = await sl<Http>().get('user/actions');
      return tasks.data;
    } catch (e) {
      print(e);
    }
  }
}

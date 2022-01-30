import 'package:oycrm/repositories/TaskRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:rxdart/rxdart.dart';

class TasksBloc {
  String _userId;
  var _fullTasksList;

  final _tasksList = BehaviorSubject<List>.seeded(null);

  Stream get tasksListStream => _tasksList.stream;
  Sink get tasksListSink => _tasksList.sink;

  Future loadTasks() async {
    try {
      var tasks = await sl<TaskRepository>().loadTasks();
      _fullTasksList = tasks;
      tasksListSink.add(tasks);
    } catch (e) {
      print(e);
    }
  }

  void unsetFilter() {
    _userId = null;
    tasksListSink.add(_fullTasksList);
  }

  void filterTasksByCreatorId(String userId) {
    print(userId);
    if (_userId == userId) {
      tasksListSink.add(_fullTasksList);
    } else {
      _userId = userId;
      List list =
          _fullTasksList.where((el) => el['user_id'] == userId).toList();
      tasksListSink.add(list);
    }
  }

  void dispose() {
    _tasksList.close();
  }
}

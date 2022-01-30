import 'package:dio/dio.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc {
  final _user = BehaviorSubject<Map>.seeded(null);
  final _token = BehaviorSubject<String>.seeded(null);
  final _permissions = BehaviorSubject<Map>.seeded(null);

  BehaviorSubject get token => _token;
  BehaviorSubject get user => _user;

  Stream get userStream => _user.stream;
  Stream get tokenStream => _token.stream;
  Stream get permissionsStream => _permissions.stream;

  Sink get userSink => _user.sink;
  Sink get tokenSink => _token.sink;
  Sink get permissionsSink => _permissions.sink;

  Future loadUser() async {
    try {
      Response response = await sl<Http>().get('auth/user');
      userSink.add(response.data['user']);
      permissionsSink.add(response.data['permissions']);
    } catch (e) {
      print(e);
    }
  }

  bool checkColumnPermission(String boardId, String columnId, String name) {
    if (_permissions.value['columns'] == null) return false;
    Map column = _permissions.value['columns'].firstWhere(
        (el) => el['board_id'] == boardId && el['column_id'] == columnId);
    if (column == null || column['scope'] == null) return false;
    return column['scope'].contains(name);
  }

  Future logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      await sl<Http>().post('auth/logout');
      userSink.add(null);
      tokenSink.add(null);
      permissionsSink.add(null);
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    _user.close();
    _token.close();
    _permissions.close();
  }
}

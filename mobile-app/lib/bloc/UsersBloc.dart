import 'package:oycrm/repositories/UserRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:rxdart/rxdart.dart';

class UsersBloc {
  final _usersList = BehaviorSubject<List>.seeded(null);

  Stream get usersListStream => _usersList.stream;
  Sink get usersListSink => _usersList.sink;

  Future loadUsers() async {
    try {
      List users = await sl<UserRepository>().findAll();
      usersListSink.add(users);
    } catch (e) {
      print(e);
    }
  }

  userInstance(String userId) {
    return _usersList.value
        .firstWhere((el) => el['_id'] == userId, orElse: () => null);
  }

  userInstanceByAlias(String alias) {
    return _usersList.value
        .firstWhere((el) => el['alias'] == alias, orElse: () => null);
  }

  void dispose() {
    _usersList.close();
  }
}

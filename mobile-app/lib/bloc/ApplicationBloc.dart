import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/SocketConnection.dart';
import 'package:oycrm/utils/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationBloc {
  final _applicationIsLoaded = BehaviorSubject<bool>.seeded(false);

  Stream get loadedStateStream => _applicationIsLoaded.stream;
  Sink get loadedStateSink => _applicationIsLoaded.sink;

  Future prepareApplication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') != null) {
      sl<Http>().setBearerToken(prefs.getString('token'));
      sl<UserBloc>().tokenSink.add(prefs.getString('token'));
      await sl<UserBloc>().loadUser();
      await sl<SocketConnection>().init(prefs.getString('token'));
    }

    loadedStateSink.add(true);
  }

  void dispose() {
    _applicationIsLoaded.close();
  }
}

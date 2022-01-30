import 'package:rxdart/rxdart.dart';

class LoginModeBloc {
  final _loginMode = BehaviorSubject<String>.seeded(null);

  Stream get loginModeStream => _loginMode.stream;
  Sink get loginModeSink => _loginMode.sink;

  void dispose() {
    _loginMode.close();
  }
}

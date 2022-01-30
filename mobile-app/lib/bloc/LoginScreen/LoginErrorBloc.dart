import 'package:rxdart/rxdart.dart';

class LoginErrorBloc {
  final _error = BehaviorSubject<String>.seeded(null);

  Stream get errorStream => _error.stream;
  Sink get errorSink => _error.sink;

  void dispose() {
    _error.close();
  }
}

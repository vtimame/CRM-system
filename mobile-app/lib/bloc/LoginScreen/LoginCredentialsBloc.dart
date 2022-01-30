import 'package:dio/dio.dart';
import 'package:oycrm/bloc/LoginScreen/LoginErrorBloc.dart';
import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/SocketConnection.dart';
import 'package:oycrm/utils/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCredentialsBloc {
  final loginCredentials = BehaviorSubject<Map>.seeded({
    'mobile_phone': '',
    'password': '',
    'mobilePhoneIsChecked': false,
    "firebaseToken": ''
  });

  Stream get loginCredentialsStream => loginCredentials.stream;
  Sink get loginCredentialsSink => loginCredentials.sink;
  Map get credentials => loginCredentials.value;

  void setField(key, value) {
    sl<LoginErrorBloc>().errorSink.add(null);
    Map snapshot = credentials;
    snapshot[key] = value;
    loginCredentialsSink.add(snapshot);
  }

  Future onFormSubmit() async {
    credentials['mobilePhoneIsChecked'] ? await login() : await findUser();
  }

  Future findUser() async {
    try {
      await sl<Http>().get('auth/login',
          queryParameters: {"login": credentials['mobile_phone']});
      setField('mobilePhoneIsChecked', true);
    } catch (e) {
      if (e.response.statusCode == 422 || e.response.statusCode == 404) {
        sl<LoginErrorBloc>().errorSink.add('Пользователь не найден');
      }
    }
  }

  Future login() async {
    try {
      Response login = await sl<Http>().post('auth/login', queryParameters: {
        "login": credentials['mobile_phone'],
        "password": credentials['password'],
        "firebaseToken": credentials['firebaseToken']
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', login.data['token']);

      sl<UserBloc>().userSink.add(login.data['user']);
      sl<UserBloc>().tokenSink.add(login.data['token']);
      sl<UserBloc>().permissionsSink.add(login.data['permissions']);
      sl<Http>().setBearerToken(login.data['token']);
      await sl<SocketConnection>().init(login.data['token']);
    } catch (e) {
      if (e.response.statusCode == 401) {
        sl<LoginErrorBloc>().errorSink.add('Неверный пин-код');
      }
    }
  }

  Future loginWithQR(credentials) async {
    setField('mobile_phone', credentials['login']);
    setField('password', credentials['password']);
    await login();
  }

  void dispose() {
    loginCredentials.close();
  }
}

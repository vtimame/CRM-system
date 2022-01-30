import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';

class Http extends DioForNative {
  Http([BaseOptions options]) : super(options) {
    this
        .interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
          if (_token != null)
            options.headers['Authorization'] = 'Bearer $_token';
          if (_socketId != null) options.headers['X-Socket-ID'] = _socketId;
          return options;
        }, onResponse: (Response response) async {
          return response;
        }, onError: (DioError e) async {
          return e;
        }));
  }

  String _socketId;
  String _token;

  Future<void> setBearerToken(token) async {
    _token = token;
  }

  Future<void> setSocketId(id) async {
    _socketId = id;
  }
}

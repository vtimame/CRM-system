import 'package:dio/dio.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';

class UserRepository {
  Future findAll() async {
    try {
      Response users = await sl<Http>().get('users');
      return users.data;
    } catch (e) {
      throw e;
    }
  }
}

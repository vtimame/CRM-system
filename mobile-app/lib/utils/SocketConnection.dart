import 'package:laravel_echo/laravel_echo.dart';
import 'package:oycrm/config.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketConnection {
  Echo _echo;

  Echo get echo => _echo;

  Future init(String token) async {
    await _createEchoInstance(token);
    _echo.socket.on('connect', (_) {
      sl<Http>().setSocketId(_echo.sockedId());
      print('connected');
    });
    _echo.socket.on('disconnect', (_) => print('disconnected'));
  }

  Future _createEchoInstance(String token) async {
    try {
      _echo = new Echo({
        "broadcaster": 'socket.io',
        "client": IO.io,
        "host": Config.socketUrl,
        "auth": {
          "headers": {"Authorization": 'Bearer $token'}
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future pushToPrivate(String channel, String eventName, Map data) async {
    _echo.socket.emit('client event', {
      "channel": 'private-$channel',
      "event": "client-$eventName",
      "data": data
    });
  }
}

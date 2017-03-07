package ohm.client;

//import npm.socketio.Socket;

class Main {
  public static function main() {
    var socket : Dynamic = untyped __js__("io")('/');
    socket.on('message', function(data) {
      trace('mesasge from server', data);
    });
  }
}

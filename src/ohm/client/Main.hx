package ohm.client;

import npm.socketio.client.IO;
import npm.socketio.client.Socket;

class Main {
  public static function main() {
    var socket : Socket = IO.io('/');
    socket.on('message', function(data) {
      trace('mesasge from server', data);
    });
  }
}

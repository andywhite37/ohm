package ohm.server;

import js.node.Http;

import express.Express;

import npm.socketio.Server;
import npm.socketio.Socket;

class Main {
  public static function main() {
    var port = 8080;

    var app = new Express();
    var server = Http.createServer(cast app);
    var io = new npm.socketio.Server(server);

    app.use(Express.serveStatic(js.Node.__dirname + '/public'));

    io.on('connection', function(socket : Socket) {
      trace('client connected');
      socket.emit('message', { data: 'hello' });
    });

    server.listen(port, function() {
      trace('server listening on $port');
    });
  }
}

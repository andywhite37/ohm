package ohm.server;

import js.node.Http;

import express.Express;

import npm.socketio.Server;

class Main {
  public static function main() {
    var port = 3000;
    var app = new Express();
    var server = Http.createServer(cast app);
    var io = new npm.socketio.Server(port);

    server.listen(port, function() {
      trace('server listening on $port');
    });

    app.use(Express.serveStatic(js.Node.__dirname + '/public'));

    io.onconnection()
  }
}

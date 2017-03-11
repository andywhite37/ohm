package ohm.server;

import js.node.Http;

import express.Express;

import npm.socketio.Server;
import npm.socketio.Socket;

import thx.Either;
using thx.Eithers;
import thx.Validation;
import thx.Validation.*;

import ohm.common.message.ClientMessage;
import ohm.common.message.ServerMessage;
import ohm.common.model.Game;
import ohm.common.model.User;
import ohm.common.util.Serializer;

import ohm.server.service.ClientMessageHandler;
import ohm.server.service.IClientMessageHandler;
import ohm.server.service.InMemoryRepository;
import ohm.server.service.IRepository;
import ohm.server.service.ISocketClient;
import ohm.server.service.IOSocketClient;

class Main {
  public static function main() {
    var port = 3000;

    var app = new Express();
    var server = Http.createServer(cast app);
    var io = new npm.socketio.Server(server);

    var repository : IRepository = new InMemoryRepository();

    app.use(Express.serveStatic(js.Node.__dirname + '/public'));

    io.on('connection', function(socket : Socket) {
      trace('client connected');
      var socketClient : ISocketClient = new IOSocketClient(io, socket);

      socket.on('client-message', function(data : String) : Void {
        trace('client-message $data');
        var handler : IClientMessageHandler = new ClientMessageHandler(socketClient, repository);
        handler.handleString(data);
      });
    });

    server.listen(port, function() {
      trace('server listening on $port');
    });
  }
}

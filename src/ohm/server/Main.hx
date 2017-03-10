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
import ohm.server.service.IRepository;
import ohm.server.service.InMemoryRepository;

class Main {
  public static function main() {
    var port = 8080;

    var app = new Express();
    var server = Http.createServer(cast app);
    var io = new npm.socketio.Server(server);

    var repository : IRepository = new InMemoryRepository();

    app.use(Express.serveStatic(js.Node.__dirname + '/public'));

    io.on('connection', function(socket : Socket) {
      trace('client connected');

      socket.on('client-message', function(data : String) : Void {
        trace('client-message $data');

        switch Serializer.parseString(ClientMessages.schema(), data).either {
          case Left(errs) : trace('errors parsing client message: ${errs.toArray().join(", ")}');
          case Right(clientMessage) : handleClientMessage(repository, socket, clientMessage);
        };
      });
    });

    server.listen(port, function() {
      trace('server listening on $port');
    });
  }

  static function handleClientMessage(repository: IRepository, socket: Socket, message : ClientMessage) : Void {
    switch message {
      case Empty:
      case CreateUser(name) :
        trace('creating user $name');
        repository.addUser(new User(UserId.gen(), name))
          .flatMap(function(user) {
            trace('created user $name');
            var data = Serializer.renderString(ServerMessages.schema(), CreateUserSuccess(user));
            trace('emit created user');
            socket.emit('server-message', data);
            trace('getting users');
            return repository.getUsers();
          })
          .success(function(users) {
            var data = Serializer.renderString(ServerMessages.schema(), Users(users));
            trace('emit users');
            socket.emit('server-message', data);
            trace('broadcast users');
            socket.broadcast.emit('server-message', data);
          });
      case GetUsers :
        repository.getUsers().success(function(users) {
          var data = Serializer.renderString(ServerMessages.schema(), Users(users));
          socket.emit('server-message', data);
        });
      case GetGames :
        repository.getGames().success(function(games) {
          var data = Serializer.renderString(ServerMessages.schema(), Games(games));
          socket.emit('server-message', data);
        });
      case CreateGame(gameId) :
      case JoinGame(gameId, user) :
      case RemoveGame(gameId) :

    };
  }
}

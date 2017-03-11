package ohm.server.service;

import thx.Nil;
using thx.promise.Promise;

import ohm.common.message.ClientMessage;
import ohm.common.message.ServerMessage;
import ohm.common.model.User;
import ohm.common.model.Game;
import ohm.common.util.Serializer;

class ClientMessageHandler {
  var socketClient(default, null) : ISocketClient;
  var repository(default, null) : IRepository;

  public function new(socketClient : ISocketClient, repository : IRepository) {
    this.socketClient = socketClient;
    this.repository = repository;
  }

  public function handleString(data : String) : Void {
    switch Serializer.parseString(ClientMessages.schema(), data).either {
      case Left(errors) : socketClient.sendClient(UnexpectedFailure('failed to parse client message: $data'));
      case Right(message) : handleClientMessage(message);

    }
  }

  // TODO: how can this code not send messages as side effects?
  // maybe return a Promise<Responses> and send all the responses at the end?

  public function handleClientMessage(message : ClientMessage) : Void {
    switch message {
      case Empty: handleEmpty();
      case CreateUser(name) : handleCreateUser(name);
      case GetUsers : handleGetUsers();
      case GetGames : handleGetGames();
      case CreateGame(gameId) : handleCreateGame(gameId);
      case JoinGame(gameId, userId) : handleJoinGame(gameId, userId);
      case LeaveGame(gameId, userId) : handleLeaveGame(gameId, userId);
      //case RemoveGame(gameId) : handleRemoveGame(gameId);
    }
  }

  function handleEmpty() : Promise<Nil> {
    return Promise.nil;
  }

  function handleCreateUser(name : String) : Promise<Array<User>> {
    return repository.addUser(name)
      .flatMap(function(user) {
        socketClient.sendClient(CreateUserSuccess(user));
        return repository.getUsers();
      })
      .success(function(users) {
        socketClient.sendAll(UsersUpdate(users));
      })
      .failure(function(error) {
        socketClient.sendClient(CreateUserFailure(name, 'failed to create user: ${error.message}'));
      });
  }

  function handleGetUsers() : Promise<Array<User>> {
    return repository.getUsers()
      .success(function(users) {
        socketClient.sendClient(UsersUpdate(users));
      })
      .failure(function(error) {
        socketClient.sendClient(GetUsersFailure('failed to get users: ${error.message}'));
      });
  }

  function handleGetGames() : Promise<Array<Game>> {
    return repository.getGames()
      .success(function(games) {
        socketClient.sendClient(GamesUpdate(games));
      })
      .failure(function(error) {
        socketClient.sendClient(GetGamesFailure('failed to get games: ${error.message}'));
      });
  }

  function handleCreateGame(name : String) : Promise<Array<Game>> {
    return repository.addGame(name)
      .flatMap(function(game : Game) {
        socketClient.sendClient(CreateGameSuccess(game));
        return repository.getGames();
      })
      .success(function(games) {
        socketClient.sendAll(GamesUpdate(games));
      })
      .failure(function(error) {
        socketClient.sendClient(CreateGameFailure(name, 'failed to create game: ${error.message}'));
      });
  }

  function handleJoinGame(gameId : GameId, userId : UserId) : Promise<Game> {
    return repository.joinGame(gameId, userId)
      .success(function(game : Game) {
        socketClient.joinRoom(gameId.toString());
        socketClient.sendClient(JoinGameSuccess(game));
        socketClient.sendRoomAll(gameId.toString(), GameUpdate(game));
      })
      .failure(function(error) {
        socketClient.sendClient(JoinGameFailure('failed to join game: ${error.message}'));
      });
  }

  function handleLeaveGame(gameId : GameId, userId : UserId) : Promise<Game> {
    return repository.leaveGame(gameId, userId)
      .success(function(game : Game) {
        socketClient.leaveRoom(gameId.toString());
        socketClient.sendClient(LeaveGameSuccess(game));
        socketClient.sendRoomAll(gameId.toString(), GameUpdate(game));
      })
      .failure(function(error) {
        socketClient.sendClient(LeaveGameFailure('failed to leave game: ${error.message}'));
      });
  }
}

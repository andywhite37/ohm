package ohm.server.service;

import thx.Nil;
using thx.promise.Promise;

import ohm.common.message.ClientMessage;
import ohm.common.message.ServerMessage;
import ohm.common.model.User;
import ohm.common.model.Game;
import ohm.common.util.Serializer;

class ClientMessageHandler implements IClientMessageHandler {
  var socketClient(default, null) : ISocketClient;
  var repository(default, null) : IRepository;

  public function new(socketClient : ISocketClient, repository : IRepository) {
    this.socketClient = socketClient;
    this.repository = repository;
  }

  public function handleString(data : String) : Void {
    switch Serializer.parseString(ClientMessages.schema(), data).either {
      case Left(errors) : socketClient.sendClient(UnexpectedFailure('failed to parse client message: $data - ${errors.toArray().join(", ")}'));
      case Right(message) : handleClientMessage(message);
    }
  }

  // TODO: how can this code not send messages as side effects?
  // maybe return a Promise<Responses> and send all the responses at the end?

  public function handleClientMessage(message : ClientMessage) : Void {
    switch message {
      case Empty: // no-op
      case CreateUser(name) : createUser(name);
      case GetUsers : getUsers();
      case GetGames : getGames();
      case CreateGame(name, playerCount) : createGame(name, playerCount);
      case JoinGame(gameId, userId) : joinGame(gameId, userId);
      case LeaveGame(gameId, userId) : leaveGame(gameId, userId);
      case RemoveGame(gameId) : removeGame(gameId);
      case StartGame(gameId) : startGame(gameId);
    }
  }

  function createUser(name : String) : Promise<Array<User>> {
    return repository.createUser(name)
      .flatMap(function(user) {
        socketClient.sendClient(CreateUserSuccess(user));
        return repository.getUsers();
      })
      .success(function(users) {
        socketClient.sendAll(UsersUpdated(users));
      })
      .failure(function(error) {
        socketClient.sendClient(CreateUserFailure(name, 'failed to create user: ${error.message}'));
      });
  }

  function getUsers() : Promise<Array<User>> {
    return repository.getUsers()
      .success(function(users) {
        socketClient.sendClient(UsersUpdated(users));
      })
      .failure(function(error) {
        socketClient.sendClient(GetUsersFailure('failed to get users: ${error.message}'));
      });
  }

  function getGames() : Promise<Array<Game>> {
    return repository.getGames()
      .success(function(games) {
        socketClient.sendClient(GamesUpdated(games));
      })
      .failure(function(error) {
        socketClient.sendClient(GetGamesFailure('failed to get games: ${error.message}'));
      });
  }

  function createGame(name : String, playerCount : Int) : Promise<Array<Game>> {
    return repository.createGame(name, playerCount)
      .flatMap(function(game : Game) {
        socketClient.sendClient(CreateGameSuccess(game));
        return repository.getGames();
      })
      .success(function(games) {
        socketClient.sendAll(GamesUpdated(games));
      })
      .failure(function(error) {
        socketClient.sendClient(CreateGameFailure(name, 'failed to create game: ${error.message}'));
      });
  }

  function joinGame(gameId : GameId, userId : UserId) : Promise<Array<Game>> {
    return repository.joinGame(gameId, userId)
      .flatMap(function(game : Game) {
        socketClient.joinRoom(gameId.toString());
        socketClient.sendClient(JoinGameSuccess(game));
        socketClient.sendRoomAll(gameId.toString(), GameUpdated(game));
        return repository.getGames();
      })
      .success(function(games) {
        socketClient.sendAll(GamesUpdated(games));
      })
      .failure(function(error) {
        socketClient.sendClient(JoinGameFailure(gameId, 'failed to join game: ${error.message}'));
      });
  }

  function leaveGame(gameId : GameId, userId : UserId) : Promise<Game> {
    return repository.leaveGame(gameId, userId)
      .success(function(game : Game) {
        socketClient.leaveRoom(gameId.toString());
        socketClient.sendClient(LeaveGameSuccess(game));
        socketClient.sendRoomAll(gameId.toString(), GameUpdated(game));
      })
      .failure(function(error) {
        socketClient.sendClient(LeaveGameFailure(gameId, 'failed to leave game: ${error.message}'));
      });
  }

  function removeGame(gameId : GameId) : Promise<{ removedGame: Game, games: Array<Game> }> {
    return repository.removeGame(gameId)
      .success(function(result : { removedGame: Game, games: Array<Game> }) {
        socketClient.sendClient(RemoveGameSuccess(result.removedGame));
        socketClient.sendRoomAll(result.removedGame.id.toString(), GameRemoved(result.removedGame));
        socketClient.sendAll(GamesUpdated(result.games));
      })
      .failure(function(error) {
        socketClient.sendClient(RemoveGameFailure(gameId, 'failed to remove game: ${error.message}'));
      });
  }

  function startGame(gameId : GameId) : Promise<Game> {
    return repository.startGame(gameId)
      .success(function(game) {
        socketClient.sendClient(StartGameSuccess(game));
        socketClient.sendRoomAll(gameId.toString(), GameStarted(game));
        socketClient.sendRoomAll(gameId.toString(), GameUpdated(game));
      })
      .failure(function(error) {
        socketClient.sendClient(StartGameFailure(gameId, 'failed to start game: ${error.message}'));
      });
  }
}

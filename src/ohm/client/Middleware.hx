package ohm.client;

using thx.Functions;
import thx.stream.Reducer.Middleware as StreamMiddleware;
import thx.stream.Reducer.Middleware.*;
using thx.promise.Promise;

import ohm.common.message.ClientMessage;
import ohm.common.message.ServerMessage;

import ohm.client.Action;
import ohm.client.error.LoadError;
import ohm.client.service.IApiClient;
import ohm.client.service.ISocketClient;
using ohm.client.state.Address;
import ohm.client.state.State;

class Middleware {
  var apiClient(default, null) : IApiClient;
  var socketClient(default, null) : ISocketClient;

  public function new(apiClient : IApiClient, socketClient : ISocketClient) {
    this.apiClient = apiClient;
    this.socketClient = socketClient;
  }

  public function init() : StreamMiddleware<State, Action> {
    return empty() +
      navigationMiddleware +
      dataRequestMiddleware +
      socketMiddleware;
  }

  public function navigationMiddleware(action : Action, dispatch : Action -> Void) : Void {
    switch action {
      case ChangeAddress(address) : js.Browser.location.hash = Addresses.toHash(address);
      case _ : // no-op
    }
  }

  public function dataRequestMiddleware(action : Action, dispatch : Action -> Void) : Void {
    switch action {
      case AddressChanged(Lobby) :
        trace('mw: AddressChanged(Lobby)');
        dispatch(GetUsers);
        dispatch(GetGames);

      case _ : // no-op
    }
  }

  public function socketMiddleware(action : Action, dispatch : Action -> Void) : Void {
    // TODO: is there a better place to do the connect/
    if (!socketClient.isConnected()) {
      socketClient.connect();
      socketClient.subscribe(onServerMessage.bind(_, dispatch));
    }
    switch action {
      case UnexpectedFailure(_) : // no-op

      case ChangeAddress(_) : // no-op
      case AddressChanged(_) : // no-op

      case CreateUser(name) : socketClient.send(CreateUser(name));
      case CreateUserSuccess(user) : // no-op
      case CreateUserFailure(name, message) : // no-op

      case GetUsers :
        trace('mw: socket GetUsers');
        socketClient.send(GetUsers);
      case UsersUpdated(_): // no-op
      case GetUsersFailure(_): // no-op

      case GetGames :
        trace('mw: socket GetGames');
        socketClient.send(GetGames);
      case GamesUpdated(_): // no-op
      case GetGamesFailure(_): // no-op

      case CreateGame(name, playerCount) : socketClient.send(CreateGame(name, playerCount));
      case CreateGameSuccess(game) : // no-op
      case CreateGameFailure(name, error) : // no-op

      case JoinGame(gameId, userId) : socketClient.send(JoinGame(gameId, userId));
      case JoinGameSuccess(_) : // no-op
      case JoinGameFailure(_) : // no-op

      case LeaveGame(gameId, userId) : socketClient.send(LeaveGame(gameId, userId));
      case LeaveGameSuccess(_) : // no-op
      case LeaveGameFailure(_) : // no-op

      case RemoveGame(gameId) : socketClient.send(RemoveGame(gameId));
      case RemoveGameSuccess(_) : // no-op
      case RemoveGameFailure(_, _) : // no-op
      case GameRemoved(_) : // no-op

      case StartGame(gameId) : socketClient.send(StartGame(gameId));
      case StartGameSuccess(_) : // no-op
      case StartGameFailure(_, _) : // no-op
      case GameStarted(_) : // no-op

      case GameUpdated(_) : // no-op
    }
  }

  function onServerMessage(message : ServerMessage, dispatch : Action -> Void) : Void {
    // Propagate server messages as application actions
    switch message {
      case Empty: // no-op

      case UnexpectedFailure(message) : dispatch(UnexpectedFailure(message));

      case UsersUpdated(users) :
        trace('mw: server message UsersUpdated $users');
        dispatch(UsersUpdated(users));

      case GetUsersFailure(message) : dispatch(GetUsersFailure(message));

      case CreateUserSuccess(user) : dispatch(CreateUserSuccess(user));
      case CreateUserFailure(name, message) : dispatch(CreateUserFailure(name, message));

      case GamesUpdated(games) :
        trace('mw: server message GamesUpdated $games');
        dispatch(GamesUpdated(games));

      case GetGamesFailure(message) : dispatch(GetGamesFailure(message));

      case CreateGameSuccess(game) : dispatch(CreateGameSuccess(game));
      case CreateGameFailure(name, message) : dispatch(CreateGameFailure(name, message));

      case JoinGameSuccess(game) : dispatch(JoinGameSuccess(game));
      case JoinGameFailure(gameId, message) : dispatch(JoinGameFailure(gameId, message));

      case LeaveGameSuccess(game) : dispatch(LeaveGameSuccess(game));
      case LeaveGameFailure(gameId, message) : dispatch(LeaveGameFailure(gameId, message));

      case RemoveGameSuccess(game) : dispatch(RemoveGameSuccess(game));
      case RemoveGameFailure(gameId, message) : dispatch(RemoveGameFailure(gameId, message));
      case GameRemoved(game) : dispatch(GameRemoved(game));

      case StartGameSuccess(game) : dispatch(StartGameSuccess(game));
      case StartGameFailure(gameId, message) : dispatch(StartGameFailure(gameId, message));
      case GameStarted(game) : dispatch(GameStarted(game));

      case GameUpdated(game) : dispatch(GameUpdated(game));
    }
  }
}

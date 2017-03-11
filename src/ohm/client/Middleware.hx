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
    return empty() + dataRequestMiddleware + socketMiddleware;
  }

  function onServerMessage(message : ServerMessage, dispatch : Action -> Void) : Void {
    // Propagate server messages as application actions
    switch message {
      case Empty: // no-op
      case UnexpectedFailure(message) : dispatch(UnexpectedFailure(message));
      case UsersUpdate(users) : dispatch(UsersUpdate(users));
      case GetUsersFailure(error) : dispatch(GetUsersFailure(error));
      case CreateUserSuccess(user) : dispatch(CreateUserSuccess(user));
      case CreateUserFailure(name, error) : dispatch(CreateUserFailure(name, error));
      case GamesUpdate(games) : dispatch(GamesUpdate(games));
      case GetGamesFailure(error) : dispatch(GetGamesFailure(error));
      case CreateGameSuccess(game) : dispatch(CreateGameSuccess(game));
      case CreateGameFailure(name, error) : dispatch(CreateGameFailure(name, error));
      case JoinGameSuccess(game) : dispatch(JoinGameSuccess(game));
      case JoinGameFailure(error) : dispatch(JoinGameFailure(error));
      case LeaveGameSuccess(game) : dispatch(LeaveGameSuccess(game));
      case LeaveGameFailure(error) : dispatch(LeaveGameFailure(error));
      case GameUpdate(game) : dispatch(GameUpdate(game));
    }
  }

  public function dataRequestMiddleware(action : Action, dispatch : Action -> Void) : Void {
    switch action {
      case AddressChanged(Lobby) :
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
      case AddressChanged(Lobby) : // no-op
      case AddressChanged(Unknown(location)) : // no-op
      case CreateUser(name) : socketClient.send(CreateUser(name));
      case CreateUserSuccess(user) : // no-op
      case CreateUserFailure(name, error) : // no-op
      case GetUsers : socketClient.send(GetUsers);
      case UsersUpdate(_): // no-op
      case GetUsersFailure(_): // no-op
      case GetGames : socketClient.send(GetGames);
      case GamesUpdate(_): // no-op
      case GetGamesFailure(_): // no-op
      case CreateGame(name) : socketClient.send(CreateGame(name));
      case CreateGameSuccess(game) : // no-op
      case CreateGameFailure(name, error) : // no-op
      case JoinGameSuccess(_) : // no-op
      case JoinGameFailure(_) : // no-op
      case LeaveGameSuccess(_) : // no-op
      case LeaveGameFailure(_) : // no-op
      case GameUpdate(_) : // no-op
    }
  }
}

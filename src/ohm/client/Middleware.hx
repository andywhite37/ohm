package ohm.client;

using thx.Functions;
import thx.stream.Reducer.Middleware as StreamMiddleware;
import thx.stream.Reducer.Middleware.*;
using thx.promise.Promise;

import ohm.common.message.ClientMessage;
import ohm.common.message.ServerMessage;

import ohm.client.Action;
import ohm.client.service.IApiClient;
import ohm.client.service.ISocketClient;
import ohm.client.error.LoadError;
import ohm.client.state.State;

class Middleware {
  var apiClient(default, null) : IApiClient;
  var socketClient(default, null) : ISocketClient;

  public function new(apiClient : IApiClient, socketClient : ISocketClient) {
    this.apiClient = apiClient;
    this.socketClient = socketClient;
  }

  public function init() : StreamMiddleware<State, Action> {
    return empty() + socketMiddleware;
  }

  function onServerMessage(message : ServerMessage, dispatch : Action -> Void) : Void {
    switch message {
      case Empty:

      case Users(users) : dispatch(GetUsersSuccess(users));
      case CreateUserSuccess(user) : dispatch(CreateUserSuccess(user));
      case CreateUserFailure(name, error) : dispatch(CreateUserFailure(name, error));

      case Games(games) : dispatch(GetGamesSuccess(games));
      case _ : throw new thx.error.NotImplemented();
      //case UserJoinedGame(user, game, users) : dispatch(JoinGameSuccess(game));
    }
  }

  public function socketMiddleware(action : Action, dispatch : Action -> Void) : Void {
    // TODO: is there a better place to do the connect/
    if (!socketClient.isConnected()) {
      socketClient.connect();
      socketClient.subscribe(onServerMessage.bind(_, dispatch));
    }
    switch action {
      case GoTo(Lobby) :
        dispatch(GetUsers);
        dispatch(GetGames);

      case GoTo(Unknown(location)) :
        trace('unknown location: $location');

      case CreateUser(name) :
        socketClient.send(CreateUser(name));

      case CreateUserSuccess(user) :

      case CreateUserFailure(name, error) :

      case GetUsers :
        socketClient.send(GetUsers);

      case GetUsersSuccess(_):

      case GetUsersFailure(_):

      case GetGames :
        socketClient.send(GetGames);

      case GetGamesSuccess(_):

      case GetGamesFailure(_):

      case CreateGame(name) : // TODO
        socketClient.send(CreateGame(name));

      case CreateGameSuccess(game) :
      case CreateGameFailure(name, error) :
    }
  }
}

package ohm.client;

using thx.Functions;
import thx.stream.Reducer.Middleware as StreamMiddleware;
import thx.stream.Reducer.Middleware.*;
using thx.promise.Promise;

import ohm.client.Action;
import ohm.client.api.IApiClient;
import ohm.client.error.LoadError;
import ohm.client.state.State;

class Middleware {
  var apiClient(default, null) : IApiClient;

  public function new(apiClient : IApiClient) {
    this.apiClient = apiClient;
  }

  public function init() : StreamMiddleware<State, Action> {
    return empty() + handleApiRequests;
  }

  public function handleApiRequests(action : Action, dispatch : Action -> Void) : Void {
    switch action {
      case GoTo(Lobby) :
        dispatch(LoadUsers);
        dispatch(LoadGames);

      case GoTo(Unknown(location)) :

      case LoadUsers :
        apiClient.getUsers()
          .map(LoadUsersSuccess)
          .success(dispatch)
          .failure(function(error) {
            dispatch(LoadUsersFailure(new LoadError('failed to load users')));
          });
      case LoadUsersSuccess(_):
      case LoadUsersFailure(_):

      case LoadGames :
        apiClient.getGames()
          .map(LoadGamesSuccess)
          .success(dispatch)
          .failure(function(error) {
            dispatch(LoadGamesFailure(new LoadError('failed to load games')));
          });
      case LoadGamesSuccess(_):
      case LoadGamesFailure(_):

      case CreateGame(name) : // TODO
    }
  }
}

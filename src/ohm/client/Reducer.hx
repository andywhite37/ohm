package ohm.client;

import ohm.common.state.Game;
import ohm.common.state.User;
import ohm.client.error.LoadError;
import ohm.client.state.Address;
import ohm.client.state.State;
import ohm.client.view.LobbyView;

class Reducer {
  public static function reduce(state : State, action : Action) : State {
    return switch action {
      case GoTo(address) : goTo(state, address);
      case LoadUsers: loadUsers(state);
      case LoadUsersSuccess(users) : loadUsersSuccess(state, users);
      case LoadUsersFailure(error) : loadUsersFailure(state, error);
      case LoadGames : loadGames(state);
      case LoadGamesSuccess(games) : loadGamesSuccess(state, games);
      case LoadGamesFailure(error) : loadGamesFailure(state, error);
      case CreateGame(name) : createGame(state, name);
    }
  }

  static function goTo(state : State, address : Address) : State {
    return state;
  }

  static function loadUsers(state : State) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withUsersLoader(Loading)));
    }
  }

  static function loadUsersSuccess(state : State, users : Array<User>) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withUsersLoader(Loaded(users))));
    }
  }

  static function loadUsersFailure(state : State, error : LoadError) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withUsersLoader(Failed(error))));
    }
  }

  static function loadGames(state : State) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withGamesLoader(Loading)));
    }
  }

  static function loadGamesSuccess(state : State, games : Array<Game>) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withGamesLoader(Loaded(games))));
    }
  }

  static function loadGamesFailure(state : State, error : LoadError) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withGamesLoader(Failed(error))));
    }
  }

  static function createGame(state : State, name : String) : State {
    // TODO
    return state;
  }
}

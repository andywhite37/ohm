package ohm.client;

import ohm.common.model.Game;
import ohm.common.model.User;
import ohm.client.error.LoadError;
import ohm.client.state.Address;
import ohm.client.state.State;
import ohm.client.view.LobbyView;

class Reducer {
  public static function reduce(state : State, action : Action) : State {
    return switch action {
      case UnexpectedFailure(message) : state; // TODO

      case AddressChanged(address) : addressChanged(state, address);

      case CreateUser(name) : createUser(state, name);
      case CreateUserSuccess(user) : createUserSuccess(state, user);
      case CreateUserFailure(name, error) : createUserFailure(state, name, error);

      case GetUsers: getUsers(state);
      case UsersUpdate(users) : usersUpdate(state, users);
      case GetUsersFailure(error) : getUsersFailure(state, error);

      case GetGames : getGames(state);
      case GamesUpdate(games) : gamesUpdate(state, games);
      case GetGamesFailure(error) : getGamesFailure(state, error);

      case CreateGame(name) : createGame(state, name);
      case CreateGameSuccess(game) : createGameSuccess(state, game);
      case CreateGameFailure(name, message) : createGameFailure(state, name, message);
      case JoinGameSuccess(game) : state; // TODO
      case JoinGameFailure(error) : state; // TODO
      case LeaveGameSuccess(game) : state; // TODO
      case LeaveGameFailure(error) : state; // TODO
      case GameUpdate(game) : gameUpdate(state, game);
    }
  }

  static function addressChanged(state : State, address : Address) : State {
    // TODO
    return state;
  }

  static function createUser(state : State, name : String) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withCurrentUserLoader(Loading)));
    }
  }

  static function createUserSuccess(state : State, user : User) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withCurrentUserLoader(Loaded(user))));
    }
  }

  static function createUserFailure(state : State, name : String, message : String) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withCurrentUserLoader(Failed('failed to create user $name'))));
    };
  }

  static function getUsers(state : State) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withUsersLoader(Loading)));
    }
  }

  static function usersUpdate(state : State, users : Array<User>) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withUsersLoader(Loaded(users))));
    }
  }

  static function getUsersFailure(state : State, error : String) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withUsersLoader(Failed(error))));
    }
  }

  static function getGames(state : State) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withGamesLoader(Loading)));
    }
  }

  static function gamesUpdate(state : State, games : Array<Game>) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withGamesLoader(Loaded(games))));
    }
  }

  static function getGamesFailure(state : State, error : String) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withGamesLoader(Failed(error))));
    }
  }

  static function createGame(state : State, name : String) : State {
    // TODO
    return state;
  }

  static function createGameSuccess(state : State, game : Game) : State {
    // TODO
    return state;
  }

  static function createGameFailure(state : State, name : String, message : String) : State {
    // TODO
    return state;
  }

  static function gameUpdate(state : State, game : Game) : State {
    // TODO
    return state;
  }
}

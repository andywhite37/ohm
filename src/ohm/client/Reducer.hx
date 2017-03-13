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
      case UnexpectedFailure(message) : unexpectedFailure(state, message);

      case ChangeAddress(address) : changeAddress(state, address);
      case AddressChanged(address) : addressChanged(state, address);

      case CreateUser(name) : createUser(state, name);
      case CreateUserSuccess(user) : createUserSuccess(state, user);
      case CreateUserFailure(name, error) : createUserFailure(state, name, error);

      case GetUsers: getUsers(state);
      case UsersUpdated(users) : usersUpdated(state, users);
      case GetUsersFailure(error) : getUsersFailure(state, error);

      case GetGames : getGames(state);
      case GamesUpdated(games) : gamesUpdated(state, games);
      case GetGamesFailure(error) : getGamesFailure(state, error);

      case CreateGame(name) : createGame(state, name);
      case CreateGameSuccess(game) : createGameSuccess(state, game);
      case CreateGameFailure(name, message) : createGameFailure(state, name, message);

      case JoinGame(gameId, userId) : joinGame(state, gameId, userId);
      case JoinGameSuccess(game) : joinGameSuccess(state, game);
      case JoinGameFailure(gameId, message) : joinGameFailure(state, gameId, message);

      case LeaveGame(gameId, userId) : leaveGame(state, gameId, userId);
      case LeaveGameSuccess(game) : leaveGameSuccess(state, game);
      case LeaveGameFailure(gameId, message) : leaveGameFailure(state, gameId, message);

      case RemoveGame(gameId) : removeGame(state, gameId);
      case RemoveGameSuccess(game) : removeGameSuccess(state, game);
      case RemoveGameFailure(gameId, message) : removeGameFailure(state, gameId, message);
      case GameRemoved(game) : gameRemoved(state, game);

      case StartGame(gameId) : startGame(state, gameId);
      case StartGameSuccess(game) : startGameSuccess(state, game);
      case StartGameFailure(gameId, message) : startGameFailure(state, gameId, message);
      case GameStarted(game) : gameStarted(state, game);

      case GameUpdated(game) : gameUpdated(state, game);
    }
  }

  static function unexpectedFailure(state : State, message : String) : State {
    // TODO
    return state;
  }

  static function changeAddress(state : State, address : Address) : State {
    // TODO
    return state;
  }

  static function addressChanged(state : State, address : Address) : State {
    // TODO
    return switch address {
      case Lobby : state.withViewState(Lobby(new LobbyViewData(Loading, Loading, Loading)));
      case Unknown(location) : state; // TODO
    }
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

  static function usersUpdated(state : State, users : Array<User>) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withUsersLoader(Loaded(users))));
    }
  }

  static function getUsersFailure(state : State, message : String) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withUsersLoader(Failed(message))));
    }
  }

  static function getGames(state : State) : State {
    return switch state.viewState {
      case Lobby(data) : state.withViewState(Lobby(data.withGamesLoader(Loading)));
    }
  }

  static function gamesUpdated(state : State, games : Array<Game>) : State {
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

  static function joinGame(state : State, gameId : GameId, userId: UserId) : State {
    // TODO
    return state;
  }

  static function joinGameSuccess(state : State, game : Game) : State {
    // TODO
    return state;
  }

  static function joinGameFailure(state : State, gameId : GameId, message : String) : State {
    // TODO
    return state;
  }

  static function leaveGame(state : State, gameId : GameId, userId: UserId) : State {
    // TODO
    return state;
  }

  static function leaveGameSuccess(state : State, game : Game) : State {
    // TODO
    return state;
  }

  static function leaveGameFailure(state : State, gameId : GameId, message : String) : State {
    // TODO
    return state;
  }

  static function removeGame(state : State, gameId: GameId) : State {
    // TODO
    return state;
  }

  static function removeGameSuccess(state : State, game: Game) : State {
    // TODO
    return state;
  }

  static function removeGameFailure(state : State, gameId: GameId, message : String) : State {
    // TODO
    return state;
  }

  static function gameRemoved(state : State, game: Game) : State {
    // TODO
    return state;
  }

  static function startGame(state : State, gameId: GameId) : State {
    // TODO
    return state;
  }

  static function startGameSuccess(state : State, game: Game) : State {
    // TODO
    return state;
  }

  static function startGameFailure(state : State, gameId: GameId, message : String) : State {
    // TODO
    return state;
  }

  static function gameStarted(state : State, game: Game) : State {
    // TODO
    return state;
  }

  static function gameUpdated(state : State, game : Game) : State {
    // TODO
    return state;
  }
}

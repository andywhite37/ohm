package ohm.common.message;

import haxe.Json;

import thx.Validation;
import thx.Validation.*;

import thx.schema.SchemaDSL.*;
import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

import ohm.common.model.Game;
import ohm.common.model.User;

enum ServerMessage {
  Empty;

  UnexpectedFailure(message : String);

  UsersUpdated(users : Array<User>);

  GetUsersFailure(message : String);

  CreateUserSuccess(user : User);
  CreateUserFailure(name : String, message : String);

  GamesUpdated(games : Array<Game>);
  GetGamesFailure(message : String);

  CreateGameSuccess(game : Game);
  CreateGameFailure(name : String, message : String);

  JoinGameSuccess(game : Game);
  JoinGameFailure(gameId : GameId, message : String);

  LeaveGameSuccess(game : Game);
  LeaveGameFailure(gameId : GameId, message : String);

  RemoveGameSuccess(game: Game);
  RemoveGameFailure(gameId : GameId, message : String);
  GameRemoved(game : Game);

  StartGameSuccess(game : Game);
  StartGameFailure(gameId : GameId, message : String);
  GameStarted(game : Game);

  GameUpdated(game : Game);
}

class ServerMessages {
  public static function schema<E>() : Schema<E, ServerMessage> {
    return oneOf([
      emptySchema(),

      unexpectedFailureSchema(),

      usersUpdatedSchema(),
      createUserSuccessSchema(),
      createUserFailureSchema(),

      gamesUpdatedSchema(),

      createGameSuccessSchema(),
      createGameFailureSchema(),

      joinGameSuccessSchema(),
      joinGameFailureSchema(),

      leaveGameSuccessSchema(),
      leaveGameFailureSchema(),

      removeGameSuccessSchema(),
      removeGameFailureSchema(),
      gameRemovedSchema(),

      startGameSuccessSchema(),
      startGameFailureSchema(),
      gameStartedSchema(),

      gameUpdatedSchema()
    ]);
  }

  static function emptySchema() {
    return constEnum("empty", Empty);
  }

  static function unexpectedFailureSchema() {
    return alt(
      "unexpectedFailure",
      object(ap1(
        function(message : String) return { message: message },
        required("message", string(), function(v : { message: String }) return v.message)
      )),
      function(v : { message: String }) return UnexpectedFailure(v.message),
      function(message : ServerMessage) {
        return switch message {
          case UnexpectedFailure(message) : Some({ message: message });
          case _ : None;
        };
      }
    );
  }

  static function usersUpdatedSchema() {
    return alt(
      "usersUpdated",
      object(ap1(
        function(users : Array<User>) return { users: users },
        required("users", array(User.schema()), function(v : { users: Array<User> }) return v.users)
      )),
      function(v : { users: Array<User> }) return UsersUpdated(v.users),
      function(message : ServerMessage) {
        return switch message {
          case UsersUpdated(users) : Some({ users: users });
          case _ : None;
        };
      }
    );
  }

  static function createUserSuccessSchema() {
    return alt(
      "createUserSuccess",
      object(ap1(
        function(user : User) return { user: user },
        required("user", User.schema(), function(v : { user: User }) return v.user)
      )),
      function(v : { user: User }) return CreateUserSuccess(v.user),
      function(message : ServerMessage) {
        return switch message {
          case CreateUserSuccess(user) : Some({ user: user });
          case _ : None;
        };
      }
    );
  }

  static function createUserFailureSchema() {
    return alt(
      "createUserFailure",
      object(ap2(
        function(name : String, message : String) return { name: name, message: message },
        required("name", string(), function(v : { name: String, message: String}) return v.name),
        required("message", string(), function(v : { name: String, message: String}) return v.message)
      )),
      function(v : { name: String, message : String }) return CreateUserFailure(v.name, v.message),
      function(message : ServerMessage) {
        return switch message {
          case CreateUserFailure(name, message) : Some({ name: name, message: message });
          case _ : None;
        };
      }
    );
  }

  static function gamesUpdatedSchema() {
    return alt(
      "gamesUpdated",
      object(ap1(
        function(games : Array<Game>) return { games: games },
        required("games", array(Game.schema()), function(v : { games: Array<Game> }) return v.games)
      )),
      function(v : { games: Array<Game> }) return GamesUpdated(v.games),
      function(message : ServerMessage) {
        return switch message {
          case GamesUpdated(games) : Some({ games: games });
          case _ : None;
        }
      }
    );
  }

  static function createGameSuccessSchema() {
    return alt(
      "createGameSuccess",
      object(ap1(
        function(game : Game) return { game: game },
        required("game", Game.schema(), function(v : { game: Game }) return v.game)
      )),
      function(v : { game: Game }) return CreateGameSuccess(v.game),
      function(message : ServerMessage) {
        return switch message {
          case CreateGameSuccess(game) : Some({ game: game });
          case _ : None;
        };
      }
    );
  }

  static function createGameFailureSchema() {
    return alt(
      "createGameFailure",
      object(ap2(
        function(name : String, message : String) return { name: name, message: message },
        required("name", string(), function(v : { name: String, message: String}) return v.name),
        required("message", string(), function(v : { name: String, message: String}) return v.message)
      )),
      function(v : { name: String, message : String }) return CreateGameFailure(v.name, v.message),
      function(message : ServerMessage) {
        return switch message {
          case CreateGameFailure(name, message) : Some({ name: name, message: message });
          case _ : None;
        };
      }
    );
  }

  static function joinGameSuccessSchema() {
    return alt(
      "joinGameSuccess",
      object(ap1(
        function(game : Game) return { game: game },
        required("game", Game.schema(), function(v : { game: Game }) return v.game)
      )),
      function(v : { game: Game }) return JoinGameSuccess(v.game),
      function(message : ServerMessage) {
        return switch message {
          case JoinGameSuccess(game) : Some({ game: game });
          case _ : None;
        };
      }
    );
  }

  static function joinGameFailureSchema() {
    return alt(
      "joinGameFailure",
      object(ap2(
        function(gameId : GameId, message : String) return { gameId: gameId, message: message },
        required("gameId", Game.gameIdSchema(), function(v : { gameId: GameId, message: String}) return v.gameId),
        required("message", string(), function(v : { gameId: GameId, message: String}) return v.message)
      )),
      function(v : { gameId: GameId, message : String }) return JoinGameFailure(v.gameId, v.message),
      function(message : ServerMessage) {
        return switch message {
          case JoinGameFailure(gameId, message) : Some({ gameId: gameId, message: message });
          case _ : None;
        };
      }
    );
  }

  static function leaveGameSuccessSchema() {
    return alt(
      "leaveGameSuccess",
      object(ap1(
        function(game : Game) return { game: game },
        required("game", Game.schema(), function(v : { game: Game }) return v.game)
      )),
      function(v : { game: Game }) return LeaveGameSuccess(v.game),
      function(message : ServerMessage) {
        return switch message {
          case LeaveGameSuccess(game) : Some({ game: game });
          case _ : None;
        };
      }
    );
  }

  static function leaveGameFailureSchema() {
    return alt(
      "leaveGameFailure",
      object(ap2(
        function(gameId : GameId, message : String) return { gameId: gameId, message: message },
        required("gameId", Game.gameIdSchema(), function(v : { gameId: GameId, message: String}) return v.gameId),
        required("message", string(), function(v : { gameId: GameId, message: String}) return v.message)
      )),
      function(v : { gameId: GameId, message : String }) return LeaveGameFailure(v.gameId, v.message),
      function(message : ServerMessage) {
        return switch message {
          case LeaveGameFailure(gameId, message) : Some({ gameId: gameId, message: message });
          case _ : None;
        };
      }
    );
  }

  static function removeGameSuccessSchema() {
    return alt(
      "removeGameSuccess",
      object(ap1(
        function(game : Game) return { game: game },
        required("game", Game.schema(), function(v : { game: Game }) return v.game)
      )),
      function(v : { game: Game }) return RemoveGameSuccess(v.game),
      function(message : ServerMessage) {
        return switch message {
          case RemoveGameSuccess(game) : Some({ game: game });
          case _ : None;
        };
      }
    );
  }

  static function removeGameFailureSchema() {
    return alt(
      "removeGameFailure",
      object(ap2(
        function(gameId : GameId, message : String) return { gameId: gameId, message: message },
        required("gameId", Game.gameIdSchema(), function(v : { gameId: GameId, message: String}) return v.gameId),
        required("message", string(), function(v : { gameId: GameId, message: String}) return v.message)
      )),
      function(v : { gameId: GameId, message : String }) return RemoveGameFailure(v.gameId, v.message),
      function(message : ServerMessage) {
        return switch message {
          case RemoveGameFailure(gameId, message) : Some({ gameId: gameId, message: message });
          case _ : None;
        };
      }
    );
  }

  static function gameRemovedSchema() {
    return alt(
      "gameRemoved",
      object(ap1(
        function(game : Game) return { game: game },
        required("game", Game.schema(), function(v : { game: Game }) return v.game)
      )),
      function(v : { game: Game }) return GameRemoved(v.game),
      function(message : ServerMessage) {
        return switch message {
          case GameRemoved(game) : Some({ game : game });
          case _ : None;
        }
      }
    );
  }

  static function startGameSuccessSchema() {
    return alt(
      "startGameSuccess",
      object(ap1(
        function(game : Game) return { game: game },
        required("game", Game.schema(), function(v : { game: Game }) return v.game)
      )),
      function(v : { game: Game }) return StartGameSuccess(v.game),
      function(message : ServerMessage) {
        return switch message {
          case StartGameSuccess(game) : Some({ game: game });
          case _ : None;
        };
      }
    );
  }

  static function startGameFailureSchema() {
    return alt(
      "startGameFailure",
      object(ap2(
        function(gameId : GameId, message : String) return { gameId: gameId, message: message },
        required("gameId", Game.gameIdSchema(), function(v : { gameId: GameId, message: String}) return v.gameId),
        required("message", string(), function(v : { gameId: GameId, message: String}) return v.message)
      )),
      function(v : { gameId: GameId, message : String }) return StartGameFailure(v.gameId, v.message),
      function(message : ServerMessage) {
        return switch message {
          case StartGameFailure(gameId, message) : Some({ gameId: gameId, message: message });
          case _ : None;
        };
      }
    );
  }

  static function gameStartedSchema() {
    return alt(
      "gameStarted",
      object(ap1(
        function(game : Game) return { game: game },
        required("game", Game.schema(), function(v : { game: Game }) return v.game)
      )),
      function(v : { game: Game }) return GameStarted(v.game),
      function(message : ServerMessage) {
        return switch message {
          case GameStarted(game) : Some({ game : game });
          case _ : None;
        }
      }
    );
  }


  static function gameUpdatedSchema() {
    return alt(
      "gameUpdated",
      object(ap1(
        function(game : Game) return { game: game },
        required("game", Game.schema(), function(v : { game: Game }) return v.game)
      )),
      function(v : { game: Game }) return GameUpdated(v.game),
      function(message : ServerMessage) {
        return switch message {
          case GameUpdated(game) : Some({ game : game });
          case _ : None;
        }
      }
    );
  }
}

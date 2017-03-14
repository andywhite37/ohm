package ohm.common.message;

import haxe.Json;

import thx.Validation;
import thx.Validation.*;

import thx.schema.SchemaDSL.*;
import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

import ohm.common.model.Game;
import ohm.common.model.User;

enum ClientMessage {
  Empty;

  GetUsers;
  CreateUser(name : String);

  GetGames;
  CreateGame(name : String, playerCount : Int);
  JoinGame(gameId : GameId, userId : UserId);
  LeaveGame(gameId : GameId, userId : UserId);
  RemoveGame(gameId : GameId);
  StartGame(gameId : GameId);
}

class ClientMessages {
  public static function schema<E>() : Schema<E, ClientMessage> {
    return oneOf([
      emptySchema(),

      getUsersSchema(),
      createUserSchema(),

      getGamesSchema(),
      createGameSchema(),
      joinGameSchema(),
      leaveGameSchema(),
      removeGameSchema(),
      startGameSchema()
    ]);
  }

  static function emptySchema() {
    return constEnum("empty", Empty);
  }

  static function createUserSchema() {
    return alt(
      "createUser",
      object(ap1(
        function(name : String) return { name: name },
        required("name", string(), function(v : { name: String }) return v.name)
      )),
      function(v : { name: String }) return CreateUser(v.name),
      function(message : ClientMessage) {
        return switch message {
          case CreateUser(name) : Some({ name: name });
          case _ : None;
        };
      }
    );
  }

  static function getUsersSchema() {
    return constEnum("getUsers", GetUsers);
  }

  static function getGamesSchema() {
    return constEnum("getGames", GetGames);
  }

  static function createGameSchema() {
    return alt(
      "createGame",
      object(ap2(
        function(name : String, playerCount : Int) return { name: name, playerCount: playerCount },
        required("name", string(), function(v : { name : String, playerCount : Int }) return v.name),
        required("playerCount", int(), function(v : { name : String, playerCount: Int }) return v.playerCount)
      )),
      function(v : { name: String, playerCount: Int }) return CreateGame(v.name, v.playerCount),
      function(message : ClientMessage) {
        return switch message {
          case CreateGame(name, playerCount) : Some({ name: name, playerCount: playerCount });
          case _ : None;
        }
      }
    );
  }

  static function joinGameSchema() {
    return alt(
      "joinGame",
      object(ap2(
        function(gameId : GameId, userId: UserId) return { gameId: gameId, userId: userId },
        required("gameId", Game.gameIdSchema(), function(v : { gameId: GameId, userId: UserId }) return v.gameId),
        required("userId", User.userIdSchema(), function(v : { gameId: GameId, userId: UserId }) return v.userId)
      )),
      function(v : { gameId: GameId, userId: UserId }) return JoinGame(v.gameId, v.userId),
      function(message : ClientMessage) {
        return switch message {
          case JoinGame(gameId, userId) : Some({ gameId: gameId, userId: userId });
          case _ : None;
        };
      }
    );
  }

  static function leaveGameSchema() {
    return alt(
      "leaveGame",
      object(ap2(
        function(gameId : GameId, userId: UserId) return { gameId: gameId, userId: userId },
        required("gameId", Game.gameIdSchema(), function(v : { gameId: GameId, userId: UserId }) return v.gameId),
        required("userId", User.userIdSchema(), function(v : { gameId: GameId, userId: UserId }) return v.userId)
      )),
      function(v : { gameId: GameId, userId: UserId }) return LeaveGame(v.gameId, v.userId),
      function(message : ClientMessage) {
        return switch message {
          case LeaveGame(gameId, userId) : Some({ gameId: gameId, userId: userId });
          case _ : None;
        };
      }
    );
  }

  static function removeGameSchema() {
    return alt(
      "removeGame",
      object(ap1(
        function(gameId : GameId) return { gameId: gameId },
        required("gameId", Game.gameIdSchema(), function(v : { gameId: GameId }) return v.gameId)
      )),
      function(v : { gameId: GameId }) return RemoveGame(v.gameId),
      function(message : ClientMessage) {
        return switch message {
          case RemoveGame(gameId) : Some({ gameId: gameId });
          case _ : None;
        };
      }
    );
  }

  static function startGameSchema() {
    return alt(
      "startGame",
      object(ap1(
        function(gameId : GameId) return { gameId: gameId },
        required("gameId", Game.gameIdSchema(), function(v : { gameId: GameId }) return v.gameId)
      )),
      function(v : { gameId: GameId }) return StartGame(v.gameId),
      function(message : ClientMessage) {
        return switch message {
          case StartGame(gameId) : Some({ gameId: gameId });
          case _ : None;
        };
      }
    );
  }
}

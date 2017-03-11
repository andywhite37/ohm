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
  CreateGame(name : String);
  JoinGame(id : GameId, userId : UserId);
  LeaveGame(id : GameId, userId : UserId);
  //RemoveGame(id : GameId);
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
      //removeGameSchema()
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
      object(ap1(
        function(name : String) return { name: name },
        required("name", string(), function(v : { name : String }) return v.name)
      )),
      function(v : { name: String }) return CreateGame(v.name),
      function(message : ClientMessage) {
        return switch message {
          case CreateGame(name) : Some({ name: name });
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
}

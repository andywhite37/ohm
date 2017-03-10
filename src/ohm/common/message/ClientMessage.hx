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
  CreateUser(name : String);
  GetUsers;
  GetGames;
  CreateGame(name : String);
  JoinGame(id : GameId, user : User);
  RemoveGame(id : GameId);
}

class ClientMessages {
  public static function schema<E>() : Schema<E, ClientMessage> {
    return oneOf([
      constEnum("empty", Empty),
      alt(
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
      ),
      constEnum("getUsers", GetUsers),
      constEnum("getGames", GetGames),
      alt(
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
      ),
      alt(
        "joinGame",
        object(ap2(
          function(gameId : GameId, user: User) return { gameId: gameId, user: user },
          required("gameId", Game.gameIdSchema(), function(v : { gameId: GameId, user: User }) return v.gameId),
          required("user", User.schema(), function(v : { gameId: GameId, user: User }) return v.user)
        )),
        function(v : { gameId: GameId, user: User }) return JoinGame(v.gameId, v.user),
        function(message : ClientMessage) {
          return switch message {
            case JoinGame(gameId, user) : Some({ gameId: gameId, user: user });
            case _ : None;
          };
        }
      )
    ]);
  }
}

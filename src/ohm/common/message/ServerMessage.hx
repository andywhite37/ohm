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

  UsersUpdate(users : Array<User>);
  GetUsersFailure(message : String);
  CreateUserSuccess(user : User);
  CreateUserFailure(name : String, message : String);

  GamesUpdate(games : Array<Game>);
  GetGamesFailure(message : String);
  CreateGameSuccess(game : Game);
  CreateGameFailure(name : String, message : String);
  JoinGameSuccess(game : Game);
  JoinGameFailure(message : String);
  LeaveGameSuccess(game : Game);
  LeaveGameFailure(message : String);
  GameUpdate(game : Game);
}

class ServerMessages {
  public static function schema<E>() : Schema<E, ServerMessage> {
    return oneOf([
      emptySchema(),

      unexpectedFailureSchema(),

      usersUpdateSchema(),
      createUserSuccessSchema(),
      createUserFailureSchema()

      //gamesUpdateSchema(),
      //createGameSuccessSchema(),
      //createGameFailureSchema()
      //joinGameSuccessSchema(),
      //joinGameFailureSchema()
      //leaveGameSuccessSchema(),
      //leaveGameFailureSchema()
      //gameUpdateSchema()
    ]);
  }

  static function emptySchema() {
    return constEnum("empty", Empty);
  }

  static function unexpectedFailureSchema() {
    return alt(
      "error",
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

  static function usersUpdateSchema() {
    return alt(
      "users",
      object(ap1(
        function(users : Array<User>) return { users: users },
        required("users", array(User.schema()), function(v : { users: Array<User> }) return v.users)
      )),
      function(v : { users: Array<User> }) return UsersUpdate(v.users),
      function(message : ServerMessage) {
        return switch message {
          case UsersUpdate(users) : Some({ users: users });
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
}

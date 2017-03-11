package ohm.common.model;

import thx.Functions.identity;

import thx.schema.SchemaDSL.*;
import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

abstract GameId(String) {
  public function new(gameId : String) {
    this = gameId;
  }

  public function toString() : String {
    return this;
  }

  public static function gen() : GameId {
    return new GameId(thx.Uuid.create());
  }
}

class Game {
  public var id(default, null) : GameId;
  public var name(default, null) : String;
  public var users(default, default) : Array<User>;

  public function new(id : GameId, name : String, users : Array<User>) {
    this.id = id;
    this.name = name;
    this.users = users;
  }

  public static function gameIdSchema<E>() : Schema<E, GameId> {
    return iso(string(), function(id) return new GameId(id), function(gameId) return gameId.toString());
  }

  public static function schema<E>() : Schema<E, Game> {
    return object(ap3(
      Game.new,
      required("id", gameIdSchema(), function(v : Game) return v.id),
      required("name", string(), function(v : Game) return v.name),
      required("users", array(User.schema()), function(v : Game) return v.users)
    ));
  }
}

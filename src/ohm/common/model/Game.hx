package ohm.common.model;

using thx.Arrays;
using thx.Functions;
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
  public var playerCount(default, null) : Int;
  public var users(default, default) : Array<User>;

  public function new(id : GameId, name : String, playerCount : Int, users : Array<User>) {
    this.id = id;
    this.name = name;
    this.playerCount = playerCount;
    this.users = users;
  }

  public function hasUser(user : User) : Bool {
    return users.any.fn(_.id.toString() == user.id.toString());
  }

  public function canBeStarted() : Bool {
    return playerCount == users.length;
  }

  public function canBeStartedByUser(user : User) : Bool {
    return canBeStarted() && hasUser(user);
  }

  public static function gameIdSchema<E>() : Schema<E, GameId> {
    return iso(string(), function(id) return new GameId(id), function(gameId) return gameId.toString());
  }

  public static function schema<E>() : Schema<E, Game> {
    return object(ap4(
      Game.new,
      required("id", gameIdSchema(), function(v : Game) return v.id),
      required("name", string(), function(v : Game) return v.name),
      required("playerCount", int(), function(v : Game) return v.playerCount),
      required("users", array(User.schema()), function(v : Game) return v.users)
    ));
  }
}

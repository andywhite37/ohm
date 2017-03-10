package ohm.common.model;

import thx.Functions.identity;

import thx.schema.SchemaDSL;
import thx.schema.SchemaDSL.*;
import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

abstract UserId(String) {
  public function new(userId) {
    this = userId;
  }

  public static function gen() : UserId {
    return new UserId(thx.Uuid.create());
  }

  public function toString() : String {
    return this;
  }
}

class User {
  public var id(default, null) : UserId;
  public var name(default, null) : String;

  public function new(id : UserId, name : String) {
    this.id = id;
    this.name = name;
  }

  public static function userIdSchema<E>() : Schema<E, UserId> {
    return iso(string(), function(id) return new UserId(id), function(userId) return userId.toString());
  }

  public static function schema<E>() : Schema<E, User> {
    return object(ap2(
      User.new,
      required("id", userIdSchema(), function(v : User) return v.id),
      required("name", string(), function(v : User) return v.name)
    ));
  }
}

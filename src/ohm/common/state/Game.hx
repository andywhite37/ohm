package ohm.common.state;

abstract GameId(String) to String {
  function new(gameId : String) {
    this = gameId;
  }

  public static function gen() : GameId {
    return new GameId(thx.Uuid.create());
  }
}

class Game {
  public var id(default, null) : GameId;
  public var name(default, null) : String;
  public var users(default, null) : Array<User>;

  public function new(id : GameId, name : String, users : Array<User>) {
    this.id = id;
    this.name = name;
    this.users = users;
  }
}

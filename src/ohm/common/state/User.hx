package ohm.common.state;

abstract UserId(String) to String {
  public function new(userId) {
    this = userId;
  }
}

class User {
  public var id(default, null) : UserId;
  public var name(default, null) : String;

  public function new(id : UserId, name : String) {
    this.id = id;
    this.name = name;
  }
}

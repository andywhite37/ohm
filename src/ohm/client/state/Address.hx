package ohm.client.state;

enum Address {
  Lobby;
  //GameLobby(gameId : String);
  Unknown(location : js.html.Location);
}

class Addresses {
  public static function fromLocation(location : js.html.Location) : Address {
    var hash = location.hash;
    // TODO: parse hash
    return Lobby;
  }

  public static function toHash(address : Address) : String {
    return switch address {
      case Lobby : "lobby";
      case Unknown(location) : location.hash;
    }
  }
}

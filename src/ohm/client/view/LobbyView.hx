package ohm.client.view;

using thx.Arrays;

import doom.core.VNode;
import doom.core.VNodes;
import doom.html.Html.*;

import ohm.common.state.User;
import ohm.common.state.Game;
import ohm.client.state.Loader;

class LobbyView {
  public static function render(data : LobbyViewData) : VNode {
    return div(["class" => "lobby-view"], [
      h1('lobby'),
      renderUsers(data.usersLoader),
      renderGames(data.gamesLoader),
      renderCreateGame()
    ]);
  }

  static function renderUsers(usersLoader : Loader<Array<User>>) : VNode {
    var users : VNodes = switch usersLoader {
      case Idle : "";
      case Loading : span('loading users...');
      case Loaded(users) : users.map(function(user : User) : VNode {
        return div(user.name);
      });
      case Failed(error) : 'Failed to load users';
    };
    return div(["class" => "users"], [
      h2("Users"),
      div(users)
    ]);
  }

  static function renderGames(gamesLoader : Loader<Array<Game>>) : VNode {
    return div(["class" => "games"], [
      h2("Games")
    ]);
  }

  static function renderCreateGame() : VNode {
    return div(["class" => "create-game"], [
      h2("Create game")
    ]);
  }
}

class LobbyViewData {
  public var usersLoader(default, null) : Loader<Array<User>>;
  public var gamesLoader(default, null) : Loader<Array<Game>>;

  public function new(usersLoader, gamesLoader) {
    this.usersLoader = usersLoader;
    this.gamesLoader = gamesLoader;
  }

  public function withUsersLoader(usersLoader : Loader<Array<User>>) : LobbyViewData {
    return new LobbyViewData(usersLoader, gamesLoader);
  }

  public function withGamesLoader(gamesLoader : Loader<Array<Game>>) : LobbyViewData {
    return new LobbyViewData(usersLoader, gamesLoader);
  }
}

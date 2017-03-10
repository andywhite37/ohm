package ohm.client.view;

import haxe.ds.Option;

using thx.Arrays;
using thx.Functions;
using thx.Options;

import doom.core.VNode;
import doom.core.VNodes;
import doom.html.Html.*;

import ohm.common.model.User;
import ohm.common.model.Game;
import ohm.client.Action;
import ohm.client.state.Loader;

class LobbyView {
  public static function render(data : LobbyViewData, dispatch : Action -> Void) : VNode {
    return div(["class" => "lobby-view"], [
      h1('Welcome to the lobby!'),
      h2('Users'),
      renderCurrentUser(data.currentUserLoader, dispatch),
      renderUsers(data.usersLoader),
      h2('Games'),
      renderGames(data.gamesLoader),
      renderCreateGame()
    ]);
  }

  static function renderCurrentUser(currentUserLoader : Loader<User>, dispatch : Action -> Void) : VNode {
    return switch currentUserLoader {
      case Idle : renderCreateUserForm(dispatch);
      case Loading : 'registering...';
      case Loaded(user) : 'You are registered as: ${user.name}';
      case Failed(error) : 'failed to register.';
    };
  }

  static function renderCreateUserForm(dispatch : Action -> Void) : VNode {
    var name : String;
    return form([
      "submit" => function(e : js.html.Event) : Void {
        e.preventDefault();
        dispatch(CreateUser(name));
      }
     ], [
      input([
        "type" => "text",
        "change" => function(input : js.html.InputElement) : Void {
          name = input.value;
        }
      ]),
      button([
        "type" => "submit"
      ], "Register")
    ]);
  }

  static function renderUsers(usersLoader : Loader<Array<User>>) : VNode {
    var users : VNodes = switch usersLoader {
      case Idle : "";
      case Loading : span('loading users...');
      case Loaded(users) :
        users
          .map.fn(_.name)
          .order(thx.Strings.compare)
          .join(", ");
      case Failed(error) : 'Failed to load users';
    };
    return div(["class" => "users"], [
      div(users)
    ]);
  }

  static function renderGames(gamesLoader : Loader<Array<Game>>) : VNode {
    return div(["class" => "games"], [
      div('TODO: list games')
    ]);
  }

  static function renderCreateGame() : VNode {
    return div(["class" => "create-game"], [
      div('TODO: create game')
    ]);
  }
}

class LobbyViewData {
  public var currentUserLoader(default, null) : Loader<User>;
  public var usersLoader(default, null) : Loader<Array<User>>;
  public var gamesLoader(default, null) : Loader<Array<Game>>;

  public function new(currentUserLoader, usersLoader, gamesLoader) {
    this.currentUserLoader = currentUserLoader;
    this.usersLoader = usersLoader;
    this.gamesLoader = gamesLoader;
  }

  public function withCurrentUserLoader(currentUserLoader : Loader<User>) : LobbyViewData {
    return new LobbyViewData(currentUserLoader, usersLoader, gamesLoader);
  }

  public function withUsersLoader(usersLoader : Loader<Array<User>>) : LobbyViewData {
    return new LobbyViewData(currentUserLoader, usersLoader, gamesLoader);
  }

  public function withGamesLoader(gamesLoader : Loader<Array<Game>>) : LobbyViewData {
    return new LobbyViewData(currentUserLoader, usersLoader, gamesLoader);
  }
}

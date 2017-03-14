package ohm.client.view;

import haxe.ds.Option;

import js.html.Event;
import js.html.InputElement;

using thx.Arrays;
using thx.Functions;
using thx.Options;
using thx.Strings;

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
      renderCreateGame(dispatch),
      renderGames(data.currentUserLoader, data.gamesLoader, dispatch)
    ]);
  }

  static function renderCurrentUser(currentUserLoader : Loader<User>, dispatch : Action -> Void) : VNode {
    var currentUser : VNode = switch currentUserLoader {
      case Idle : renderCreateUserForm(dispatch);
      case Loading(message) : message;
      case Loaded(user) : 'You are registered as: ${user.name}';
      case Failed(message) : message;
    };
    return div([
      h3("Registration"),
      div(currentUser)
    ]);
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
        "type" => "submit",
        //"disabled" => name.isEmpty()
      ], "Register")
    ]);
  }

  static function renderUsers(usersLoader : Loader<Array<User>>) : VNode {
    var users : VNodes = switch usersLoader {
      case Idle : "";
      case Loading(message) : message;
      case Loaded(users) if (users.length > 0) :
        users
          .map.fn(_.name)
          .order(thx.Strings.compare)
          .join(", ");
      case Loaded(users) : div("there are no users online right now");
      case Failed(message) : message;
    };
    return div(["class" => "users"], [
      h3("Current users:"),
    ].concat(div(users)));
  }

  static function renderCreateGame(dispatch : Action -> Void) : VNode {
    var name : String = "";
    var playerCount = 5;
    return div(["class" => "create-game"], [
      h3("Create game:"),
      form([
        "submit" => function(e : js.html.Event) : Void {
          e.preventDefault();
          dispatch(CreateGame(name, playerCount));
        }
      ], [
        input([
          "type" => "text",
          "value" => name,
          "placeholder" => "name",
          "change" => function(input : InputElement) : Void {
            name = input.value;
          }
        ]),
        input([
          "type" => "number",
          "min" => "5",
          "max" => "10",
          "step" => "1",
          "value" => Std.string(playerCount),
          "placeholder" => "players",
          "change" => function(input : InputElement) : Void {
            playerCount = Std.parseInt(input.value);
          }
        ]),
        button(["type" => "submit"], "Create game")
      ])
    ]);
  }

  static function renderGames(currentUserLoader : Loader<User>, gamesLoader : Loader<Array<Game>>, dispatch : Action -> Void) : VNode {
    var games : VNodes = switch gamesLoader {
      case Idle : "";
      case Loading(message) : message;
      case Loaded(games) if (games.length > 0) :
        table([
          thead([
            tr([
              th("Game ID"),
              th("Name"),
              th("Player count"),
              th("Players"),
              th("Actions")
            ])
          ]),
          tbody(
            games.map(function(game : Game) : VNode {
              return tr([
                td(game.id.toString()),
                td(game.name),
                td(Std.string(game.playerCount)),
                td(game.users.map.fn(_.name).join(", ")),
                td([
                  joinGameButton(currentUserLoader, game, dispatch),
                  removeGameButton(game, dispatch),
                  startGameButton(currentUserLoader, game, dispatch)
                ])
              ]);
            })
          )
        ]);
      case Loaded(games) : div("no games have been created yet");
      case Failed(message) : message;
    };
    return div(["class" => "games"], [
      h3("Current games:")
    ].concat(div(games)));
  }

  static function joinGameButton(currentUserLoader : Loader<User>, game : Game, dispatch : Action -> Void) : VNode {
    return switch currentUserLoader {
      case Loaded(user) if (!game.hasUser(user)) :
        button([
          "type" => "button",
          "click" => function(e : Event) {
            e.preventDefault();
            dispatch(JoinGame(game.id, user.id));
          }
        ], "Join");
      case _ : "";
    };
  }

  static function removeGameButton(game : Game, dispatch : Action -> Void) : VNode {
    return button([
      "type" => "button",
      "click" => function(e : Event) : Void {
        e.preventDefault();
        dispatch(RemoveGame(game.id));
      }
    ], "Remove");
  }

  static function startGameButton(currentUserLoader : Loader<User>, game : Game, dispatch : Action -> Void) : VNode {
    return switch currentUserLoader {
      case Loaded(user) if (game.canBeStartedByUser(user)) :
        button([
          "type" => "button",
          "click" => function(e : Event) : Void {
            e.preventDefault();
            dispatch(StartGame(game.id));
          }
        ], "Start");
      case _ : "";
    }
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

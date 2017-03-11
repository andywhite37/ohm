package ohm.server.service;

using thx.Arrays;
using thx.Functions;
using thx.Iterators;
using thx.Maps;
import thx.promise.Promise;

import ohm.common.model.Game;
import ohm.common.model.User;

class InMemoryRepository implements IRepository {
  var users(default, null) : Map<String, User>;
  var games(default, null) : Map<String, Game>;

  public function new() {
    users = new Map();
    games = new Map();
  }

  public function getUsers() : Promise<Array<User>> {
    return Promise.value(users.values());
  }

  public function addUser(name : String) : Promise<User> {
    return if (users.values().map.fn(_.name).contains(name)) {
      Promise.fail('user $name already exists');
    } else {
      var userId = UserId.gen();
      var user = new User(userId, name);
      users.set(userId.toString(), user);
      Promise.value(user);
    }
  }

  public function getGames() : Promise<Array<Game>> {
    return Promise.value(games.values());
  }

  public function addGame(name : String) : Promise<Game> {
    return if (games.values().map.fn(_.name).contains(name)) {
      Promise.fail('game $name already exists');
    } else {
      var gameId = GameId.gen();
      var game = new Game(gameId, name, []);
      games.set(game.id.toString(), game);
      Promise.value(game);
    }
  }

  public function joinGame(gameId : GameId, userId : UserId) : Promise<Game> {
    var game = games.get(gameId.toString());
    if (game == null) {
      return Promise.fail('no game found for ID: ${gameId.toString()}');
    }
    var user = users.get(userId.toString());
    if (game == null) {
      return Promise.fail('no user found for ID: ${userId.toString()}');
    }
    var userInGame = game.users.any(function(gameUser) {
      return gameUser.id.toString() == user.id.toString();
    });
    if (userInGame) {
      return Promise.fail('user ${user.name} is already in game ${game.name}');
    }
    game.users.push(user);
    return Promise.value(game);
  }

  public function leaveGame(gameId : GameId, userId : UserId) : Promise<Game> {
    var game = games.get(gameId.toString());
    if (game == null) {
      return Promise.fail('no game found for ID: ${gameId.toString()}');
    }
    var user = users.get(userId.toString());
    if (game == null) {
      return Promise.fail('no user found for ID: ${userId.toString()}');
    }
    var userInGame = game.users.any(function(gameUser) {
      return gameUser.id.toString() == user.id.toString();
    });
    if (!userInGame) {
      return Promise.fail('user ${user.name} is not in game ${game.name}');
    }
    game.users = game.users.filter(function(gameUser) {
      return gameUser.id.toString() != user.id.toString();
    });
    return Promise.value(game);
  }
}

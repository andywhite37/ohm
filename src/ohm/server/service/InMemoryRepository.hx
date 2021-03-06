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

  public function createUser(name : String) : Promise<User> {
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

  public function createGame(name : String, playerCount : Int) : Promise<Game> {
    if (games.values().map.fn(_.name).contains(name)) {
      return Promise.fail('game $name already exists');
    }
    if (playerCount < 5) {
      return Promise.fail('game must have at least 5 players');
    }
    if (playerCount > 10) {
      return Promise.fail('game must have at most 10 players');
    }
    var gameId = GameId.gen();
    var game = new Game(gameId, name, playerCount, []);
    games.set(game.id.toString(), game);
    return Promise.value(game);
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
    if (game.users.length >= game.playerCount) {
      return Promise.fail('game is already full with ${game.playerCount} players');
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

  public function removeGame(gameId : GameId) : Promise<{ removedGame: Game, games: Array<Game> }> {
    var game = games.get(gameId.toString());
    if (game == null) {
      return Promise.fail('no game found for id: ${gameId.toString()}');
    }
    games.remove(gameId.toString());
    return Promise.value({ removedGame: game, games: games.values() });
  }

  public function startGame(gameId : GameId) : Promise<Game> {
    var game = games.get(gameId.toString());
    if (game == null) {
      return Promise.fail('no game found for ID: ${gameId.toString()}');
    }
    //game.gameState = Started;
    return Promise.value(game);
  }
}

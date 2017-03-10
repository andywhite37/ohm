package ohm.server.service;

import thx.promise.Promise;
using thx.Maps;

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

  public function addUser(user : User) : Promise<User> {
    users.set(user.id.toString(), user);
    return Promise.value(user);
  }

  public function getGames() : Promise<Array<Game>> {
    return Promise.value(games.values());
  }
}

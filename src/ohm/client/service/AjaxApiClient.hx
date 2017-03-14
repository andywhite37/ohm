package ohm.client.service;

import thx.promise.Promise;

import ohm.common.model.Game;
import ohm.common.model.User;

class AjaxApiClient implements IApiClient {
  public function new() {}

  public function getUsers() : Promise<Array<User>> {
    return Promise.value([
      //new User(new UserId('user1'), "Andy"),
      //new User(new UserId('user2'), "Franco"),
      //new User(new UserId('user3'), "Kris"),
      //new User(new UserId('user4'), "Michael")
    ]);
  }

  public function getGames() : Promise<Array<Game>> {
    return Promise.value([
      //new Game(GameId.gen(), "Game 1", []),
      //new Game(GameId.gen(), "Game 2", []),
    ]);
  }
}

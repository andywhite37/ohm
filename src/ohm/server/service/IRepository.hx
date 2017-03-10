package ohm.server.service;

import thx.promise.Promise;

import ohm.common.model.Game;
import ohm.common.model.User;

interface IRepository {
  function getUsers() : Promise<Array<User>>;
  function addUser(user : User) : Promise<User>;

  function getGames() : Promise<Array<Game>>;
}

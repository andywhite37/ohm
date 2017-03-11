package ohm.server.service;

import thx.promise.Promise;

import ohm.common.model.Game;
import ohm.common.model.User;

interface IRepository {
  function getUsers() : Promise<Array<User>>;
  function addUser(name : String) : Promise<User>;

  function getGames() : Promise<Array<Game>>;
  function addGame(name : String) : Promise<Game>;

  function joinGame(gameId : GameId, userId : UserId) : Promise<Game>;
  function leaveGame(gameId : GameId, userId : UserId) : Promise<Game>;
}

package ohm.server.service;

import thx.promise.Promise;

import ohm.common.model.Game;
import ohm.common.model.User;

interface IRepository {
  function getUsers() : Promise<Array<User>>;
  function createUser(name : String) : Promise<User>;

  function getGames() : Promise<Array<Game>>;
  function createGame(name : String) : Promise<Game>;

  function joinGame(gameId : GameId, userId : UserId) : Promise<Game>;
  function leaveGame(gameId : GameId, userId : UserId) : Promise<Game>;
  function removeGame(gameId : GameId) : Promise<{ removedGame: Game, games: Array<Game> }>;
  function startGame(gameId : GameId) : Promise<Game>;
}

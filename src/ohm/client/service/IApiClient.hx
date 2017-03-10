package ohm.client.service;

import thx.promise.Promise;

import ohm.common.model.Game;
import ohm.common.model.User;

interface IApiClient {
  function getUsers() : Promise<Array<User>>;
  function getGames() : Promise<Array<Game>>;
}

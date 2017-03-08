package ohm.client.api;

import thx.promise.Promise;

import ohm.common.state.Game;
import ohm.common.state.User;

interface IApiClient {
  function getUsers() : Promise<Array<User>>;
  function getGames() : Promise<Array<Game>>;
}

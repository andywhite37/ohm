package ohm.client;

import ohm.common.model.Game;
import ohm.common.model.User;
import ohm.client.error.LoadError;
import ohm.client.state.Address;

enum Action {
  GoTo(address : Address);

  GetUsers;
  GetUsersSuccess(users : Array<User>);
  GetUsersFailure(error : String);

  CreateUser(name : String);
  CreateUserSuccess(user : User);
  CreateUserFailure(name : String, error : String);

  GetGames;
  GetGamesSuccess(games : Array<Game>);
  GetGamesFailure(error : String);

  CreateGame(name : String);
  CreateGameSuccess(game : Game);
  CreateGameFailure(name : String, error : String);
}

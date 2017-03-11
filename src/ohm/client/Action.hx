package ohm.client;

import ohm.common.model.Game;
import ohm.common.model.User;
import ohm.client.error.LoadError;
import ohm.client.state.Address;

enum Action {
  UnexpectedFailure(message : String);

  AddressChanged(address : Address);

  GetUsers;
  UsersUpdate(users : Array<User>);
  GetUsersFailure(error : String);

  CreateUser(name : String);
  CreateUserSuccess(user : User);
  CreateUserFailure(name : String, error : String);

  GetGames;
  GamesUpdate(games : Array<Game>);
  GetGamesFailure(error : String);

  CreateGame(name : String);
  CreateGameSuccess(game : Game);
  CreateGameFailure(name : String, error : String);

  //JoinGame(game : Game, user : User);
  JoinGameSuccess(game : Game);
  JoinGameFailure(error : String);

  //LeaveGame(game : Game, user : User);
  LeaveGameSuccess(game : Game);
  LeaveGameFailure(error : String);

  GameUpdate(game : Game);
}

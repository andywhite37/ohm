package ohm.client;

import ohm.common.model.Game;
import ohm.common.model.User;
import ohm.client.error.LoadError;
import ohm.client.state.Address;

enum Action {
  UnexpectedFailure(message : String);

  ChangeAddress(address : Address);
  AddressChanged(address : Address);

  GetUsers;
  UsersUpdated(users : Array<User>);
  GetUsersFailure(error : String);

  CreateUser(name : String);
  CreateUserSuccess(user : User);
  CreateUserFailure(name : String, error : String);

  GetGames;
  GamesUpdated(games : Array<Game>);
  GetGamesFailure(error : String);

  CreateGame(name : String);
  CreateGameSuccess(game : Game);
  CreateGameFailure(name : String, error : String);

  JoinGame(gameId : GameId, userId : UserId);
  JoinGameSuccess(game : Game);
  JoinGameFailure(gameId: GameId, error : String);

  LeaveGame(gameId : GameId, userId : UserId);
  LeaveGameSuccess(game : Game);
  LeaveGameFailure(gameId : GameId, error : String);

  RemoveGame(gameId : GameId);
  RemoveGameSuccess(game : Game);
  RemoveGameFailure(gameId : GameId, message : String);
  GameRemoved(game : Game);

  StartGame(gameId : GameId);
  StartGameSuccess(game : Game);
  StartGameFailure(gameId : GameId, message : String);
  GameStarted(game : Game);

  GameUpdated(game : Game);
}

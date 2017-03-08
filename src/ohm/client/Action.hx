package ohm.client;

import ohm.common.state.Game;
import ohm.common.state.User;
import ohm.client.error.LoadError;
import ohm.client.state.Address;

enum Action {
  GoTo(address : Address);

  LoadUsers;
  LoadUsersSuccess(users : Array<User>);
  LoadUsersFailure(error : LoadError);

  LoadGames;
  LoadGamesSuccess(games : Array<Game>);
  LoadGamesFailure(error : LoadError);

  CreateGame(name : String);
}

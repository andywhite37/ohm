package ohm.client.state;

import haxe.ds.Option;

import ohm.client.view.AppView;
import ohm.client.view.LobbyView;

class State {
  public var viewState(default, null) : ViewState;

  public function new(viewState) {
    this.viewState = viewState;
  }

  public static function init() : State {
    return new State(Lobby(new LobbyViewData(Idle, Idle, Idle)));
  }

  public function withViewState(viewState : ViewState) : State {
    return new State(viewState);
  }
}

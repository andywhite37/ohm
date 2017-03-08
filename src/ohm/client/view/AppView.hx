package ohm.client.view;

import doom.core.VNode;
import doom.html.Html.*;

import ohm.client.state.State;

class AppView {
  public static function render(state : State) : VNode {
    return switch state.viewState {
      case Lobby(data) : LobbyView.render(data);
    };
  }
}

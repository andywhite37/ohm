package ohm.client;

import thx.stream.Property;
import thx.stream.Store;

import doom.html.Render;

import ohm.client.service.IApiClient;
import ohm.client.service.IOSocketClient;
import ohm.client.service.ISocketClient;
import ohm.client.service.AjaxApiClient;
import ohm.client.state.Address;
import ohm.client.state.State;
import ohm.client.view.AppView;

class Main {
  public static function main() {
    var apiClient : IApiClient = new AjaxApiClient();
    var socketClient : ISocketClient = new IOSocketClient();

    var state : State = State.init();
    var stateProperty : Property<State> = new Property(state);
    var middleware : Middleware = new Middleware(apiClient, socketClient);
    var store : Store<State, Action> = new Store(stateProperty, Reducer.reduce, middleware.init());
    var render : Render = new Render();

    var dispatch = function(action: Action) : Void {
      store.dispatch(action);
    }

    render.stream(
      store.stream().map(AppView.render.bind(_, dispatch)),
      dots.Query.find("#root")
    );

    js.Browser.window.onhashchange = function(e : js.html.Event) : Void {
      goTo(store, js.Browser.location);
    }
    goTo(store, js.Browser.location);
  }

  static function goTo(store : Store<State, Action>, location : js.html.Location) : Void {
    store.dispatch(GoTo(Addresses.fromLocation(location)));
  }
}

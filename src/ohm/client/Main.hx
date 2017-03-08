package ohm.client;

import npm.socketio.client.IO;
import npm.socketio.client.Socket;

import thx.stream.Property;
import thx.stream.Store;

import doom.html.Render;

import ohm.client.api.IApiClient;
import ohm.client.api.AjaxApiClient;
import ohm.client.state.Address;
import ohm.client.state.State;
import ohm.client.view.AppView;

class Main {
  public static function main() {
    /*
    var socket : Socket = IO.io('/');
    socket.on('message', function(data) {
      trace('mesasge from server', data);
    });
    */

    var apiClient : IApiClient = new AjaxApiClient();

    var state = State.init();
    var stateProperty = new Property(state);
    var middleware = new Middleware(apiClient);
    var store = new Store(stateProperty, Reducer.reduce, middleware.init());
    var render = new Render();

    render.stream(
      store.stream()
        .map(AppView.render),
      dots.Query.find("#root")
    );

    js.Browser.window.onhashchange = function(e : js.html.Event) : Void {
      dispatchGoTo(store);
    }
    dispatchGoTo(store);
  }

  static function dispatchGoTo(store : Store<State, Action>) : Void {
    var address = Addresses.fromLocation(js.Browser.location);
    store.dispatch(GoTo(address));
  }
}

package ohm.client.service;

import haxe.ds.Option;

import npm.socketio.client.IO;
import npm.socketio.client.Socket;

using thx.Arrays;
import thx.Either;
using thx.Functions;

import ohm.common.message.ClientMessage;
import ohm.common.message.ServerMessage;
import ohm.common.util.Serializer;

enum SocketStatus {
  Disconnected;
  Connected(socket : Socket);
}

class IOSocketClient implements ISocketClient {
  var namespace(default, null) : String;
  var status(default, null) : SocketStatus;
  var listeners(default, null): Array<ServerMessage -> Void>;

  public function new(?namespace : String = "/") {
    this.namespace = namespace;
    this.status = Disconnected;
    this.listeners = [];
  }

  public function isConnected() : Bool {
    return switch status {
      case Connected(_) : true;
      case Disconnected : false;
    }
  }

  function ifConnected(callback : Socket -> Void) : Void {
    switch status {
      case Connected(socket) : callback(socket);
      case Disconnected :
    }
  }

  public function connect() : Void {
    if (!isConnected()) {
      trace('socket connect');
      var socket = IO.io(namespace);
      socket.on("server-message", onServerMessage);
      status = Connected(socket);
    }
  }

  public function disconnect() : Void {
    ifConnected(function(socket) {
      trace('socket disconnect');
      socket.removeAllListeners();
      socket.disconnect();
      listeners = []; // TODO: should this be done?
      status = Disconnected;
    });
  }

  public function send(message : ClientMessage) : Void {
    ifConnected(function(socket) {
      trace('socket send $message');
      socket.emit("client-message", Serializer.renderString(ClientMessages.schema(), message));
    });
  }

  function onServerMessage(data : String) : Void {
    trace('socket onServerMessage $data');
    switch Serializer.parseString(ServerMessages.schema(), data).either {
      case Left(errors) : trace('failed to parse server message: $data');
      case Right(message) : notifyListeners(message);
    }
  }

  public function subscribe(listener : ServerMessage -> Void) : Void {
    if (!listeners.contains(listener)) {
      trace('socket subscribe $listener');
      listeners.push(listener);
    }
  }

  public function unsubscribe(listener : ServerMessage -> Void) : Void {
    if (listeners.contains(listener)) {
      listeners.remove(listener);
    }
  }

  function notifyListeners(message : ServerMessage) : Void {
    for (listener in listeners) {
      listener(message);
    }
  }
}

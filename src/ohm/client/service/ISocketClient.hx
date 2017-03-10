package ohm.client.service;

import ohm.common.message.ClientMessage;
import ohm.common.message.ServerMessage;

interface ISocketClient {
  function isConnected() : Bool;
  function connect() : Void;
  function disconnect() : Void;
  function send(message : ClientMessage) : Void;
  function subscribe(listener : ServerMessage -> Void) : Void;
  function unsubscribe(listener : ServerMessage -> Void) : Void;
}

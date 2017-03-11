package ohm.server.service;

import ohm.common.message.ServerMessage;

interface ISocketClient {
  // send to client (sender)
  function sendClient(message : ServerMessage) : Void;

  // send to all clients except sender
  function sendAll(message : ServerMessage) : Void;
  function sendOthers(message : ServerMessage) : Void;

  // send to all clients in room, except sender
  function sendRoomAll(room : String, message : ServerMessage) : Void;
  function sendRoomOthers(room : String, message : ServerMessage) : Void;

  function joinRoom(room : String) : Void;
  function leaveRoom(room : String) : Void;
}

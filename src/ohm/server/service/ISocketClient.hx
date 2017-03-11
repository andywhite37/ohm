package ohm.server.service;

import ohm.common.message.ServerMessage;

interface ISocketClient {
  function sendClient(message : ServerMessage) : Void;

  function sendAll(message : ServerMessage) : Void;
  function sendOthers(message : ServerMessage) : Void;

  function sendRoomAll(room : String, message : ServerMessage) : Void;
  function sendRoomOthers(room : String, message : ServerMessage) : Void;

  function joinRoom(room : String) : Void;
  function leaveRoom(room : String) : Void;
}

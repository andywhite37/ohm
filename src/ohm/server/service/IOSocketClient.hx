package ohm.server.service;

import npm.socketio.Server;
import npm.socketio.Socket;

import ohm.common.message.ServerMessage;
import ohm.common.model.Game;
import ohm.common.model.User;
import ohm.common.util.Serializer;

class IOSocketClient implements ISocketClient {
  var io(default, null) : Server;
  var socket(default, null) : Socket;

  public function new(io : Server, socket : Socket) {
    this.io = io;
    this.socket = socket;
  }

  public function sendClient(message : ServerMessage) : Void {
    socket.emit(serialize(message));
  }

  public function sendAll(message : ServerMessage) : Void {
    io.emit(serialize(message));
  }

  public function sendOthers(message : ServerMessage) : Void {
    socket.broadcast.emit(serialize(message));
  }

  public function sendRoomAll(room : String, message : ServerMessage) : Void {
    io.in_(room).emit(serialize(message));
  }

  public function sendRoomOthers(room : String, message : ServerMessage) : Void {
    socket.to(room).emit(serialize(message));
  }

  public function joinRoom(room : String) : Void {
    socket.join(room);
  }

  public function leaveRoom(room : String) {
    socket.leave(room);
  }

  function serialize(message : ServerMessage) : String {
    return Serializer.renderString(ServerMessages.schema(), message);
  }
}

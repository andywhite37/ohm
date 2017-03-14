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
    trace('sendClient $message');
    socket.emit('server-message', serialize(message));
  }

  public function sendAll(message : ServerMessage) : Void {
    trace('sendAll $message');
    io.emit('server-message', serialize(message));
  }

  public function sendOthers(message : ServerMessage) : Void {
    trace('sendOthers $message');
    socket.broadcast.emit('server-message', serialize(message));
  }

  public function sendRoomAll(room : String, message : ServerMessage) : Void {
    trace('sendRoomAll $room $message');
    io.in_(room).emit('server-message', serialize(message));
  }

  public function sendRoomOthers(room : String, message : ServerMessage) : Void {
    trace('sendRoomOthers $room $message');
    socket.to(room).emit('server-message', serialize(message));
  }

  public function joinRoom(room : String) : Void {
    trace('joinRoom');
    socket.join(room);
  }

  public function leaveRoom(room : String) {
    trace('leaveRoom');
    socket.leave(room);
  }

  function serialize(message : ServerMessage) : String {
    return Serializer.renderString(ServerMessages.schema(), message);
  }
}

package ohm.common.message;

import thx.Either;

import utest.Assert;

import ohm.common.message.ClientMessage;
import ohm.common.util.Serializer;

@:access(ohm.common.util.Serializer)
class TestClientMessage {
  public function new() {}

  public function testRender() {
    Assert.same({ empty: {} }, Serializer.renderDynamic(ClientMessages.schema(), Empty));
    Assert.same(Right(Empty), Serializer.parseDynamic(ClientMessages.schema(), { empty: {} }));

    Assert.same({ createGame: { name: "my game", playerCount: 6 } }, Serializer.renderDynamic(ClientMessages.schema(), CreateGame("my game", 6)));
    Assert.same(Right(CreateGame("my game", 6)), Serializer.parseDynamic(ClientMessages.schema(), { createGame: { name: "my game", playerCount: 6 } }));
  }
}

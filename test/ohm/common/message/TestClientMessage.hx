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

    Assert.same({ createGame: { name: "my game" } }, Serializer.renderDynamic(ClientMessages.schema(), CreateGame("my game")));
    Assert.same(Right(CreateGame("my game")), Serializer.parseDynamic(ClientMessages.schema(), { createGame: { name: "my game" } }));
  }
}

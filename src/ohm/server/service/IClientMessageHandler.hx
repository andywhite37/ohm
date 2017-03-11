package ohm.server.service;

import ohm.common.message.ClientMessage;

interface IClientMessageHandler {
  function handleString(data : String) : Void;
  function handleClientMessage(message : ClientMessage) : Void;
}

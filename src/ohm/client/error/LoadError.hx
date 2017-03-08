package ohm.client.error;

class LoadError extends thx.Error {
  public function new(message, ?stack, ?pos) {
    super(message, stack, pos);
  }
}

package ohm.client.state;

import ohm.client.error.LoadError;

enum Loader<T> {
  Idle;
  Loading(message : String);
  Loaded(data : T);
  Failed(message : String);
}

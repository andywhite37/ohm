package ohm.client.state;

import ohm.client.error.LoadError;

enum Loader<T> {
  Idle;
  Loading;
  Loaded(data : T);
  Failed(message : String);
}

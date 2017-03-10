package ohm.common.util;

import haxe.Json;

using thx.Eithers;
using thx.Functions;
import thx.Nel;
import thx.Validation;
import thx.Validation.*;

using thx.schema.ParseError;
import thx.schema.SimpleSchema;
using thx.schema.SchemaDynamicExtensions;

class Serializer {
  static function parseDynamic<V>(schema : Schema<String, V>, value : Dynamic) : VNel<String, V> {
    return schema.parseDynamic(thx.Functions.identity, value)
      .leftMap(function(parseErrors : Nel<ParseError<String>>) : Nel<String> {
        return parseErrors.map.fn(_.toString());
      });
  }

  static function renderDynamic<V>(schema : Schema<String, V>, value : V) : Dynamic {
    return schema.renderDynamic(value);
  }

  public static function parseString<V>(schema: Schema<String, V>, value: String) : VNel<String, V> {
    return parseDynamic(schema, Json.parse(value));
  }

  public static function renderString<V>(schema: Schema<String, V>, value: V, ?pretty : Bool = true) : String {
    var stringify = if (pretty) {
      Json.stringify.bind(_, null, '  ');
    } else {
      Json.stringify.bind(_, null, '');
    }
    return stringify(renderDynamic(schema, value));
  }
}

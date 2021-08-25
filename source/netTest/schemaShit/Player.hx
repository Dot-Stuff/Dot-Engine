package netTest.schemaShit;

import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class Player extends Schema
{
    @:type("number")
    public var x: Dynamic = 0;

    @:type("number")
    public var y: Dynamic = 0;

    @:type("boolean")
    public var left: Bool = false;

    @:type("boolean")
    public var right: Bool = false;

    @:type("boolean")
    public var up: Bool = false;

    @:type("boolean")
    public var down: Bool = false;
}

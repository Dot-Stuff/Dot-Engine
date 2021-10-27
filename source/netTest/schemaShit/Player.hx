package netTest.schemaShit;

import io.colyseus.serializer.schema.Schema;

class Player extends Schema
{
    @:type("boolean")
    public var left: Bool = false;

    @:type("boolean")
    public var right: Bool = false;

    @:type("boolean")
    public var up: Bool = false;

    @:type("boolean")
    public var down: Bool = false;
}

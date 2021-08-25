package netTest.schemaShit;

import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class MyRoomState extends Schema
{
    /*@:type("string")
    public var move: String = "";

    @:type("string")
    public var direction: String = "";*/

    @:type("player")
    public var players:ArraySchema<Player>;
}

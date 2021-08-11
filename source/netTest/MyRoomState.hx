package netTest;

import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class MyRoomState extends Schema {
    @:type("string")
    public var mySynchronizedProperty: String = "";

    @:type("string")
    public var funny: String = "";
}
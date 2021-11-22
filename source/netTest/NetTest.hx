package netTest;

import netTest.schemaShit.BattleState;
import flixel.addons.ui.FlxInputText;
import io.colyseus.Client;
import io.colyseus.Room;

class NetTest extends MusicBeatState
{
    private var client:Client;
    private var room:Room<BattleState>;

    private var typeText:FlxInputText;

    override function create()
    {
        super.create();
        client = new Client("ws://localhost:2567");

        typeText = new FlxInputText(10, 10);
        add(typeText);

        client.joinOrCreate("my_room", [], BattleState, function(err, room)
        {
            if (err != null)
            {
                trace("ERROR: " + err);
                return;
            }

            this.room = room;

            /*room.state.entities.onAdd = function(entity, key) {
                        trace("entity added at " + key + " => " + entity);

                        entity.onChange = function (changes) {
                            trace("entity changes => " + changes);
                        }
            }*/
            /*room.state.entities.onChange = function(entity, key) {
                trace("entity changed at " + key + " => " + entity);
            }*/
            /*room.state.entities.onRemove = function(entity, key) {
                trace("entity removed at " + key + " => " + entity);
            }*/

            this.room.onMessage("chat", function(message)
            {
                trace(message);
            });

            this.room.onMessage("type", function(message)
            {
                trace("onMessage: 'type' => " + message);
            });

            this.room.onError += function(code:Int, message:String)
            {
                trace("ROOM ERROR: " + code + " => " + message);
            };

            this.room.onLeave += function()
            {
                trace("ROOM LEAVE");
            };
        });
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE)
        {
            room.send('type', {funny: 'lmfao'});
        }

        if (FlxG.keys.justPressed.ENTER)
        {
            room.send('chat', typeText.text);
        }

        if (FlxG.keys.justPressed.U)
        {
            client.getAvailableRooms("my_room", function(err, rooms)
            {
                if (err != null)
                {
                    trace("JOIN ERROR: " + err);
                    return;
                }
    
                for (room in rooms)
                {
                    trace("RoomAvailable:");
                    trace("roomID: " + room.roomId);
                    trace("clients: " + room.clients);
                    trace("maxClients: " + room.maxClients);
                    trace("metadata: " + room.metadata);
                }
            });
        }
    }
}
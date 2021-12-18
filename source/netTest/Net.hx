package netTest;

import io.colyseus.*;
import netTest.schemaShit.BattleState;

enum ConnectionTypes
{
	None;
	Connecting;
	Connected;
}

class Net
{
	public static var client(default, null):Client;
	public static var room(default, null):Room<BattleState>;
    public static var connection(default, null):ConnectionTypes = ConnectionTypes.None;

	public static function init()
	{
		if (client == null)
		{
			client = new Client('ws://localhost:2567');
		}
        else if (room != null)
            leaveCurrentRoom();

        connection = ConnectionTypes.Connecting;

		client.joinOrCreate("battle", ["song" => "ugh"], BattleState, function(err, room)
		{
			if (err != null)
			{
				trace('JOIN ERROR: $err');
				return;
			}

            trace("Joined successfully");

			Net.room = room;
            connection = ConnectionTypes.Connected;

			room.onMessage("type", function(message)
			{
				trace("onMessage: 'type' => " + message);
			});

			room.onMessage("hitNote", function(message)
			{
				trace("onMessage: 'hitNote' => " + message);
			});
		});
	}

	public static function leaveCurrentRoom()
	{
		if (client == null)
			throw "Attempting to leave current room before client is setup";

		if (room != null)
			room.leave();

		room = null;
	}

	inline static public function send(type:Dynamic, data:Dynamic)
	{
		if (Net.connection != Connected)
			return;

		room.send(type, data);
	}

    inline static public function onMessage(type:Dynamic, callback:Dynamic->Void)
    {
		if (Net.connection != Connected)
			return;

        room.onMessage(type, callback);
    }
}

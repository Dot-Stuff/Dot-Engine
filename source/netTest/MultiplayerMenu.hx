package netTest;

import io.colyseus.Client;
import netTest.schemaShit.BattleState;

class MultiplayerMenu
{
	static var client:Client = new Client('ws://localhost:2567');

	public static function init()
	{
		client.joinOrCreate("battle", [], BattleState, function(err, room)
		{
			if (err != null)
			{
				trace('JOIN ERROR: $err');
				return;
			}

			room.state.players.onAdd = function(player, key)
			{
				trace("player added at " + key + " => " + player);
			}
		});
	}
}

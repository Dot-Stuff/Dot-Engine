package netTest;

import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import io.colyseus.Client;
import netTest.schemaShit.BattleState;

class MultiplayerMenu extends MusicBeatState
{
	private var client:Client = new Client('ws://localhost:2567');

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, 0.17);
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		client.joinOrCreate("battle", [], BattleState, function(err, room)
		{
			if (err != null)
			{
				trace("JOIN ERROR: " + err);
				return;
			}

			/*room.state.players.onAdd = function(player, key) {
				trace("player added at " + key + " => " + player);
			}*/
		});

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
			FlxG.switchState(new TitleState());

		super.update(elapsed);
	}
}

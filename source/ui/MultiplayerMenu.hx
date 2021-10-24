package ui;

import MainMenuState.MainMenuList;
import netTest.Dad;
import netTest.schemaShit.Player;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import io.colyseus.Room;
import io.colyseus.Client;
import netTest.schemaShit.MyRoomState;

// How about multiplayer in v2.0
class MultiplayerMenu extends MusicBeatState
{
	private var client:Client;
	private var room:Room<MyRoomState>;

	public static var connectedToServer:Bool = false;

	public static var dads:Map<String, Dad> = new Map();

	public static var clientID:String = "";

	var menuItems:MainMenuList;

	public override function create()
	{
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(Paths.image('menuDesat'));
		bg.color = FlxColor.PURPLE;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set(0, 0);
		add(bg);

		#if LOCALSHIT
		client = new Client('ws://localhost:2567');
		#else
		client = new Client('ws://71.188.110.159:2567');
		#end

		menuItems = new MainMenuList();
		add(menuItems);

		menuItems.enabled = false;

		menuItems.createItem('quick play', function()
		{
			client.joinOrCreate("my_room", [], MyRoomState, function(err, room)
			{
				if (err != null)
				{
					trace("join error: " + err);
					connectedToServer = false;
					return;
				}

				connectedToServer = true;

				this.room = room;

				clientID = room.sessionId;

				room.state.players.onAdd = function(player, key)
				{
					trace('PLAYER ADDED AT: ', key);
				};

				/*room.state.players.onAdd = function(player, key)
				{
					trace('PLAYER ADDED AT: ', key);

					var playerDad = new Dad(0, 0, true); //room.sessionId == key);
					playerDad.syncPos = funnySync;

					//dads[key] = playerDad;
					//playerDad.x = player.x;
					//playerDad.y = player.y;
					add(playerDad);
				};

				room.state.players.onChange = function(player, key)
				{
					trace('PLAYER CHANGED AT: ', key);

					//dads[key].x = player.x;
					//dads[key].y = player.y;
				};

				room.state.players.onRemove = function(player, key)
				{
					trace('PLAYER REMOVED AT: ', key);
					//remove(dads[key]);
				};*/

				room.onMessage("move", function(message)
				{
					trace("onMessage: 'move' => " + message);
				});

				room.onMessage("movePlayer", function(message)
				{
					dads[message.keys].curDirPressed = message.data;
					trace(dads[message.keys].curDirPressed);
				});

				room.onStateChange += function(state)
				{
					trace("new state:" + Std.string(state));
				};

				room.onError += function(code, message)
				{
					trace("oops, error ocurred:");
					trace(message);
				};

				room.onLeave += function()
				{
					trace("client left the room");
				};
			});
		});

		var crap = (FlxG.height - 160 * (menuItems.length - 1)) / 2;
		for (i in 0...menuItems.length)
		{
			var member = menuItems.members[i];
			
			member.x = FlxG.width / 2;
			member.y = crap + 160 * i;
		}
	}

	function funnySync():Void
	{
		room.send('syncPosition', {x: getMainPlayer().x, y: getMainPlayer().y});
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (connectedToServer)
		{
			if (FlxG.keys.justPressed.W)
				moveShit({y: -1});
			if (FlxG.keys.justPressed.S)
				moveShit({y: 1});
			if (FlxG.keys.justPressed.D)
				moveShit({x: -1});
			if (FlxG.keys.justPressed.A)
				moveShit({x: -1});

			if (FlxG.keys.justReleased.W)
				moveShit({y: 0});
			if (FlxG.keys.justReleased.S)
				moveShit({y: 0});
			if (FlxG.keys.justReleased.D)
				moveShit({x: 0});
			if (FlxG.keys.justReleased.A)
				moveShit({x: 0});
		}

		if (controls.BACK && menuItems.enabled && !menuItems.busy)
		{
			FlxG.switchState(new MainMenuState());

			if (connectedToServer)
			{
				// consented leave
				room.leave();

				// unconsented leave
				room.leave(false);
			}
		}
	}

	function getMainPlayer():Dad
	{
		return dads[room.sessionId];
	}

	private function moveShit(dirShit:Dynamic)
	{
		var left = dirShit.x < 0;
		var right = dirShit.x > 0;
		var up = dirShit.y < 0;
		var down = dirShit.y > 0;

		var funnyArray:Array<Bool> = [left, right, up, down];

		room.send("move", funnyArray);
	}
}

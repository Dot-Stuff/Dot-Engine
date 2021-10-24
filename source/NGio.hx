package;

import flixel.util.FlxSignal;
import io.newgrounds.objects.Error;
import io.newgrounds.NG;
import io.newgrounds.NGLite;
import io.newgrounds.objects.events.Response;
import io.newgrounds.objects.events.Result.GetCurrentVersionResult;
import lime.app.Application;

using StringTools;

enum ConnectionResult
{
	Success;
	Fail(msg:String);
	Cancelled;
}

/**
 * MADE BY GEOKURELI THE LEGENED GOD HERO MVP
 */
class NGio
{
	public static var ngDataLoaded(default, null):FlxSignal = new FlxSignal();

	public static var savedSessionFailed:Bool = false;
	public static var GAME_VER:String = "";

	public static function checkVersion(func:String->Void)
	{
		trace("checking NG.io version");
		GAME_VER = "v" + Application.current.meta.get('version');

		if (APIStuff.API == GAME_VER)
		{
			var call = NG.core.calls.app.getCurrentVersion(GAME_VER).addDataHandler(function(response:Response<GetCurrentVersionResult>)
			{
				GAME_VER = response.result.data.currentVersion;
				trace('CURRENT NG VERSION: ' + GAME_VER);
				func(GAME_VER);
			});

			call.send();
		}
		else
			func(GAME_VER);
	}

	public static function init()
	{
		var api = APIStuff.API;
		if (api == null || api.length == 0)
			trace('Missing Newgrounds API key, aborting connection');
		else
		{
			trace('connecting to newgrounds');

			var session = NGLite.getSessionId();
			if (session != null)
				trace('found web session id');

			var onSessionFail:Error->Void = null;

			if (session == null && FlxG.save.data.sessionId != null)
			{
				trace('using stored session id');
				session = FlxG.save.data.sessionId;

				onSessionFail = function(error:Error)
				{
					savedSessionFailed = true;
				}
			}

			NG.create(api, session, false, onSessionFail);

			if (NG.core.attemptingLogin)
				trace('attempting login');

			NG.core.onLogin.add(onNGLogin);
		}
	}

	// Add check if we have a API
	public static function login(a:Dynamic, b:ConnectionResult->Void)
	{
		trace('Logging in manually');

		var onPending:Void->Void = null;
		var onSuccess:Void->Void = onNGLogin;
		var onFail:Error->Void = null;
		var onCancel:Void->Void = null;

		if (a != null)
			onPending = function() {
				a(NG.core.openPassportUrl);
			}

		if (b != null)
		{
			onSuccess = function() {
				onNGLogin();
				b(Success);
			}

			onFail = function(fail) {
				b(Fail(fail.message));
			}

			onCancel = function() {
				b(Cancelled);
			}
		}

		NG.core.requestLogin(onSuccess, onPending, onFail, onCancel);
	}

	static function onNGLogin():Void
	{
		trace('logged in! user:${NG.core.user.name}');
		FlxG.save.data.sessionId = NG.core.sessionId;
		FlxG.save.flush();
		// Load medals then call onNGMedalFetch()
		NG.core.requestMedals(onNGMedalFetch);

		// Load Scoreboards hten call onNGBoardsFetch()
		NG.core.requestScoreBoards(onNGBoardsFetch);

		ngDataLoaded.dispatch();
	}

	public static function logout()
	{
		NG.core.logOut();
		FlxG.save.data.sessionId = null;
		FlxG.save.flush();
	}

	/**
	 * MEDALS
	 */
	static function onNGMedalFetch():Void
	{
		/*
			// Reading medal info
			for (id in NG.core.medals.keys())
			{
				var medal = NG.core.medals.get(id);
				trace('loaded medal id:$id, name:${medal.name}, description:${medal.description}');
			}

			// Unlocking medals
			var unlockingMedal = NG.core.medals.get(54352);// medal ids are listed in your NG project viewer
			if (!unlockingMedal.unlocked)
				unlockingMedal.sendUnlock();
		 */
	}

	/**
	 * SCOREBOARDS
	 */
	static function onNGBoardsFetch():Void
	{
		/*
			// Reading medal info
			for (id in NG.core.scoreBoards.keys())
			{
				var board = NG.core.scoreBoards.get(id);
				trace('loaded scoreboard id:$id, name:${board.name}');
			}
		 */
		// var board = NG.core.scoreBoards.get(8004);// ID found in NG project view

		// Posting a score thats OVER 9000!
		// board.postScore(FlxG.random.int(0, 1000));

		// --- To view the scores you first need to select the range of scores you want to see ---
		trace("shoulda got score by NOW!");
		// board.requestScores(20);// get the best 10 scores ever logged
		// more info on scores --- http://www.newgrounds.io/help/components/#scoreboard-getscores
	}

	inline static public function logEvent(event:String)
	{
		NG.core.calls.event.logEvent(event).send();
		trace('should have logged: ' + event);
	}

	inline static public function unlockMedal(id:Int)
	{
		if (NG.core != null && NG.core.loggedIn)
		{
			var medal = NG.core.medals.get(id);
			if (medal.unlocked)
				medal.sendUnlock();
		}
	}

	inline static public function postScore(score:Int = 0, song:String)
	{
		if (NG.core != null && NG.core.loggedIn)
		{
			for (id in NG.core.scoreBoards.keys())
			{
				var board = NG.core.scoreBoards.get(id);

				if (song == board.name)
				{
					board.postScore(score, "Uhh meow?");
				}

				// trace('loaded scoreboard id:$id, name:${board.name}');
			}
		}
	}
}

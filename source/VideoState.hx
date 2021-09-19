package;

import openfl.net.NetConnection;
import openfl.events.NetStatusEvent;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import openfl.events.AsyncErrorEvent;
import openfl.net.NetStream;
import openfl.media.Video;

class VideoState extends MusicBeatSubstate
{
	var video:Video;
	var netStream:NetStream;
    var overlay:Sprite;

	public override function create()
	{
		super.create();

		if (Main.seenCutscene)
		{
			FlxG.save.data.seenVideo = true;
			FlxG.save.flush();

			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}

		new FlxVideo('kickstarterTrailer').finishCutscene = function()
		{
			trace('penis');
		}

		video = new Video();
		//addChild(video);

		var netConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};

		netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netStream_onAsyncError);
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_onNetStatus);
		netStream.play(Paths.video('kickstarterTrailer'));

		overlay = new Sprite();
        overlay.graphics.beginFill(0, 0.5);
		overlay.graphics.drawRect(0, 0, 1280, 720);
		overlay.addEventListener(MouseEvent.MOUSE_DOWN, overlay_onMouseDown);
		overlay.buttonMode = true;
	}

	public override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			finishVid();

		super.update(elapsed);
	}

	private function finishVid()
	{
		netStream.dispose();

		if (FlxG.game.contains(video))
		{
			FlxG.game.removeChild(video);
			switchTo(new PlayState());
		}
	}

	private function client_onMetaData(metaData:Dynamic)
	{
		video.attachNetStream(netStream);

		video.width = video.videoWidth;
		video.height = video.videoHeight;
	}

	private function netStream_onAsyncError(event:AsyncErrorEvent):Void
	{
		trace("Error loading video");
	}

    private function netConnection_onNetStatus(event:NetStatusEvent):Void
    {
        if (event.info.code == "NetStream.Play.Complete")
        {
            finishVid();
            trace(event.toString());
        }
    }

    private function overlay_onMouseDown(event:MouseEvent):Void
    {
        video.clear();
    }
}

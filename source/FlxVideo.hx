package;

import flixel.FlxBasic;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

class FlxVideo extends FlxBasic
{
	public var finishCutscene:Void->Void;

	var video:Video;
	var netStream:NetStream;

	public function new(name:String)
	{
		super();

		video = new Video();
		video.x = 0;
		video.y = 0;
		FlxG.addChildBelowMouse(video);

		var netConnection = new NetConnection();
		netConnection.connect(null);
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_onNetStatus);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};

		netStream.play(Paths.video(name));
	}

	public function finishVideo()
	{
		netStream.dispose();

		if (FlxG.game.contains(video))
		{
			FlxG.game.removeChild(video);

			if (finishCutscene != null)
				finishCutscene();
		}
	}

	private function client_onMetaData(metaData:Dynamic)
	{
		video.attachNetStream(netStream);

		video.width = video.videoWidth;
		video.height = video.videoHeight;
	}

	private function netConnection_onNetStatus(event:NetStatusEvent):Void
	{
		if (event.info.code == "NetStream.Play.Complete")
		{
			finishVideo();
		}
	}
}

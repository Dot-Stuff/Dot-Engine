package;

import openfl.events.MouseEvent;
import openfl.events.AsyncErrorEvent;
import openfl.events.NetStatusEvent;
import openfl.display.Sprite;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

class FlxVideo extends Sprite
{
	public var finishCutscene:Void->Void;
	public var finishCallback:Void->Void;

	var video:Video;
	var netStream:NetStream;

	public function new(name:String)
	{
		super();

		var netConnection = new NetConnection();
		netConnection.connect(null);
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_onNetStatus);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};
		netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netStream_onAsyncError);

		video = new Video();
		addChild(video);

		netStream.play(Paths.video(name));
	}

	public function finishVideo()
	{
		netStream.dispose();

		if (contains(video))
		{
			removeChild(video);

			if (finishCallback != null)
				finishCallback();
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
		trace("Error loading video: " + event.toString());
	}

	private function netConnection_onNetStatus(event:NetStatusEvent):Void
	{
		if (event.info.code == "NetStream.Play.Complete")
		{
			finishCutscene();
		}
	}
}

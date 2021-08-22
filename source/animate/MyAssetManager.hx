package animate;

import animateAtlasPlayer.assets.AssetManager;

class MyAssetManager extends AssetManager
{
	public override function enqueue(url:String):Void
	{
		if (getExtensionFromUrl(url) == "zip")
		{
			trace("TODO: zip package");
		}
		else
		{
			// TODO_2020: gerer la numérotation des spritemap

			enqueueSingle('$url/spritemap1.png');
			enqueueSingle('$url/spritemap1.json');
			enqueueSingle('$url/Animation.json');
		}
	}
}

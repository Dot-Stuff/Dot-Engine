package animate;

import openfl.display.Sprite;
import animateAtlasPlayer.assets.AssetManager;
import animateAtlasPlayer.core.Animation;
import flixel.FlxState;

class AnimateTankman extends Sprite
{
	public function new()
	{
		super();
		
		var assets:MyAssetManager = new MyAssetManager();
		// target the folder that contains the Animation.json, spritemap.json and spritemap.png
		assets.enqueue("assets/images/tightBars");
		assets.loadQueue(start);
	}

	private function start(assetsMgr:AssetManager):Void
	{
		var myAnimation:Animation = assetsMgr.createAnimation("tankman_fnf_lip_sync_back_ta_dave");
		addChild(myAnimation);
	}
}

class AnimateState extends FlxState
{
	override function create()
	{
		super.create();

		new AnimateTankman();
		//add(tankman);
	}
}

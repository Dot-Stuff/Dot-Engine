package ui.animDebugShit;

import lime.utils.Assets;
import js.html.FileList;
import js.html.URL;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxFrame;
#if sys
import sys.io.File;
#end
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;

class DebugBoundingState extends FlxState
{
    var bg:FlxSprite;
    var fileIntro:FlxText;

    var txtGrp:FlxGroup;

    var hudCam:FlxCamera;

    var charInput:FlxUIDropDownMenu;

    var curView:ANIMDEBUGVIEW = SPRITESHEET;

    var spriteSheetView:FlxGroup;
    var offsetView:FlxGroup;
    var animDropDownMenu:FlxUIDropDownMenu;
    var dropDownSetup:Bool = false;

    var onionSkinChar:FlxSprite;
    var txtOffsetShit:FlxText;

    override function create()
    {
        Paths.setCurrentLevel('week1');

        hudCam = new FlxCamera();
        hudCam.bgColor.alpha = 0;

        FlxG.cameras.add(hudCam, false);

        bg = FlxGridOverlay.create(10, 10);

        bg.scrollFactor.set();
        add(bg);

        initOffsetView();

        super.create();
    }

    var bf:FlxSprite;
    var swagOutlines:FlxSprite;

    function initSpriteSheetView():Void
    {
        spriteSheetView = new FlxGroup();
        add(spriteSheetView);

        var tex = Paths.getSparrowAtlas('characters/temp');

        bf = new FlxSprite();
        bf.loadGraphic(tex.parent);
        spriteSheetView.add(bf);

        swagOutlines = new FlxSprite().makeGraphic(tex.parent.width, tex.parent.height, FlxColor.TRANSPARENT);

        generateOutlines(tex.frames);

        txtGrp = new FlxGroup();
        txtGrp.cameras = [hudCam];
        spriteSheetView.add(txtGrp);

        addInfo('boyfriend.xml', "");
        addInfo('Width', bf.width);
        addInfo('Height', bf.height);

        swagOutlines.antialiasing = true;
        spriteSheetView.add(swagOutlines);

        FlxG.stage.window.onDropFile.add(function(path:String) 
        {
            #if web
            var swagList:FileList = cast path;

            var objShit = URL.createObjectURL(swagList.item(0));
            trace(objShit);

            remove(bf);
            Assets.cache.clear();

            bf.loadGraphic(objShit);
            add(bf);
            #end
            #if sys
            trace("DROPPED FILE FROM: " + Std.string(path));
            var newPath = "./" + Paths.loadImage('characters/temp');
            File.copy(path, newPath);

            var swag = Paths.loadImage('characters/temp');

            if (bf != null)
                remove(bf);
            FlxG.bitmap.removeByKey(Paths.loadImage('characters/temp'));
            Assets.cache.clear();

            bf.loadGraphic(Paths.loadImage('characters/temp'));
            add(bf);
            #end
        });
    }

    function generateOutlines(frameShit:Array<FlxFrame>):Void
    {
        
    }

	function addInfo(name:String, value:Dynamic)
    {

    }

	function initOffsetView()
    {
        
    }
}

enum ANIMDEBUGVIEW
{
    SPRITESHEET;
}
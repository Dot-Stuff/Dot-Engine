package ui;

import NGio.ConnectionResult;
import io.newgrounds.NG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxSubState;

class NgPrompt extends Prompt
{
    public function new(name:String, buttonStyle:ButtonStyle = Yes_No)
    {
        super(name, buttonStyle);
    }

    public static function showLogin():FlxSubState {
        return showLoginPrompt(true);
    }

    public static function showSavedSessionFailed():FlxSubState {
        return showLoginPrompt(false);
    }

    public static function showLoginPrompt(show:Bool):FlxSubState
    {
        var b = new NgPrompt("Talking to server...", None);

        var c:Dynamic = function(c) {
            var d = show ? "Login to Newgrounds?" : "Your session has expired.\n Please login again.";
            if (d != null)
            {
                b.setText(d);
                b.setButtons(Yes_No);
                b.buttons.getItem('yes').fireInstantly = true;
                b.onYes = function() {
                    b.setText('Connecting...\n(check your popup blocker)');
                    b.setButtons(None);
                    c();
                }
                
                b.onNo = function() {
                    b.close();
                    b = null;
                    NG.core.cancelLoginRequest();
                }
            }
            else
            {
                b.setText('Connecting...');
                c();
            }
        }

        var d:ConnectionResult->Void = function(a) {
            switch (a)
            {
                case Success:
                    b.setText('Login Successful');
                    b.setButtons(Ok);
                    b.onYes = b.close;
                case Fail(msg):
                    trace('Login Error: ' + msg);
                    b.setText('Login failed');
                    b.setButtons(Ok);
                    b.onYes = b.close;
                case Cancelled:
                    if (b != null)
                    {
                        b.setText('Login cancelled by user');
                        b.setButtons(Ok);
                        b.onYes = b.close;
                    }
                    else
                        trace('Login cancelled via prompt');
            }
        }

        b.openCallback = function() {
            NGio.login(c, d);
        }

        return b;
    }
}

class Prompt extends FlxSubState
{
    public var style:ButtonStyle;
    public var buttons:TextMenuList;
    public var field:AtlasText;

    public var onYes:Void->Void;
    public var onNo:Void->Void;

    public function new(name:String, buttonStyle:ButtonStyle = Ok)
    {
        style = buttonStyle;

        super(-2147483648);

        buttons = new TextMenuList(Horizontal);

        field = new AtlasText(0, 0, name, Bold);
        field.scrollFactor.set(0, 0);
    }

    public override function create()
    {
        super.create();

        field.y = 100;
        field.screenCenter(X);
        add(field);

        createButtons();

        add(buttons);
    }

    public function createBg(bgWidth:Int, bgHeight:Int, bgColor:FlxColor = -8355712)
    {
        var back:FlxSprite = new FlxSprite();
        back.makeGraphic(bgWidth, bgHeight, bgColor, false, 'prompt-bg');
        back.screenCenter(XY);
        add(back);

        members.unshift(members.pop());
    }

    public function createBgFromMargin(bgSize:Float = 100, bgColor:FlxColor = -8355712)
    {
        createBg(Std.int(FlxG.width * bgSize), Std.int(FlxG.height * bgSize), bgColor);
    }

    public function setButtons(btnStyle:ButtonStyle)
    {
        if (btnStyle != style)
        {
            style = btnStyle;
            createButtons();
        }
    }

    public function createButtons()
    {
        for (i in 0...buttons.members.length)
        {
            buttons.remove(buttons.members[0], true).destroy();

            switch (style)
            {
                case Ok:
                    createButtonsHelper('ok');
                case Yes_No:
                    createButtonsHelper('yes', 'no');
                case Custom(yes, no):
                    createButtonsHelper(yes, no);
                case None:
                    buttons.set_exists(false);
            }
        }
    }

    public function createButtonsHelper(yes:String, ?no:String)
    {
        buttons.set_exists(true);
        var yesBtn:ui.MenuItem = buttons.createItem(0, 0, yes, null, function()
        {
            onYes();
        });

        yesBtn.screenCenter(X);
        yesBtn.y = FlxG.height - yesBtn.height - 100;
        yesBtn.scrollFactor.set(0, 0);

        if (no != null)
        {
            yesBtn.x = FlxG.width - yesBtn.width - 100;
            var noBtn:ui.MenuItem = buttons.createItem(0, 0, no, null, function()
            {
                onNo();
            });

            noBtn.x = 100;
            noBtn.y = FlxG.height - noBtn.height - 100;
            noBtn.scrollFactor.set(0, 0);
        }
    }

    public function setText(a)
    {
        field.set_text(a);
        field.screenCenter(X);
    }
}
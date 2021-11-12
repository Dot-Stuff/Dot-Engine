package ui;

import ui.MenuTypedList.TextMenuList;
import NGio.ConnectionResult;
#if newgrounds
import io.newgrounds.NG;
#end
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxSubState;

enum ButtonStyle
{
    Ok;
    Yes_No;
    Custom(yes:String, no:String);
    None;
}

class Prompt extends FlxSubState
{
    public var back:FlxSprite;
    public var style:ButtonStyle;
    public var buttons:TextMenuList;
    public var field:AtlasText;

    public var onYes:Void->Void;
    public var onNo:Void->Void;

    public function new(name:String, buttonStyle:ButtonStyle = Ok)
    {
        style = buttonStyle;

        super(0x80000000);

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
        back = new FlxSprite().makeGraphic(bgWidth, bgHeight, bgColor, false, 'prompt-bg');
        back.screenCenter(XY);
        add(back);

        members.unshift(members.pop());
    }

    public function createBgFromMargin(bgSize:Float = 100, bgColor:FlxColor = -8355712)
    {
        createBg(Std.int(FlxG.width - 2 * bgSize), Std.int(FlxG.height - 2 * bgSize), bgColor);
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
                buttons.exists = false;
        }
    }

    public function createButtonsHelper(option1:String, ?option2:String)
    {
        buttons.exists = true;
        var yesBtn = buttons.createItem(0, 0, option1, null, function()
        {
            onYes();
        });

        yesBtn.screenCenter(X);
        yesBtn.y = FlxG.height - yesBtn.height - 100;
        yesBtn.scrollFactor.set(0, 0);

        if (option2 != null)
        {
            yesBtn.x = FlxG.width - yesBtn.width - 100;
            var noBtn = buttons.createItem(0, 0, option2, null, function()
            {
                onNo();
            });

            noBtn.x = 100;
            noBtn.y = FlxG.height - noBtn.height - 100;
            noBtn.scrollFactor.set(0, 0);
        }
    }

    public function setText(text:String)
    {
        field.text = text;
        field.screenCenter(X);
    }
}

class NgPrompt extends Prompt
{
    public function new(name:String, buttonStyle:ButtonStyle = Yes_No)
    {
        super(name, buttonStyle);
    }

    public static function showLogin():FlxSubState {
        return showLoginPrompt(true);
    }

    public static function showLogout():NgPrompt {
        var ngPrompt = new NgPrompt('Logout of ${NG.core.user.name}?', Yes_No);
        ngPrompt.onYes = function()
        {
            NGio.logout();
            ngPrompt.close();
        };

        ngPrompt.onNo = ngPrompt.close;
        return ngPrompt;
    }

    public static function showSavedSessionFailed():FlxSubState {
        return showLoginPrompt(false);
    }

    public static function showLoginPrompt(show:Bool):FlxSubState
    {
        var ngPrompt = new NgPrompt("Talking to server...", None);

        var whatever = function(c:Void->Void) {
            var d = show ? "Login to Newgrounds?" : "Your session has expired.\n Please login again.";
            if (d != null)
            {
                ngPrompt.setText(d);
                ngPrompt.setButtons(Yes_No);
                ngPrompt.buttons.getItem('yes').fireInstantly = true;
                ngPrompt.onYes = function() {
                    ngPrompt.setText('Connecting...\n(check your popup blocker)');
                    ngPrompt.setButtons(None);
                    c();
                }
                
                ngPrompt.onNo = function() {
                    ngPrompt.close();
                    ngPrompt = null;
                    NG.core.cancelLoginRequest();
                }
            }
            else
            {
                ngPrompt.setText('Connecting...');
                c();
            }
        }

        var d:ConnectionResult->Void = function(a) {
            switch (a)
            {
                case Success:
                    ngPrompt.setText('Login Successful');
                    ngPrompt.setButtons(Ok);
                    ngPrompt.onYes = ngPrompt.close;
                case Fail(msg):
                    trace('Login Error: ' + msg);
                    ngPrompt.setText('Login failed');
                    ngPrompt.setButtons(Ok);
                    ngPrompt.onYes = ngPrompt.close;
                case Cancelled:
                    if (ngPrompt != null)
                    {
                        ngPrompt.setText('Login cancelled by user');
                        ngPrompt.setButtons(Ok);
                        ngPrompt.onYes = ngPrompt.close;
                    }
                    else
                        trace('Login cancelled via prompt');
            }
        }

        ngPrompt.openCallback = function() {
            NGio.login(whatever, d);
        }

        return ngPrompt;
    }
}

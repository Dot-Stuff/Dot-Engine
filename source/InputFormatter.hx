package;

import Controls.Device;
import flixel.input.keyboard.FlxKey;

using StringTools;

class InputFormatter
{
    public static var dirReg:EReg = new EReg("^(l|r).?-(left|right|down|up)$", "");

    public static function format(key:FlxKey, device:Device):String
    {
        return switch (device)
        {
            case Keys:
                getKeyName(key);
            case Gamepad(id):
                shortenButtonName(FlxG.gamepads.getByID(key).mapping.getInputLabel(id));
        }
    }

    static function getKeyName(key:FlxKey):String
    {
        return switch (key)
        {
            case BACKSPACE: "BckSpc";
            case CONTROL: "Ctrl";
            case ALT: "Alt";
            case CAPSLOCK: "Caps";
            case PAGEUP: "PgUp";
            case PAGEDOWN: "PgDown";
            case ZERO: "0";
            case ONE: "1";
            case TWO: "2";
            case THREE: "3";
            case FOUR: "4";
            case FIVE: "5";
            case SIX: "6";
            case SEVEN: "7";
            case EIGHT: "8";
            case NINE: "9";
            case NUMPADZERO: "#0";
            case NUMPADONE: "#1";
            case NUMPADTWO: "#2";
            case NUMPADTHREE: "#3";
            case NUMPADFOUR: "#4";
            case NUMPADFIVE: "#5";
            case NUMPADSIX: "#6";
            case NUMPADSEVEN: "#7";
            case NUMPADEIGHT: "#8";
            case NUMPADNINE: "#9";
            case NUMPADMULTIPLY: "#*";
            case NUMPADPLUS: "#+";
            case NUMPADMINUS: "#-";
            case NUMPADPERIOD: "#.";
            case SEMICOLON: ";";
            case COMMA: ",";
            case PERIOD: ".";
            case SLASH: "/";
            case GRAVEACCENT: "`";
            case LBRACKET: "[";
            case BACKSLASH: "\\";
            case RBRACKET: "]";
            case QUOTE: "'";
            case PRINTSCREEN: "PrtScrn";
            default: FlxKey.toStringMap.get(key).charAt(0).toUpperCase() + FlxKey.toStringMap.get(key).substr(1).toLowerCase();
        }
    }

    static function shortenButtonName(btnName:String):String
    {
        var name = btnName == null ? '' : btnName.toLowerCase();

        if (name == '')
            return '[?]';

        if (dirReg.match(name))
        {
            name = '${dirReg.matched(1).toUpperCase()} ';
            var b = dirReg.matched(2);

            return name + (b.charAt(0).toUpperCase() + b.substr(1).toLowerCase());
        }

        return name.charAt(0).toUpperCase() + name.substr(1).toLowerCase();
    }
}

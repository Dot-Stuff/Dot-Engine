package;

import Controls.Device;
import flixel.input.keyboard.FlxKeyList;

using StringTools;

class InputFormatter
{
    public static var dirReg:EReg = new EReg("^(l|r).?-(left|right|down|up)$", "");

    public static function format(keyId:Int, device:Device):String
    {
        return switch (device)
        {
            case Keys:
                getKeyName(keyId);
            case Gamepad(id):
                shortenButtonName(FlxG.gamepads.getByID(keyId).mapping.getInputLabel(id));
        }
    }

    static function getKeyName(id:Int):String
    {
        return switch (id)
        {
            case 8: "BckSpc";
            case 17: "Ctrl";
            case 18: "Alt";
            case 20: "Caps";
            case 33: "PgUp";
            case 34: "PgDown";
            case 48: "0";
            case 49: "1";
            case 50: "2";
            case 51: "3";
            case 52: "4";
            case 53: "5";
            case 54: "6";
            case 55: "7";
            case 56: "8";
            case 57: "9";
            case 96: "#0";
            case 97: "#1";
            case 98: "#2";
            case 99: "#3";
            case 100: "#4";
            case 101: "#5";
            case 102: "#6";
            case 103: "#7";
            case 104: "#8";
            case 105: "#9";
            case 106: "#*";
            case 107: "#+";
            case 109: "#-";
            case 110: "#.";
            case 186: ";";
            case 188: ",";
            case 190: ".";
            case 191: "/";
            case 192: "`";
            case 219: "[";
            case 220: "\\";
            case 221: "]";
            case 222: "'";
            case 301: "PrtScrn";
            default: ''; // Fix
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
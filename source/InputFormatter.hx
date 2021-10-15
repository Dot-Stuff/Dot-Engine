package;

import flixel.input.keyboard.FlxKeyList;

using StringTools;

class InputFormatter
{
    public var dirReg:EReg;

    public function format(a, b)
    {
        switch (b._hx_index)
        {
            case 0:
                return getKeyName(a);
            case 1:
                return a = FlxG.gamepads.activeGamepads[b.id].mapping.getInputLabel(a),
                shortenButtonName(a);
        }
    }

    public function getKeyName(a)
    {
        switch (a)
        {
            case 8:
                return "BckSpc";
            case 17:
                return "Ctrl";
            case 18:
                return "Alt";
            case 20:
                return "Caps";
            case 33:
                return "PgUp";
            case 34:
                return "PgDown";
            case 48:
                return "0";
            case 49:
                return "1";
            case 50:
                return "2";
            case 51:
                return "3";
            case 52:
                return "4";
            case 53:
                return "5";
            case 54:
                return "6";
            case 55:
                return "7";
            case 56:
                return "8";
            case 57:
                return "9";
            case 96:
                return "#0";
            case 97:
                return "#1";
            case 98:
                return "#2";
            case 99:
                return "#3";
            case 100:
                return "#4";
            case 101:
                return "#5";
            case 102:
                return "#6";
            case 103:
                return "#7";
            case 104:
                return "#8";
            case 105:
                return "#9";
            case 106:
                return "#*";
            case 107:
                return "#+";
            case 109:
                return "#-";
            case 110:
                return "#.";
            case 186:
                return ";";
            case 188:
                return ",";
            case 190:
                return ".";
            case 191:
                return "/";
            case 192:
                return "`";
            case 219:
                return "[";
            case 220:
                return "\\";
            case 221:
                return "]";
            case 222:
                return "'";
            case 301:
                return "PrtScrn";
            default:
                return a = FlxKeyList.toStringMap.get(a);
                a.charAt(0).toUpperCase() + T.substr(a, 1, null).toLowerCase();
        }
    }

    public function shortenButtonName(buttonName:String)
    {
        buttonName = buttonName == null ? "" : buttonName.toLowerCase();
        if (buttonName == '')
            return '[?]';

        if (dirReg.match(buttonName))
        {
            buttonName = dirReg.matched(1).toUpperCase() + ' ';
            var b = dirReg.matched(2);
            return a + (b.charAt(0).toUpperCase() + T.substr(b, 1, null).toLowerCase());
        }
        return a.charAt(0).toUpperCase() + T.substr(a, 1, null).toLowerCase();
    }
}
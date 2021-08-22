package ui;

import Controls.Control;

class ControlsMenu extends ui.OptionsState.Page
{
    inline static public var COLUMNS = 2;
    static var controlList = Control.createAll();

    static var controlGroups:Array<Array<Control>> = [
        [NOTE_UP, NOTE_DOWN, NOTE_LEFT, NOTE_RIGHT],
        [UI_UP, UI_DOWN, UI_LEFT, UI_RIGHT, ACCEPT, BACK]
    ];

    //var itemGroups:Array<Array<InputItem>> = [for (i in 0...controlGroups.length)];
}
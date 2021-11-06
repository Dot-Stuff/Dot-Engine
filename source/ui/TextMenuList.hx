package ui;

import ui.MenuTypedList.MenuTypedItem;
import ui.AtlasText.AtlasFont;

class TextMenuList extends MenuTypedList
{
    public function createItem(?x:Float, ?y:Float, name:String, font:AtlasFont = Bold, newCallback:Void->Void, ?fireInstantly:Bool = false):Dynamic
    {
        var menuItem = new TextMenuItem(x, y, name, font, newCallback);
        menuItem.fireInstantly = fireInstantly;

        return addItem(name, menuItem);
    }
}

class TextMenuItem extends TextTypedMenuItem
{
    public function new(?x:Float, ?y:Float, newName:String, font:AtlasFont = Bold, newCallback:Void->Void):Void
    {
        super(x, y, new AtlasText(0, 0, newName, font), newName, newCallback);

        setEmptyBackground();
    }
}

class TextTypedMenuItem extends MenuTypedItem
{
    public override function setItem(itemName:String, itemCallback:Void->Void)
    {
        if (label != null)
        {
            label.text = itemName;
            label.alpha = alpha;
            width = label.width;
            height = label.height;
        }

        super.setItem(itemName, itemCallback);
    }

    override function set_label(atlasName:AtlasText):AtlasText
    {
        super.set_label(atlasName);

        setItem(name, callback);

        return atlasName;
    }
}

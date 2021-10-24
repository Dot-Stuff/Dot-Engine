package ui;

import ui.MenuTypedList.MenuTypedItem;
import ui.AtlasText.AtlasFont;

class TextMenuList extends MenuTypedList<TextMenuItem>
{
    public function createItem(?x:Float, ?y:Float, name:String, font:AtlasFont = Bold, newCallback:Void->Void, ?fireInstantly:Bool):Dynamic
    {
        var menuItem = new TextMenuItem(x, y, name, font, newCallback);
        menuItem.fireInstantly = fireInstantly;

        return addItem(name, menuItem);
    }
}

class TextMenuItem extends TextTypedMenuItem
{
    public function new(x:Float, y:Float, newName:String, font:AtlasFont, newCallback:Void->Void):Void
    {
        super(x, y, new AtlasText(0, 0, newName, font), newName, newCallback);
    }
}

class TextTypedMenuItem extends MenuTypedItem
{
    public override function setItem(itemName:String, itemCallback:Void->Void)
    {
        if (label != null)
        {
            label.text = itemName;
            label.set_alpha(alpha);
            width = label.width;
            height = label.height;
        }

        super.setItem(itemName, itemCallback);
    }

    public override function set_label(atlasName:AtlasText):AtlasText
    {
        setItem(name, callback);

        return super.set_label(atlasName);
    }
}

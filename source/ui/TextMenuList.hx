package ui;

import ui.MenuTypedList.MenuTypedItem;
import ui.AtlasText.AtlasFont;

class TextMenuList extends MenuTypedList
{
    public function createItem(x:Float, y:Float, name:String, font:AtlasFont = Bold, callback:Void->Void, ?fireInstantly:Bool = false):Dynamic
    {
        var menuItem = new TextMenuItem(x, y, name, font, callback);
        menuItem.fireInstantly = fireInstantly;

        return addItem(name, menuItem);
    }
}

class TextMenuItem extends TextTypedMenuItem
{
    public function new(x:Float, y:Float, name:String, font:AtlasFont = Bold, callback:Void->Void):Void
    {
        super(x, y, new AtlasText(0, 0, name, font), name, callback);

        setEmptyBackground();
    }
}

class TextTypedMenuItem extends MenuTypedItem
{
    public override function setItem(itemName:String, callback:Void->Void)
    {
        if (label != null)
        {
            label.text = itemName;
            label.alpha = alpha;
            width = label.width;
            height = label.height;
        }

        super.setItem(itemName, callback);
    }

    override function set_label(atlasName:AtlasText):AtlasText
    {
        super.set_label(atlasName);

        setItem(name, callback);

        return atlasName;
    }
}

package sprites;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

using flixel.util.FlxSpriteUtil;

class ShapeSprite extends FlxSprite
{
	private static var shapeSprite:ShapeSprite;

	private function new()
	{
		super(0, 0);
		makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		scrollFactor.set();
		shapeSprite = this;
	}

	public static function getShapeSprite():ShapeSprite
	{
		if (shapeSprite == null)
		{
			shapeSprite = new ShapeSprite();
        }
        return shapeSprite;
	}
}

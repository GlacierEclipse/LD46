package states;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxState;
import sprites.Player;
import sprites.ShapeSprite;
import map.LevelManager;

using flixel.util.FlxSpriteUtil;

class MenuState extends FlxState
{
	public var textMenu:FlxText;

	override public function create()
	{
		super.create();


		FlxG.camera.bgColor = FlxColor.fromRGB(97, 97, 121);
		FlxG.state.bgColor = FlxColor.fromRGB(97, 97, 121);

        textMenu = new FlxText(0, 0, 0, "    RestoPlane\n\n" +
                                        "   By Glacier Eclipse\n\n" +
                                        "Press Enter To Start");
        textMenu.scale.set(0.5,0.5);
        textMenu.size = 30;
        textMenu.screenCenter();



        // Liberation Plan



        add(textMenu);
        
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([ENTER]))
		{
			FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
			{
				FlxG.switchState(new PlayState());
			});
		}
	}

	override function draw()
	{
		super.draw();
	}
}

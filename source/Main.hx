package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.PlayState;
import states.MenuState;

class Main extends Sprite
{
	public function new()
	{
		super();

		#if debug
		addChild(new FlxGame(320, 240, PlayState));
		#else 
		addChild(new FlxGame(320, 240, MenuState));
		#end
	}
}

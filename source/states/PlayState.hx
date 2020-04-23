package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxState;
import sprites.Player;
import sprites.ShapeSprite;
import map.LevelManager;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	public var levelManager:LevelManager;

	
	override public function create()
	{
		super.create();

		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		
		FlxG.camera.bgColor = FlxColor.fromRGB(97, 97, 121);
		FlxG.state.bgColor = FlxColor.fromRGB(97, 97, 121);
		levelManager = new LevelManager();
		
#if debug
	levelManager.loadLevel(11);		
#else 
	levelManager.loadLevel(1);
#end 
		
		
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		levelManager.update();
	}

	override function draw() 
	{
		FlxSpriteUtil.fill(ShapeSprite.getShapeSprite(), FlxColor.WHITE);
		FlxSpriteUtil.fill(ShapeSprite.getShapeSprite(), FlxColor.TRANSPARENT);
		super.draw();
	}
}

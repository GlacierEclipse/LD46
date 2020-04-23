package sprites;

import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.FlxG;
import map.Level;
import flixel.FlxSprite;

class MouseIndicator extends FlxSprite
{
	public function new()
	{
		super(0,0);
		loadGraphic("assets/images/mouseIndicator.png", true, 16,16);
        // moves = false;
        
        FlxG.mouse.useSystemCursor = false;
        FlxG.mouse.visible = false;
	}

	override function update(elapsed:Float)
	{
		setPosition(FlxG.mouse.getPosition().x - 8, FlxMath.bound(FlxG.mouse.getPosition().y - 8,0, 20));

		super.update(elapsed);

		if ((Level.activePlayer == null || !Level.activePlayer.alive)
			&& Level.playerFleet.members.length < Level.playerFleet.maxSize)
		{
            animation.frameIndex = 0;
            FlxTween.tween(this, {alpha : 1}, 0.5);
		}


		if ((Level.activePlayer != null )
			&& (Level.playerFleet.members.length >= Level.playerFleet.maxSize))
			
		{
            animation.frameIndex = 1;
            
            FlxTween.tween(this, {alpha : 0.2}, 0.5);
        }
        
        FlxG.mouse.useSystemCursor = false;
        FlxG.mouse.visible = false;
	}
}

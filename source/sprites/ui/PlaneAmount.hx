package sprites.ui;

import map.Level;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;

class PlaneAmount extends FlxSprite
{
    public var planeAmountText:FlxText;
	public function new()
	{
        super(0,0);
        loadGraphic("assets/images/player.png",false, 16,16);
        scale.set(0.5,0.5);
        scrollFactor.set(0,0);
        setPosition(2,2);

        planeAmountText = new FlxText();
		planeAmountText.scale.set(0.5, 0.5);
		//planeAmountText.text ;
        planeAmountText.size = 12;
        planeAmountText.scrollFactor.set(0,0);
        
        FlxG.state.add(planeAmountText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
        planeAmountText.setPosition(x + 10, y - 1);
        planeAmountText.text = Std.string(Level.playerFleet.maxSize - Level.playerFleet.members.length);
	}
}

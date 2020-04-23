package sprites.ui;

import map.Level;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;

class FuelBar extends FlxBar
{

	public function new(fuelThruster: FuelThruster)
	{
        super(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 16,3, fuelThruster, "fuel", 0, 1, false);
        createColoredEmptyBar(FlxColor.TRANSPARENT, true);
        createColoredFilledBar(FlxColor.ORANGE);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		setPosition(Level.activePlayer.x, Level.activePlayer.y - 7);
	}
}

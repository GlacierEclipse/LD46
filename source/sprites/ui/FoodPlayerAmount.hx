package sprites.ui;

import flixel.util.FlxAxes;
import map.LevelManager;
import flixel.util.FlxAxes;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import map.Level;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;

class FoodPlayerAmount extends FlxSprite
{

	public var foodAmountText:FlxText;

	public function new()
	{
        super(0,0);
        loadGraphic("assets/images/food.png",true, 16,16);
        animation.frameIndex = 0;
        scale.set(0.5,0.5);

        foodAmountText = new FlxText();
		foodAmountText.scale.set(0.5, 0.5);
        foodAmountText.size = 10;
        
        
        FlxG.state.add(foodAmountText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(Level.activePlayer == null)
			return;
		setPosition(Level.activePlayer.x - 4, Level.activePlayer.y - 20);
		foodAmountText.x = x + 9;
		foodAmountText.y = y;
        foodAmountText.text = Std.string(Player.collectedFoodAmount);
        
	}
}

package sprites.ui;

import flixel.util.FlxAxes;
import map.LevelManager;
import map.Level;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;

class FoodLeftAmount extends FlxSprite
{
    public var foodAmountText:FlxText;
	public function new()
	{
        super(0,0);
        loadGraphic("assets/images/food.png",true, 16,16);
        visible =false;
        animation.frameIndex = 0;
        scale.set(0.5,0.5);
        scrollFactor.set(0,0);
        setPosition(2,15);

        foodAmountText = new FlxText();
		foodAmountText.scale.set(0.5, 0.5);
		//planeAmountText.text ;
        foodAmountText.size = 11;
        foodAmountText.y = 0;
        foodAmountText.scrollFactor.set(0,0);
        
        foodAmountText.screenCenter(FlxAxes.X);
        
        FlxG.state.add(foodAmountText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
        
        foodAmountText.text = "Fruit Left: " + Std.string(LevelManager.pickableFood);
        foodAmountText.screenCenter(FlxAxes.X);
	}
}

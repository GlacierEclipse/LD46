package sprites;

import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxObject;
import map.Level;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

enum FoodState
{
	PICKABLE;
	PICKED;
	THROWN;
	EATEN;
	DESTROYED;
}

class Food extends FlxSprite
{
	public var foodState:FoodState;


    public var initPos:FlxPoint;
	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic("assets/images/food.png", true, 16, 16, true);
		// frame = frames.getByIndex(FlxG.random.int(0,3));
		animation.frameIndex = FlxG.random.int(0, 3);
        foodState = FoodState.PICKABLE;
        
        initPos = new FlxPoint();
        initPos.set(x,y);
	}

	override function update(elapsed:Float)
	{
		switch (foodState)
		{
			case THROWN:
                velocity.y += 2.5;
                FlxG.overlap(this, Level.tileLevel, collidedWithTile, FlxObject.separate);
                default:
                    
		}

		super.update(elapsed);

        
		

        handleFoodState();
        
        
	}

	public function collidedWithTile(d:Dynamic, d1:Dynamic)
	{
		// Bounce the fruit
		if (velocity.y > 0)
		{
            velocity.y = 2;
            
            //Can be picked up again
			foodState = FoodState.PICKABLE;
		}
	}

	public function pick()
	{
		// Food was picked, change state
		foodState = FoodState.PICKED;
		kill();
	}

	public function eat()
	{
		foodState = FoodState.EATEN;
        kill();
        
       
	}

	public function throwFood(posX:Float, posY:Float, initVelX:Float, initVelY:Float)
	{
		reset(posX, posY);
		foodState = FoodState.THROWN;
		velocity.x = initVelX;
		velocity.y = initVelY;
	}

	public function handleFoodState()
	{
		if (x - width < 0 || x > Level.levelWidth || y + height > Level.levelHeight)
		{
			foodState = FoodState.DESTROYED;
		}
	}
}

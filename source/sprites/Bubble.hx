package sprites;

import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.shapes.FlxShapeLine;
import map.Level;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Bubble extends FlxShapeCircle
{
	public var minActiveDst:Float;

	public var collectionMinDist:Float;

	public var collectionLines:FlxTypedGroup<CollectionLine>;

	public var collectionRadius:Float;

	public var collectionSpeed:Float;

	public function new(x:Float, y:Float)
	{
		var lineStyle:LineStyle = {
			thickness: 0.0
		};

		minActiveDst = 1.0;

		collectionRadius = 40.0 + minActiveDst;

		super(x, y, collectionRadius, lineStyle, FlxColor.fromRGB(200, 0, 0, 40));
		moves = false;


		collectionMinDist = radius;


		collectionLines = new FlxTypedGroup(10);

		for (i in 0...collectionLines.maxSize)
			collectionLines.add(new CollectionLine(this, null));

		collectionSpeed = 5.0;
	}

	override function update(elapsed:Float)
	{
		setPosition(Level.activePlayer.x - radius, Level.activePlayer.y - radius);


		super.update(elapsed);

		FlxG.overlap(this, Level.food, createLines);

		if(!Level.activePlayer.alive && collectionLines.getFirstDead() != null)
			collectionLines.getFirstDead().kill();
	}

	public function createLines(d:Dynamic, food:Food)
	{
		if(food.foodState != PICKABLE)
			return;

		if (collectionLines.getFirstDead() != null)
		{
			collectionLines.getFirstDead().targetFood = food;
			collectionLines.getFirstDead().reset(0,0);
		}


		/*
			for (food in Level.food)
			{
				var currentDist:Float = Level.activePlayer.center.distanceTo(FlxPoint.weak(food.x + food.width / 2.0, food.y + food.height / 2.0));
				if (food.alive && food.foodState == PICKABLE && currentDist < collectionMinDist + minActiveDst)
				{
					var add = true;
					for (collectionLine in collectionLines)
					{
						if (collectionLine.targetFood == food)
						{
							add = false;
							break;
						}
					}
					if (add)
						collectionLines.add(new CollectionLine(this, food));
					anyFoodDist = true;
				}
			}
		 */
	}

	override function draw()
	{
		// super.draw();
	}
}

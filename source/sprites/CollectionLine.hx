package sprites;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;
import flixel.math.FlxVector;
import map.Level;
import flixel.FlxCamera;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.addons.display.shapes.FlxShapeLine;

using flixel.util.FlxSpriteUtil;

class CollectionLine extends FlxSprite
{
	public var lineCol:FlxColor;
	public var bubble:Bubble;
	public var targetFood:Food;

	public function new(bubble:Bubble, targetFood:Food)
	{
		super(0, 0);
		lineCol = FlxColor.RED;
		this.bubble = bubble;
		this.targetFood = targetFood;
		kill();
		// makeGraphic(Std.int(bubble.radius*2.0), Std.int(bubble.radius*2.0), FlxColor.TRANSPARENT);

		// scrollFactor.set(0, 0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		setPosition(bubble.x, bubble.y);

		if (targetFood == null)
		{
			kill();
			return;
		}
		if(Level.activePlayer == null || !Level.activePlayer.alive)
			{
				targetFood.velocity.x = 0;
			targetFood.velocity.y = 0;
			FlxTween.tween(targetFood, {x: targetFood.initPos.x, y: targetFood.initPos.y}, 1.5, {ease: FlxEase.bounceOut});
				kill();
			return;
			}

		var distMin = bubble.collectionMinDist;
		var currentDist:Float = Level.activePlayer.center.distanceTo(FlxPoint.weak(targetFood.x + targetFood.width / 2.0,
			targetFood.y + targetFood.height / 2.0));

		var lerpVal:Float = FlxMath.remapToRange(currentDist, 0, distMin, 1, 0);

		lineCol = FlxColor.interpolate(FlxColor.RED, FlxColor.WHITE, lerpVal);
		lineCol.alphaFloat = 0.2;

		// Get the food
		var targetVel = FlxVector.weak(Level.activePlayer.center.x - (targetFood.x + targetFood.width / 2.0),
			Level.activePlayer.center.y - (targetFood.y + targetFood.height / 2.0));
		targetVel.normalize();

		targetVel.scale(bubble.collectionSpeed);
		targetFood.velocity.x += targetVel.x;
		targetFood.velocity.y += targetVel.y;
		targetFood.velocity.x = FlxMath.bound(targetFood.velocity.x, -70, 70);
		targetFood.velocity.y = FlxMath.bound(targetFood.velocity.y, -70, 70);

		if (targetFood.foodState != PICKABLE)
		{
			kill();
		}
		if (currentDist > distMin + bubble.minActiveDst + 40 && targetFood.foodState == PICKABLE)
		{
			targetFood.velocity.x = 0;
			targetFood.velocity.y = 0;
			FlxTween.tween(targetFood, {x: targetFood.initPos.x, y: targetFood.initPos.y}, 1.5, {ease: FlxEase.bounceOut});
			kill();
		}
	}

	override function draw()
	{
		var pScreen:FlxPoint = FlxPoint.weak(Level.activePlayer.centerScreenPos.x, Level.activePlayer.centerScreenPos.y);
		// Level.activePlayer.getScreenPosition(pScreen);

		var pScreenFood:FlxPoint = FlxPoint.weak();
		targetFood.getScreenPosition(pScreenFood);
		pScreenFood.add(targetFood.width / 2.0, targetFood.height / 2.0);


		// FlxSpriteUtil.fill(this, FlxColor.TRANSPARENT);
		ShapeSprite.getShapeSprite().drawLine(pScreen.x, pScreen.y, pScreenFood.x, pScreenFood.y, {color: lineCol, thickness: 1.0});

		// this.dirty=true;
		// super.draw();
	}
}

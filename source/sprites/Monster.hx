package sprites;

import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import map.LevelManager;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.FlxObject;
import map.Level;
import flixel.FlxG;
import flixel.FlxSprite;

using flixel.util.FlxSpriteUtil;

class Monster extends FlxSprite
{
	public var currentFood:Int;
	public var neededFood:Int;

	public var foodReached:Bool;

	public var stopMunchingTimer:Float;

	public var foodText:FlxText;

	public var feedingEmitter:FlxEmitter;

	public function new(x:Float, y:Float, neededFood:Int)
	{
		super(x, y);

		loadGraphic("assets/images/monster.png", true, 64, 64);

		this.currentFood = 0;
		this.neededFood = neededFood;
		animation.add("waiting", [0], 1, false);
		animation.add("munching", [0, 1], 9, true);

		foodText = new FlxText(0, 0);

		// FlxG.state.add(foodText);
		foodText.size = 18;
		foodText.scale.x = 0.5;
		foodText.scale.y = 0.5;

		moves = false;

		foodReached = false;


		feedingEmitter = new FlxEmitter();

		feedingEmitter = new FlxEmitter(0, 0, 80);
		feedingEmitter.start(false, 0);
		feedingEmitter.emitting = false;

		for (i in 0...feedingEmitter.maxSize)
		{
			var p:FlxParticle = new FlxParticle();
			var ranCol:Int = FlxG.random.int(0, 2);
			if (ranCol == 0)
				p.makeGraphic(1, 1, FlxColor.fromRGB(51, 51, 124));
			else if (ranCol == 1)
				p.makeGraphic(1, 1, FlxColor.fromRGB(230, 234, 168));
			else
				p.makeGraphic(1, 1, FlxColor.fromRGB(242, 167, 75));

			feedingEmitter.add(p);
		}


		feedingEmitter.launchMode = FlxEmitterMode.CIRCLE;
		feedingEmitter.acceleration.set(0, 80, 0, 90);

		// feedingEmitter.color.set(FlxColor.fromRGB(51,51,124), FlxColor.fromRGB(230, 234, 168));
		// feedingEmitter.alpha.set(1, 1, 0);
		feedingEmitter.scale.set(2, 2, 3, 3, 0, 0);
		feedingEmitter.speed.set(50, 55, 100);
		feedingEmitter.launchAngle.set(-45, -135);
	}

	override function update(elapsed:Float)
	{
		if (LevelManager.gamePaused)
			return;
		stopMunchingTimer -= elapsed;


		super.update(elapsed);

		FlxG.overlap(this, Level.food, collidedWithFood);

		if (stopMunchingTimer <= 0)
		{
			stopMunchingTimer = 0.0;
			animation.play("waiting", true);
		}
		else
		{
			if (animation.frameIndex == 1)
				for (i in 0...3)
					feedingEmitter.emitParticle();
		}


		foodText.text = Std.string(currentFood) + "/" + Std.string(neededFood);
		foodText.setPosition(x + width / 2.0 - foodText.width / 2.0, y - 20.0);

		handleEndGame();
	}

	public function handleEndGame()
	{
		if (Level.endGameState && Level.activePlayer != null)
		{
			moves = true;
			var vecRotation:FlxVector = FlxVector.weak();

			var vec:FlxVector = FlxVector.weak(Level.activePlayer.center.x - x, Level.activePlayer.center.y - y);
			vec.normalize();
			// var angBet : Float = FlxVector.weak(x + 32,y + 32).angleBetween(FlxPoint.weak(Level.activePlayer.center.x, Level.activePlayer.center.y + 50));
			// var angPend : Float = FlxMath.bound(vec.angleBetween(FlxVector.weak(0,0)), -45,45);

			// vec.rotateByDegrees(-angPend);
			// vec.normalize();
			// vec.scale(angBet * 1.0);

			// vecRotation.x = (targetPos.x - x);
			// vecRotation.y = (targetPos.y - y);

			// vecRotation.normalize();
			// vecRotation.scale(5);

			drag.x = 0;

			if (Math.abs(Level.activePlayer.center.x - x) > 100 && vec.x > 0.0)
				velocity.x += 1.0;
			else
				drag.x = 100;

			drag.y = 0;

			// if(Math.abs(Level.activePlayer.center.y + 20 - y) > 0 && vec.y > 0.0)
			var vecY:FlxVector = FlxVector.weak(0, Level.activePlayer.center.y + 50 - y);
			vecY.normalize();
			vecY.scale(5.0);

			velocity.y += vecY.y;
			velocity.y += 0.5;
			// acceleration.y = 1.0;
			// velocity.x = FlxMath.bound(velocity.x, -70.0, 70.0);
			// velocity.y = FlxMath.bound(velocity.y, 0, 20.0);
			if (y - Level.activePlayer.center.y > 50)
				velocity.y = Math.min(-2, velocity.y);
		}
	}

	public function collidedWithFood(d:Dynamic, d1:Food)
	{
		if (d1.foodState == THROWN)
		{
			stopMunchingTimer = 0.7;
			d1.eat();
			animation.play("munching");
			addFood();
			feedingEmitter.setPosition(x + width / 2.0, y + height / 2.0 - 12);
		}
	}

	public function addFood()
	{
		currentFood++;
		// currentFood = Std.int(FlxMath.bound(currentFood, 0, neededFood));
		// Let food overflow
		if (currentFood >= neededFood)
			foodReached = true;
	}

	override function draw()
	{
		if (Level.endGameState && Level.activePlayer != null && !LevelManager.bogbogReleased)
		{
			var pScreen:FlxPoint = FlxPoint.weak();
			getScreenPosition(pScreen);
			pScreen.add(width / 2.0, height / 2.0);

			ShapeSprite.getShapeSprite()
				.drawLine(pScreen.x, pScreen.y, Level.activePlayer.centerScreenPos.x, Level.activePlayer.centerScreenPos.y,
					{color: FlxColor.WHITE, thickness: 1.0});
		}

		super.draw();
	}
}

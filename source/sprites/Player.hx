package sprites;

import flixel.effects.particles.FlxEmitter;
import map.LevelManager;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import map.Level;
import flixel.math.FlxMath;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxState;
import states.PlayState;
import flixel.addons.display.shapes.FlxShapeLine;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import flixel.FlxG;
import openfl.events.FullScreenEvent;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import sprites.FuelThruster;
import sprites.ui.FuelBar;

class Player extends FlxSprite
{
	public var gravity:Float;

	public var collectedFood:FlxTypedGroup<Food>;
	public static var collectedFoodAmount = 0;
	public var center:FlxPoint;
	public var centerScreenPos:FlxPoint;

	public var maxDropCoolDownFrames:Int;
	public var dropCoolDownFrames:Int;

	public var crashedEmitter:FlxEmitter;

	public var explodeEmitter:FlxEmitter;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic("assets/images/player.png");
		// moves = false;

		gravity = 0.4;

		this.centerOrigin();

		collectedFood = new FlxTypedGroup();



		center = new FlxPoint();
		centerScreenPos = new FlxPoint();

		maxDropCoolDownFrames = 3;
		dropCoolDownFrames = maxDropCoolDownFrames;


		crashedEmitter = new FlxEmitter();
		crashedEmitter.makeParticles(2, 2, FlxColor.fromRGB(158,158,158,125), 200);

		crashedEmitter.launchMode = FlxEmitterMode.CIRCLE;
		crashedEmitter.lifespan.set(0, 5);
		crashedEmitter.color.set(FlxColor.fromRGB(158,158,158,125), FlxColor.fromRGB(158,158,158,125), FlxColor.BLACK);
		crashedEmitter.alpha.set(1, 1, 0);
		crashedEmitter.launchAngle.set(-45, -135);


		explodeEmitter = new FlxEmitter(0,0, 50);
		explodeEmitter.makeParticles(4, 4, FlxColor.fromRGB(125,118,107,255), explodeEmitter.maxSize);
		explodeEmitter.start(false, 0);
		explodeEmitter.emitting = false;
		explodeEmitter.launchMode = FlxEmitterMode.CIRCLE;
		//explodeEmitter.launchAngle.set(0, -180);
		explodeEmitter.lifespan.set(0, 5);
		//explodeEmitter.width = 5;
		//explodeEmitter.color.set(FlxColor.fromRGB(158,158,158,125), FlxColor.fromRGB(158,158,158,125), FlxColor.BLACK);
		explodeEmitter.alpha.set(1, 1, 0);
		explodeEmitter.launchAngle.set(-45, -135);
		explodeEmitter.scale.set(1,1,0,0);
		explodeEmitter.acceleration.set(0,120);
		//explodeEmitter.
		collectedFoodAmount = 0;

		setSize(8,8);
		offset.set(4,4);

	}

	override function update(elapsed:Float)
	{
		if(LevelManager.gamePaused)
			return;
		handleInput();

		// Update all the thrusters
		Level.fuelThruster.update(elapsed);

		velocity.add(Level.fuelThruster.velocityThruster.x, Level.fuelThruster.velocityThruster.y);

		applyGravity();

		this.angle = Level.fuelThruster.currentAngle;


		super.update(elapsed);

		handleCollisions();

		Level.collectionBubble.update(elapsed);

		center.x = x + width / 2.0;
		center.y = y + height / 2.0;

		centerScreenPos.copyFrom(getScreenPosition());
		centerScreenPos.x += width / 2.0;
		centerScreenPos.y += height / 2.0;
	}

	public function handleInput()
	{
		dropCoolDownFrames--;

		if (FlxG.keys.anyPressed([Z, SPACE]) && dropCoolDownFrames <= 0)
			dropFood();

		if (dropCoolDownFrames <= 0)
			dropCoolDownFrames = maxDropCoolDownFrames;
	}

	public function handleCollisions()
	{
		FlxG.overlap(this, Level.tileLevel, collidedWithTile, FlxObject.separate);
		FlxG.overlap(this, Level.monster, collidedWithMonster);
		FlxG.overlap(this, Level.food, collectFood);

		if (x + width < 0 || x > Level.levelWidth || y + height > Level.levelHeight)
			kill();
	}

	public function collidedWithTile(d:Dynamic, d1:Dynamic)
	{
		kill();
		FlxG.camera.shake(0.01, 0.1);
	}

	public function collidedWithMonster(d:Dynamic, m:Dynamic)
	{
		if (!Level.endGameState)
		{
			kill();
			FlxG.camera.shake(0.01, 0.1);
		}
	}

	override function kill()
	{
		
		alive=false;
		active =false;
		Level.fuelThruster.update(FlxG.elapsed);
		Level.fuelBar.update(FlxG.elapsed);

		crashedEmitter.setPosition(center.x, center.y);
		crashedEmitter.start(false, 0.07);

		explodeEmitter.setPosition(center.x, center.y);
		for (i in 0...explodeEmitter.maxSize)
			explodeEmitter.emitParticle();
	}

	public function collectFood(d:Dynamic, d1:Food)
	{
		if (FlxMath.distanceBetween(Level.collectionBubble, d1) < Level.collectionBubble.collectionMinDist)
		{
			if (d1.foodState == PICKABLE)
			{
				collectedFood.add(d1);
				d1.pick();
				collectedFoodAmount++;
			}
		}
	}

	public function dropFood()
	{
		if (collectedFood.length > 0)
		{
			var foodDropped:Food = collectedFood.getFirstDead();
			if (foodDropped.foodState == PICKED)
			{
				foodDropped.throwFood(x + FlxG.random.float(0, 16), y + 15, velocity.x, -2.0);
				collectedFood.remove(foodDropped, true);
				collectedFoodAmount--;
			}
		}
	}

	public function applySpeed()
	{
		velocity.x = 20.0;
	}

	public function applyGravity()
	{
		velocity.y += gravity;
	}

	override function draw()
	{
		super.draw();
	}
}

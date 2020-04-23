package sprites;

import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.math.FlxVector;
import map.Level;
import map.LevelManager;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

using flixel.util.FlxSpriteUtil;

enum FuelThrusterType
{
	LEFT;
	CENTER;
	RIGHT;
}

class FuelThruster extends FlxSprite
{
	public var currentAngle:Float;

	public var velocityThruster:FlxPoint;

	public var fuel:Float;
	public var fuelDecrease:Float;

	public var normalSpeed:Float;
	public var pushedOffSpeed:Float;
	public var takeOffSpeed:Float;

	public var rotationSpeed:Float;

	public var usedFuel:Bool;

	public var pushRay:FlxPoint;

	public var thrustEmitter:FlxEmitter;
	public var launchOffEmitter:FlxEmitter;

	public function new(x:Float, y:Float)
	{
		super(0, 0);

		velocityThruster = new FlxPoint(0, 0);
		currentAngle = 0.0;

		fuel = 1.0;

		fuelDecrease = 0.001;

		normalSpeed = 1.0;
		pushedOffSpeed = 10.0;
		takeOffSpeed = 3.0;


		rotationSpeed = 4.1;

		moves = false;

		pushRay = new FlxPoint();

		active = false;

		thrustEmitter = new FlxEmitter(0, 0, 200);
		thrustEmitter.makeParticles(2, 2, FlxColor.WHITE, 200);
		thrustEmitter.start(false, 0);
		thrustEmitter.emitting = false;
		thrustEmitter.launchMode = FlxEmitterMode.CIRCLE;
		thrustEmitter.lifespan.set(0, 1);
		thrustEmitter.color.set(FlxColor.ORANGE, FlxColor.ORANGE, FlxColor.BLACK);
		thrustEmitter.alpha.set(1, 1, 0);
		thrustEmitter.drag.set(0);



		launchOffEmitter = new FlxEmitter(0, 0, 200);
		launchOffEmitter.makeParticles(5, 5, FlxColor.GRAY, 200);
		launchOffEmitter.start(false, 0);
		launchOffEmitter.emitting = false;
		launchOffEmitter.launchMode = FlxEmitterMode.CIRCLE;
		launchOffEmitter.lifespan.set(0, 2);
		launchOffEmitter.scale.set(0.4, 0.4, 1, 1, 0);
		//launchOffEmitter.color.set(FlxColor.GRAY, FlxColor.GRAY, FlxColor.GRAY);
		launchOffEmitter.alpha.set(1, 1, 0);
		// thrustEmitter.st
	}

	public function useFuel(fuel:Float)
	{
		usedFuel = false;
		this.fuel -= fuel;
		fuel = FlxMath.bound(fuel, 0.0, 1.0);

		if (this.fuel <= 0)
			usedFuel = true;
	}

	override function update(elapsed:Float)
	{
		velocityThruster.set(0, 0);
		pushRay.set();

		handleInput();



		velocityThruster.rotate(FlxPoint.weak(0, 0), currentAngle);
		// super.update(elapsed);
	}

	public function handleInput()
	{
		if (FlxG.keys.anyPressed([A, LEFT]))
		{
			currentAngle -= rotationSpeed;
		}

		if (FlxG.keys.anyPressed([W, UP]))
		{
			useFuel(fuelDecrease);

			// Check if there is any surface behind for us to push off
			if (!usedFuel)
			{
				velocityThruster.x = normalSpeed;

				var checkRayEndPoint:FlxPoint = FlxPoint.weak(1, 0).rotate(FlxPoint.weak(), currentAngle);
				var velVector:FlxVector = FlxVector.weak(checkRayEndPoint.x, checkRayEndPoint.y);
				velVector.normalize();
				velVector.scale(-30.0);

				var playerCenter:FlxPoint = FlxPoint.weak();
				playerCenter.copyFrom(Level.activePlayer.center);
				playerCenter.add(velVector.x, velVector.y);
				checkRayEndPoint.copyFrom(playerCenter);





				var hitRay:FlxPoint = FlxPoint.weak();
				if (!Level.tileLevel.ray(Level.activePlayer.center, checkRayEndPoint, hitRay, 2)
					|| Level.monster.getHitbox()
						.containsPoint(FlxPoint.weak(Level.activePlayer.center.x, Level.activePlayer.center.y)
							.add(velVector.x,
								velVector.y)) || Level.monster.getHitbox()
					.containsPoint(FlxPoint.weak(Level.activePlayer.center.x, Level.activePlayer.center.y).add(velVector.x / 2.0, velVector.y / 2.0)))
				{
					// Push off should be stronger than takeoff
					if (FlxVector.weak(Level.activePlayer.velocity.x, Level.activePlayer.velocity.y).dotProdWithNormalizing(velVector.negate()) < 0.0)
						velocityThruster.x = pushedOffSpeed;
					else
						velocityThruster.x = takeOffSpeed;

					velVector.negate();
					pushRay.set(velVector.x, velVector.y);
				}



				velVector.normalize();
				velVector.scale(8);
				thrustEmitter.setPosition(Level.activePlayer.center.x + velVector.x, Level.activePlayer.center.y + velVector.y);
				velVector.scale(2);
				launchOffEmitter.setPosition(Level.activePlayer.center.x - 15 + velVector.x, Level.activePlayer.center.y + velVector.y);
				var minSpeedEmitter:Float = 10.0;
				var maxSpeedEmitter:Float = 10.0;

				// thrustEmitter.velocity.set(velVector.x, velVector.y, velVector.x * 2, velVector.y * 2,
				//						   velVector.x * velocityThruster.x * maxSpeedEmitter, velVector.y * velocityThruster.x * maxSpeedEmitter);

				var emitAngle:Float = currentAngle + 180;
				thrustEmitter.launchAngle.set(emitAngle - 30, emitAngle + 30);

				for (i in 0...5)
					thrustEmitter.emitParticle();
				
				
				if (velocityThruster.x > takeOffSpeed)
				{					
					launchOffEmitter.launchAngle.set(currentAngle - 40, currentAngle + 40);
					launchOffEmitter.width = 30;
					launchOffEmitter.height = 5;
					launchOffEmitter.speed.set(0,90,100);
					
					launchOffEmitter.acceleration.set(0, 50,0,90);
					//launchOffEmitter.drag.set(50,50, 90);

					for (i in 0...20)
						launchOffEmitter.emitParticle();
				}
			}
		}

		if (FlxG.keys.anyPressed([D, RIGHT]))
		{
			currentAngle += rotationSpeed;
		}
	}

	override function draw()
	{
		// super.draw();
	}
}

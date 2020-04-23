package map;

import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxTileFrames;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import sprites.ui.FuelBar;
import sprites.Bubble;
import sprites.FuelThruster;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import sprites.Food;
import sprites.Player;
import sprites.Monster;
import sprites.MouseIndicator;
import sprites.ui.PlaneAmount;
import sprites.ui.FoodLeftAmount;
import sprites.ui.FoodPlayerAmount;


class Level
{
	public var tiledMap:TiledMap;

	public static var tileLevel:FlxTilemap;

	public static var tileBackground:FlxTilemap;

	public static var monster:Monster;

	public static var levelWidth:Int;
	public static var levelHeight:Int;

	public static var food:FlxTypedGroup<Food>;

	// Player Stuff
	public static var activePlayer:Player;

	public static var playerFleet:FlxTypedGroup<Player>;

	public static var fuelThruster:FuelThruster;
	public static var collectionBubble:Bubble;
	public static var fuelBar:FuelBar;

	public static var endGameState:Bool;



	public static var mouseInd:MouseIndicator;

	public function new()
	{
		// tiledMap = new TiledMap(AssetPaths.level_1__tmx);


		endGameState = false;

		mouseInd = new MouseIndicator();
	}

	public function load(level:Int):Void
	{
		tileLevel = new FlxTilemap();
		tileBackground = new FlxTilemap();
		food = new FlxTypedGroup();
		playerFleet = new FlxTypedGroup();

		


		tiledMap = new TiledMap("assets/data/level_" + Std.string(level) + ".tmx");
		var fruitPlacements = new Array<FlxRect>();

		var amountOfFood:Int = 0;

		for (layer in tiledMap.layers)
		{
			var tiledLayer:TiledTileLayer = cast layer;

			if (layer.type == TiledLayerType.TILE)
			{
				if (layer.name == "Bricks")
				{
					tileLevel.loadMapFromArray(tiledLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, FlxTilemapAutoTiling.OFF,
						1, 1);

					tileLevel.frames = FlxTileFrames.fromRectangle(AssetPaths.tiles__png, FlxPoint.weak(16, 16), FlxRect.weak(0, 0), FlxPoint.weak(1, 1));
				}
				else if (layer.name == "Background")
				{
					tileBackground.loadMapFromArray(tiledLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16,
						FlxTilemapAutoTiling.OFF, 1, 1);

					tileBackground.frames = FlxTileFrames.fromRectangle(AssetPaths.tiles__png, FlxPoint.weak(16, 16), FlxRect.weak(0, 0), FlxPoint.weak(1, 1));
				}
			}


			if (layer.type == TiledLayerType.OBJECT)
			{
				var objectLayer:TiledObjectLayer = cast layer;
				if (layer.name == "Food")
				{
					amountOfFood = Std.parseInt(objectLayer.properties.get("amount"));
					for (object in objectLayer.objects)
					{
						fruitPlacements.push(new FlxRect(object.x, object.y, object.width, object.height));
					}
				}

				if (layer.name == "Monster")
				{
					for (object in objectLayer.objects)
					{
						monster = new Monster(object.x, object.y, Std.parseInt(object.properties.get("food")));
					}
				}
				if (layer.name == "Player")
				{
					playerFleet.maxSize = Std.parseInt(layer.properties.get("fleet"));
					
				}
			}
		}

		levelWidth = tiledMap.fullWidth;
		levelHeight = tiledMap.fullHeight;

		for (i in 0...amountOfFood)
		{
			// Pick a random rectangle
			var placementRect = fruitPlacements[FlxG.random.int(0, fruitPlacements.length - 1)];

			// Pick a random position inside the rectangle
			var placementPos = FlxPoint.weak(FlxG.random.float(placementRect.x - 8, placementRect.right - 14),
				FlxG.random.float(placementRect.y - 8, placementRect.bottom - 14));
			food.add(new Food(placementPos.x, placementPos.y));
		}

		if(level == 12)
			endGameState = true;
	}

	public function addToState(state:FlxState) : Void
	{
		state.add(tileBackground);
		state.add(tileLevel);
		state.add(food);
		state.add(monster);
		state.add(monster.foodText);
		state.add(monster.feedingEmitter);

		state.add(playerFleet);


		state.add(mouseInd);

		state.add(new PlaneAmount());
		state.add(new FoodLeftAmount());
		state.add(new FoodPlayerAmount());
	}

	public function cleanLevel(state:FlxState) : Void
	{
		state.remove(tileBackground, true);
		state.remove(tileLevel, true);

		state.remove(food, true);
		state.remove(monster.foodText, true);
		state.remove(monster, true);
		state.remove(playerFleet, true);


		state.remove(collectionBubble.collectionLines, true);
		state.remove(collectionBubble, true);
		state.remove(fuelBar, true);
		state.remove(fuelThruster, true);

		state.remove(mouseInd, true);
		

		tileLevel = null;
		tileBackground = null;
		food = null;
		playerFleet = null;
		monster = null;
		activePlayer = null;
		collectionBubble.collectionLines = null;
		collectionBubble = null;

		
	}

	public function addPlayer(x:Float, y:Float)
	{
		if(playerFleet.members.length + 1 > playerFleet.maxSize)
			return;
		
		if (activePlayer == null)
		{
			activePlayer = new Player(x, y);
			fuelThruster = new FuelThruster(0, 0);
			fuelBar = new FuelBar(fuelThruster);
			collectionBubble = new Bubble(0, 0);

			playerFleet.add(activePlayer);
			FlxG.state.add(collectionBubble);
			FlxG.state.add(collectionBubble.collectionLines);
			FlxG.state.add(fuelBar);
			FlxG.state.add(fuelThruster);

			FlxG.state.add(fuelThruster.thrustEmitter);
			FlxG.state.add(fuelThruster.launchOffEmitter);


			FlxG.state.add(activePlayer.crashedEmitter);
			FlxG.state.add(activePlayer.explodeEmitter);
		}
		else
		{
			FlxG.state.remove(activePlayer.crashedEmitter);
			FlxG.state.remove(activePlayer.explodeEmitter);

			playerFleet.members[0].active = false;
			activePlayer = new Player(x, y);
			playerFleet.add(activePlayer);


			FlxG.state.add(activePlayer.crashedEmitter);
			FlxG.state.add(activePlayer.explodeEmitter);
		}
		FlxG.camera.follow(activePlayer, FlxCameraFollowStyle.TOPDOWN, 0.2);

		Level.fuelThruster.fuel = 1.0;
	}
}

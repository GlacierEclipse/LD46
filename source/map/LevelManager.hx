package map;

import flixel.util.FlxAxes;
import states.MenuState;
import sprites.Food.FoodState;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sprites.ShapeSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.FlxG;
import sprites.Player;
import flixel.FlxState;

class LevelManager
{
	public var activeLevel:Level;
	public var currentLevelNum:Int;

	// Level Completed
	public var levelCompleteScreen:FlxSprite;
	public var levelCompleteText:FlxText;

	// Level Incomplete
	public var levelIncompleteScreen:FlxSprite;
	public var levelInCompleteText:FlxText;
	public var gameWaitingRestart:Bool;

	public static var gamePaused:Bool;

	// Game End
	public static var gameEndingRunning:Bool;

	public var endScreen:FlxSprite;
	public var endReleaseBogBogText:FlxText;
	public var endCompleteText1:FlxText;
	public var endCompleteText2:FlxText;

	public static var bogbogReleased:Bool;

	public var mouseDown:Bool;
	public var mouseNo:Bool;

	public var tutorialManager:TutorialManager;

	public static var pickableFood:Int = 0;
	public static var pickedFood:Int = 0;
	public static var thrownFood:Int = 0;

	public function new()
	{
		tutorialManager = new TutorialManager();
		activeLevel = new Level();
		currentLevelNum = 1;

		levelCompleteScreen = new FlxSprite();
		levelCompleteScreen.scrollFactor.set();
		levelCompleteScreen.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true);
		levelCompleteText = new FlxText();

		levelInCompleteText = new FlxText();

		levelIncompleteScreen = new FlxSprite();
		levelIncompleteScreen.scrollFactor.set();
		levelIncompleteScreen.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true);


		endReleaseBogBogText = new FlxText();
		endCompleteText1 = new FlxText();
		endCompleteText2 = new FlxText();

		endScreen = new FlxSprite();
		endScreen.scrollFactor.set();
		endScreen.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true);

	}

	public function update()
	{
		
		tutorialManager.handleTutorialShit(currentLevelNum);

		if ((Level.activePlayer == null || !Level.activePlayer.alive) && FlxG.mouse.justPressed)
		{
			var playerDropPos:FlxPoint = FlxG.mouse.getPosition();
			activeLevel.addPlayer(playerDropPos.x, 0.0);
		}
		if ((Level.activePlayer == null || !Level.activePlayer.active || !Level.activePlayer.alive)
			&& (currentLevelNum != 1 && currentLevelNum != 12))
		{
			trace(currentLevelNum);
			FlxG.camera.follow(null);
			FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, 0, 0.02);
			if (FlxG.mouse.screenX > FlxG.width / 2.0 + FlxG.width / 4.0)
				FlxG.camera.scroll.x += FlxMath.remapToRange(FlxG.mouse.screenX, FlxG.width / 2.0 + FlxG.width / 4.0, FlxG.width, 0.5, 4.0);
			else if (FlxG.mouse.screenX < FlxG.width / 2.0 - FlxG.width / 4.0)
				FlxG.camera.scroll.x -= FlxMath.remapToRange(FlxG.mouse.screenX, FlxG.width / 2.0 - FlxG.width / 4.0, 0, 0.5, 4.0);
			// FlxG.camera.scroll.y = FlxG.mouse.getPosition().y;
		}
		else {
			
		}

		if ((Level.activePlayer == null || !Level.activePlayer.active || !Level.activePlayer.alive)
			&& ( currentLevelNum == 12))
		{
			FlxG.camera.scroll.x = 0;
			FlxG.camera.scroll.y = 0;
		}


		if (Level.monster.foodReached)
		{
			handleNextLevelSwitch();
			// Level.monster.foodReached = false;
		}

		pickableFood = 0;
		pickedFood = 0;
		thrownFood = 0;
		
		for (food in Level.food)
		{
			if (food.foodState == FoodState.PICKABLE)
				pickableFood++;


			if (food.foodState == FoodState.PICKED)
				pickedFood++;


			if (food.foodState == FoodState.THROWN)
				thrownFood++;
		}

		if (!gamePaused)
			handleRestart();
		if (!gamePaused)
			handleEndGame();
		if (gameEndingRunning)
			handleEndGameLogic();
		if (gameWaitingRestart)
		{
			if (FlxG.keys.anyJustPressed([R]))
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, fadeInCompleteRestartLevel);
			}
		}
	}



	public function handleRestart()
	{
		if (Level.activePlayer == null)
			return;
		// RESTART STATES
		// 1. Player ran out of fleet and the current active player isn't alive
		// 2. The food that is currently in the game isn't enough to feed bog bog


		// Loop all the food in the game and check
		// a. How many are pickable
		// b. How many are in the players inventory
		// c. How many did BogBog eat
		// d. Thrown food


		
	


		var totalFoodActive:Int = pickableFood + pickedFood + thrownFood + Level.monster.currentFood;


		var playerRanOutOfFleet:Bool = !Level.activePlayer.alive && (Level.playerFleet.members.length == Level.playerFleet.maxSize);
		var foodNotEnough:Bool = totalFoodActive < Level.monster.neededFood;


		if (playerRanOutOfFleet || foodNotEnough)
		{
			handleRestartGameAnimation();
		}
	}

	public function handleEndGame()
	{
		if (Level.activePlayer == null)
			return;


		// 97, 20
		if (Level.activePlayer.x > 97 * 16)
		{
			gamePaused = true;
			gameEndingRunning = true;


			// We lerp the player to 108, 25
			FlxTween.tween(Level.activePlayer, {x: 108 * 16, y: 23 * 16}, 2, {
				onStart: function(_)
				{
					FlxTween.tween(Level.monster, {x: 108 * 16, y: 23 * 16 + 25}, 2);
				},
				onComplete: function(_)
				{
					endReleaseBogBogText.text = "Press Enter to Release BogBog";


					endReleaseBogBogText.alpha = 0;
					endReleaseBogBogText.size = 20;
					endReleaseBogBogText.scale.set(0.5, 0.5);
					endReleaseBogBogText.scrollFactor.set();
					endReleaseBogBogText.screenCenter();


					FlxG.camera.follow(Level.monster, 0.08);




					FlxG.state.add(endReleaseBogBogText);


					FlxTween.tween(endReleaseBogBogText, {alpha: 1}, 2, {
						onComplete: function(_) {}
					});
				}
			});
		}
	}

	public function handleEndGameLogic()
	{
		if (FlxG.keys.anyJustPressed([ENTER]))
		{
			bogbogReleased = true;
			FlxTween.tween(endReleaseBogBogText, {alpha: 0}, 1, {
				onComplete: function(_)
				{
					// Release Bog bog :(


					FlxTween.tween(Level.monster, {x: 108 * 16, y: 45 * 16}, 2, {
						onComplete: function(_)
						{
							endScreen.alpha = 0;


							FlxTween.tween(endScreen, {alpha: 0.4}, 4, {
								onStart: function(_)
								{
									endScreen.alpha = 0;
									FlxG.state.add(endScreen);





									// Lerp the water somehow MAYBE
								},
								onComplete: function(_)
								{
									// End Credits
									endCompleteText1.text = "Thank you for playing :)\n";


									endCompleteText1.text += "By @GlacierEclipse\n";


									endCompleteText1.text += "Created For LD46\n";


									endCompleteText1.text += "Press Escape to return to menu";


									endCompleteText1.alpha = 0;
									endCompleteText1.size = 20;
									endCompleteText1.scale.set(0.5, 0.5);
									endCompleteText1.scrollFactor.set();
									endCompleteText1.screenCenter();




									FlxG.state.add(endCompleteText1);


									FlxTween.tween(endCompleteText1, {alpha: 1}, 2, {
										onComplete: function(_) {}
									});
								}
							});
						}
					});
				}
			});
		}


		if (FlxG.keys.anyJustPressed([ESCAPE]))
		{
			// Back to main menu
			// IMPLEMENT MENU MAX
			FlxG.switchState(new MenuState());
		}
	}

	public function loadLevel(level:Int):Void
	{
		currentLevelNum = level;


		activeLevel.load(level);


		activeLevel.addToState(FlxG.state);


		FlxG.camera.setScrollBoundsRect(0, 0, Level.levelWidth, Level.levelHeight, true);




		FlxG.state.add(ShapeSprite.getShapeSprite());
	}

	public function handleNextLevelSwitch()
	{
		// FlxG.camera.fade(FlxColor.BLACK, 1, false, fadeInCompleteSwitchLevels);
		


		if (gamePaused)
		{
			if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
				FlxG.camera.fade(FlxColor.BLACK, 1, false, fadeInCompleteSwitchLevels);

			return;
		}
		levelCompleteScreen.alpha = 0;
		gamePaused = true;


		FlxTween.tween(levelCompleteScreen, {alpha: 0.7}, 1, {
			onStart: function(_)
			{
				levelCompleteScreen.alpha = 0;
				FlxG.state.add(levelCompleteScreen);
			},
			onComplete: function(_)
			{
				levelCompleteText.text = "Level Complete!\n\n";
				// Mob mob texts each level
				if (currentLevelNum < 4)
				{
					levelCompleteText.text += "Mogmog is starting to come alive..\n\n";
				}
				levelCompleteText.text += "Press Enter to Continue";

				levelCompleteText.alpha = 0;
				levelCompleteText.size = 20;
				levelCompleteText.scale.set(0.5, 0.5);
				levelCompleteText.scrollFactor.set();
				levelCompleteText.screenCenter();




				FlxG.state.add(levelCompleteText);


				FlxTween.tween(levelCompleteText, {alpha: 1}, 2, {});
			}
		});
	}

	public function handleRestartGameAnimation()
	{
		levelIncompleteScreen.alpha = 0;
		gamePaused = true;


		FlxTween.tween(levelIncompleteScreen, {alpha: 0.5}, 1, {
			onStart: function(_)
			{
				levelIncompleteScreen.alpha = 0;
				FlxG.state.add(levelIncompleteScreen);
			},
			onComplete: function(_)
			{
				levelInCompleteText.text = "                    The end?\n\n";
				// Mob mob texts each level


				levelInCompleteText.text += (12 - currentLevelNum) + " more levels to fully feed mog mog\n\n";


				levelInCompleteText.text += "             Press R to Restart";


				levelInCompleteText.alpha = 0;
				levelInCompleteText.size = 20;
				levelInCompleteText.scale.set(0.5, 0.5);
				levelInCompleteText.scrollFactor.set();
				levelInCompleteText.screenCenter();




				FlxG.state.add(levelInCompleteText);

				gameWaitingRestart = true;
				FlxTween.tween(levelInCompleteText, {alpha: 1}, 2, {
					onComplete: function(_)
					{
						
					}
				});
			}
		});
	}

	public function fadeInCompleteSwitchLevels()
	{
		loadNextLevel();




		// FlxG.timeScale=0;
		FlxG.camera.fade(FlxColor.BLACK, 1, true, function()
		{
			gamePaused = false;
		});
	}

	public function fadeInCompleteRestartLevel()
	{
		gameWaitingRestart = false;




		clean();
		loadLevel(currentLevelNum);




		// FlxG.timeScale=0;
		FlxG.camera.fade(FlxColor.BLACK, 1, true, function()
		{
			gamePaused = false;
		});
	}

	public function loadNextLevel():Void
	{
		tutorialManager.currentTutStage = 0;
		clean();


		currentLevelNum++;


		loadLevel(currentLevelNum);
	}

	public function clean()
	{
		
		FlxG.state.remove(ShapeSprite.getShapeSprite(), true);


		FlxG.state.remove(levelCompleteScreen);
		FlxG.state.remove(levelCompleteText);


		FlxG.state.remove(levelIncompleteScreen);
		FlxG.state.remove(levelInCompleteText);





		activeLevel.cleanLevel(FlxG.state);
	}

	public function addToState(state:FlxState):Void
	{
		activeLevel.addToState(state);
	}
}

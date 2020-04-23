package map;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxG;
import flixel.util.FlxAxes;
import flixel.text.FlxText;
import flixel.FlxSprite;

class TutorialManager
{
	// TUTORIAL
	public var tutorialScreen:FlxSprite;
	public var tutorialText1:FlxText;
	public var tutorialText2:FlxText;
	public var tutorialText3:FlxText;
	public var tutorialText4:FlxText;

	public var currentTutStage:Float = 0;
	public var tutorialActive:Bool;

	public function new()
	{
		// TUTORIAL
		currentTutStage = 0;

		tutorialText1 = new FlxText();
		tutorialText1.scale.set(0.5, 0.5);
		tutorialText1.text = "Press anywhere to drop your plane from above";
		tutorialText1.size = 15;


		tutorialText2 = new FlxText();
		tutorialText2.scale.set(0.5, 0.5);
		tutorialText2.text = "Press Left/Right to control the rotation\n\n" + "   Press W/Forward to use your thrusters\n\n" + "   Watch your fuel!";
		tutorialText2.size = 15;


		tutorialText3 = new FlxText();
		tutorialText3.scale.set(0.5, 0.5);
		tutorialText3.text = "Collect Fruits by getting near them\n\n"
			+ "   Press Space/Z to throw fruits\n\n"
			+ "Find Mogmog and feed him with delicous fruits..we need him";
		tutorialText3.size = 15;

		tutorialText4 = new FlxText();
		tutorialText4.scale.set(0.5, 0.5);
		tutorialText4.text = "Feed Mogmog with fruits";
		tutorialText4.size = 15;
    }
    public function handleTutorialShit(currentLevelNum:Int)
        {
            // LAST HOUR OF LUDUM ARGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
            if (currentLevelNum == 1)
            {
                // TUTORIAL SHIT
                if (currentTutStage == 0)
                {
                    LevelManager.gamePaused = true;
                    tutorialText1.alpha = 0;
                    tutorialText1.setPosition(-100, 20);
                    tutorialText1.screenCenter(FlxAxes.X);
                    // tutorialText1.cen
                    FlxG.state.add(tutorialText1);
    
    
                    FlxTween.tween(tutorialText1, {alpha: 1}, 0.5);
    
                    currentTutStage = 0.5;
                }
                // TUTORIAL SHIT
                else if (currentTutStage > 0 && currentTutStage < 0.9)
                {
                    if (tutorialText1.alpha > 0.9)
                    {
                        if (FlxG.mouse.justPressed)
                        {
                            LevelManager.gamePaused = false;
                            FlxTween.tween(tutorialText1, {alpha: 0}, 0.9, {
                                onComplete: function(_)
                                {
                                    LevelManager.gamePaused = true;
                                    currentTutStage = 1.0;
                                }
                            });
                        }
                    }
                }
    
                // TUTORIAL SHIT
                else if (currentTutStage >= 1.0 && currentTutStage < 1.1)
                {
                    tutorialText2.alpha = 0;
                    tutorialText2.setPosition(-100, 20);
                    tutorialText2.screenCenter(FlxAxes.X);
                    // tutorialText1.cen
                    FlxG.state.add(tutorialText2);
    
    
                    FlxTween.tween(tutorialText2, {alpha: 1}, 3.5);
    
                    currentTutStage = 2.0;
                }
    
                // TUTORIAL SHIT
                else if (currentTutStage >= 2.0 && currentTutStage < 2.1)
                {
                    if (tutorialText2.alpha > 0.9)
                    {
                        FlxTween.tween(tutorialText2, {alpha: 0}, 2.9, {
                            onComplete: function(_)
                            {
                                LevelManager.gamePaused = false;
                                currentTutStage = 3.0;
                            }
                        });
                    }
                }
                // TUTORIAL SHIT
                else if (currentTutStage >= 3.0 && currentTutStage < 7.0)
                {
                    currentTutStage += FlxG.elapsed;
                }
                else if (currentTutStage >= 7.0 && currentTutStage < 7.1)
                {
                    LevelManager.gamePaused = true;
                    tutorialText3.alpha = 0;
                    tutorialText3.setPosition(-100, 20);
                    tutorialText3.screenCenter(FlxAxes.X);
    
                    FlxG.state.add(tutorialText3);
    
    
                    FlxTween.tween(tutorialText3, {alpha: 1}, 4.5, {
                        onComplete: {
                            function(_)
                            {
                                LevelManager.gamePaused = false;
                            }
                        }
                    });
    
                    currentTutStage = 8.0;
                }
    
            }
            else if (currentLevelNum == 2)
            {
                // TUTORIAL SHIT
                if (currentTutStage == 0)
                {
                    tutorialText1 = new FlxText();
                    tutorialText1.scale.set(0.5,0.5);
                    tutorialText1.size = 14;
                    //gamePaused = true;
                    tutorialText1.alpha = 0;
                    tutorialText1.text = "Rotate and use your thrusters towards a surface when getting close\n"
                        + "               This will give you a boost off the surface";
                    tutorialText1.setPosition(-100, 20);
                    tutorialText1.screenCenter(FlxAxes.X);
                    tutorialText1.scrollFactor.set();
                    // tutorialText1.
                    FlxG.state.add(tutorialText1);
    
    
                    FlxTween.tween(tutorialText1, {alpha: 1}, 3.0, {onComplete: function(_)
                    {
                        //gamePaused = false;
                    }});
    
                    currentTutStage = 0.5;
                }
            }
            else if (currentLevelNum == 3)
            {
                // TUTORIAL SHIT
                if (currentTutStage == 0)
                {
                    //gamePaused = true;
                    tutorialText1 = new FlxText();
                    tutorialText1.scale.set(0.5,0.5);
                    tutorialText1.size = 14;
    
                    tutorialText1.alpha = 0;
                    tutorialText1.text = "You have 2 planes now!\n" + "    Use them wisely..";
                    tutorialText1.setPosition(-100, 20);
                    tutorialText1.screenCenter(FlxAxes.X);
                    tutorialText1.scrollFactor.set();
                    // tutorialText1.
                    FlxG.state.add(tutorialText1);
    
    
                    FlxTween.tween(tutorialText1, {alpha: 1}, 3.0, {onComplete: function(_)
                    {
                        //gamePaused = false;
                    }});
    
                    currentTutStage = 0.5;
                }
            }
        }
}

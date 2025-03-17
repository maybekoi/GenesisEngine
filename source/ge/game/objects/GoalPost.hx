package ge.game.objects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

class GoalPost extends FlxSprite
{
    public var triggered:Bool = false;
    private var spinCount:Int = 0;
    private var maxSpins:Int = 16;
    
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y - 64);
        
        loadGraphic("assets/images/gameObjects/GoalPost.png", true);   
        frames = FlxAtlasFrames.fromSparrow("assets/images/gameObjects/GoalPost.png", "assets/images/gameObjects/GoalPost.xml");
        
        animation.addByPrefix("idle", "idle", 24, false);
        animation.addByPrefix("spin", "spin", 24, false);
        animation.addByPrefix("sonic", "sonic", 24, false);
        
        animation.play("idle");
        
        offset.set(width / 2, height);
        
        immovable = true;
        solid = true;
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (animation.finished && animation.name == "spin") {
            spinCount++;
            if (spinCount >= maxSpins) {
                animation.play("sonic");
            } else {
                animation.play("spin");
            }
        }
    }
    
    public function trigger():Void
    {
        if (!triggered) {
            triggered = true;
            spinCount = 0;
            animation.play("spin");
                        
            // Play sound effect if you have one
            // FlxG.sound.play(Util.getSound("goalpost"));
        }
    }
} 
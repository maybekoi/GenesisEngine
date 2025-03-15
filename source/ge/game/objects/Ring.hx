package ge.game.objects;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;

class Ring extends FlxSprite
{
    private static inline var FIXED_WIDTH_RADIUS:Float = 10;
    private static inline var FIXED_HEIGHT_RADIUS:Float = 10;
    private static inline var SCATTERED_WIDTH_RADIUS:Float = 12;
    private static inline var SCATTERED_HEIGHT_RADIUS:Float = 12;
    private static inline var GRAVITY_FORCE:Float = 0.09375;
    private static inline var BOUNCE_FACTOR:Float = -0.75;
    private static inline var MAX_LIFESPAN:Int = 256;
    
    public var isScattered:Bool = false;
    private var lifespan:Int = 0;
    private var floorCheckTimer:Int = 0;
    
    public function new(x:Float, y:Float, ?scattered:Bool = false, ?xSpeed:Float = 0, ?ySpeed:Float = 0)
    {
        super(x, y);
        
        loadGraphic("assets/images/gameObjects/Ring.png", true);
        frames = FlxAtlasFrames.fromSparrow("assets/images/gameObjects/Ring.png", "assets/images/gameObjects/Ring.xml");
        
        animation.addByPrefix("spin", "spin", 8, true);
        animation.addByPrefix("collect", "collect", 12, false);
        
        animation.play("spin");
        
        isScattered = scattered;
        if (isScattered)
        {
            setSize(SCATTERED_WIDTH_RADIUS * 2 + 1, SCATTERED_HEIGHT_RADIUS * 2 + 1);
            offset.set((frameWidth - width) / 2, (frameHeight - height) / 2 - 4);
            
            velocity.set(xSpeed, ySpeed);
            
            floorCheckTimer = Std.random(4);
            
            lifespan = MAX_LIFESPAN;
        }
        else
        {
            setSize(FIXED_WIDTH_RADIUS * 2 + 1, FIXED_HEIGHT_RADIUS * 2 + 1);
            offset.set((frameWidth - width) / 2, (frameHeight - height) / 2 - 4);
        }
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (isScattered)
        {
            velocity.y += GRAVITY_FORCE;
            
            floorCheckTimer = (floorCheckTimer + 1) % 4;
            if (floorCheckTimer == 0 && velocity.y > 0)
            {
                if (checkFloor())
                {
                    velocity.y *= BOUNCE_FACTOR;
                }
            }
            
            lifespan--;
            if (lifespan <= 0 || x < FlxG.camera.scroll.x - 50 || x > FlxG.camera.scroll.x + FlxG.width + 50)
            {
                kill();
            }
            
            var frameDuration = Math.floor(MAX_LIFESPAN * 2 / Math.max(1, lifespan));
            frameDuration = Std.int(Math.min(Math.max(frameDuration, 2), 16));
            animation.getByName("spin").frameRate = 60 / frameDuration;
        }
    }
    
    private function checkFloor():Bool
    {
        var floorY = FlxG.height - 50;
        return (y + height / 2 >= floorY);
    }
    
    public function collect():Void
    {
        animation.play("collect");
        
        Globals.rings++;
        
        animation.finishCallback = function(name:String) {
            if (name == "collect") {
                kill();
            }
        };
    }
    
    public static function scatterRings(x:Float, y:Float, count:Int = 20):Array<Ring>
    {
        var rings:Array<Ring> = [];
        
        for (i in 0...count)
        {
            var angle = (i * (360 / count)) * (Math.PI / 180);
            var speed = 2 + Math.random() * 2;
            
            var xSpeed = Math.cos(angle) * speed;
            var ySpeed = Math.sin(angle) * speed - 2;
            
            var ring = new Ring(x, y, true, xSpeed, ySpeed);
            rings.push(ring);
        }
        
        return rings;
    }
} 
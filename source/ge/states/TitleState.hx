package ge.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.addons.display.FlxBackdrop;
import backend.Discord;
import lime.app.Application;

class TitleState extends FlxState
{
    var sonicemblmT:FlxSprite;
    var sonicemblmB:FlxSprite;
    var sonic:FlxSprite;
    var copyright:FlxSprite;
    var presents:FlxBitmapText;
    var bgTop:FlxBackdrop;
    var bgBottom:FlxBackdrop;
    
    override public function create()
    {
        super.create();

        #if desktop
        if (!Discord.isInitialized)
        {
            Discord.initialize();
            Application.current.onExit.add (function (exitCode) {
                Discord.shutdown();
            });
        }
        #end
        
        FlxG.camera.bgColor = FlxColor.BLACK;
        
        var font = koi.Fonts.getPresents();
        presents = new FlxBitmapText();
        try {
            if (font == null) throw "Font is null";
            presents.font = font;            
            presents.text = "SONIC TEAM AND KOI\nPRESENT";
            presents.alignment = CENTER;
            presents.alpha = 0;
            presents.scale.set(2.5, 2.5);
            presents.screenCenter();
            add(presents);
        } catch (e:Dynamic) {
            trace("Error loading bitmap font: " + e);
            presents = null;
            var regularText = new FlxText(0, 50, FlxG.width, "SONIC TEAM PRESENTS");
            regularText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER);
            regularText.alpha = 0;
            regularText.screenCenter();
            add(regularText);
        }

        bgTop = new FlxBackdrop(Util.getImage('title/TitleBGTop'), X, 0, 0);
        bgTop.velocity.x = 100;
        bgTop.scale.set(2.75,2.75);
        bgTop.alpha = 0;
        bgTop.y = 97;
        add(bgTop);

        bgBottom = new FlxBackdrop(Util.getImage('title/TitleBGBottom'), X, 0, 0);
        bgBottom.velocity.x = 100;
        bgBottom.scale.set(2.75,2.75);
        bgBottom.y = 434;
        bgBottom.alpha = 0;
        add(bgBottom);

        sonicemblmT = new FlxSprite(0, 60);
        sonicemblmT.loadGraphic(Util.getImage('title/sonicemblmT'));
        sonicemblmT.screenCenter();
        sonicemblmT.scale.set(2.5, 2.5);
        sonicemblmT.alpha = 0;
        add(sonicemblmT);

        sonic = new FlxSprite(607.5, 360);
        sonic.frames = Util.getSparrow('title/SonicTitle');
        sonic.animation.addByPrefix("initial", "Idle", 12, false);
        sonic.animation.addByIndices("loop", "Idle", [6, 7], "", 12, true);
        sonic.scale.set(2.5, 2.5);
        sonic.alpha = 0;
        add(sonic);

        sonicemblmB = new FlxSprite(0, 60);
        sonicemblmB.loadGraphic(Util.getImage('title/sonicemblmB'));
        sonicemblmB.screenCenter();
        sonicemblmB.scale.set(2.5, 2.5);
        sonicemblmB.alpha = 0;
        add(sonicemblmB);
        
        copyright = new FlxSprite(1109, 675);
        copyright.loadGraphic(Util.getImage('title/SegaCredit'));
        copyright.scale.set(2.5, 2.5);
        copyright.alpha = 0;
        add(copyright);
        
        startTitleSequence();
    }
    
    private function startTitleSequence()
    {
        new FlxTimer().start(0.5, function(tmr:FlxTimer)
        {
            FlxTween.tween(presents, {alpha: 1}, 1);
            
            new FlxTimer().start(2.0, function(tmr:FlxTimer)
            {
                FlxTween.tween(presents, {alpha: 0}, 1);
                
                new FlxTimer().start(1.0, function(tmr:FlxTimer)
                {
                    FlxTween.tween(sonicemblmT, {alpha: 1}, 1);
                    FlxTween.tween(sonicemblmB, {alpha: 1}, 1);
                    FlxTween.tween(bgTop, {alpha: 1}, 1);
                    FlxTween.tween(bgBottom, {alpha: 1}, 1);
                    FlxTween.tween(sonic, {alpha: 1}, 1, {
                        onComplete: function(_) {
                            FlxTween.tween(sonic, {y: 253}, 0.35, {ease: FlxEase.quadOut});
                            sonic.animation.play('initial');
                            sonic.animation.finishCallback = function(name:String) {
                                if (name == "initial") {
                                    sonic.animation.play("loop");
                                }
                            };
                        }
                    });
                    FlxTween.tween(copyright, {alpha: 1}, 1);
                });
            });
        });
    }
    
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ONE)
        {
            trace("bgBottom Y: " + bgBottom.y);
        }

        if (FlxG.keys.justPressed.TWO)
        {
            trace("bgTop Y: " + bgTop.y);
        }
        
        if (FlxG.keys.justPressed.ENTER)
        {            
            FlxG.switchState(new ge.states.DataSelectState());
        }
    }
}


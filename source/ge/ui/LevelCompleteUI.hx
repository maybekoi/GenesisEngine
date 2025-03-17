package ge.ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.util.FlxColor;

class LevelCompleteUI extends FlxSpriteGroup
{
    var oval:FlxSprite;
    var sonicText:FlxSprite;
    var hasText:FlxSprite;
    var passedText:FlxSprite;
    var actText:FlxSprite;
    
    var scoreText:FlxText;
    var timeBonusText:FlxText;
    var ringBonusText:FlxText;
    
    var scoreValue:FlxText;
    var timeBonusValue:FlxText;
    var ringBonusValue:FlxText;
    
    var timeBonus:Int = 0;
    var ringBonus:Int = 0;
    
    private var hud:HUD;
    
    public function new(level:Int)
    {
        super();
        
        hud = cast(FlxG.state.members.filter(function(basic) return Std.is(basic, HUD))[0], HUD);
        
        oval = new FlxSprite(0, 0);
        oval.loadGraphic(Util.getImage("ui/level_complete/ovalthing"));
        oval.scale.set(3.5, 3.5);
        oval.screenCenter();
        oval.y -= 100;
        oval.x += 200;
        oval.alpha = 0;
        add(oval);
        
        sonicText = new FlxSprite(0, oval.y - 20);
        sonicText.loadGraphic(Util.getImage("ui/level_complete/sonicText"));
        sonicText.scale.set(3.5, 3.5);
        sonicText.screenCenter(X);
        sonicText.y += 5;
        sonicText.x -= 9999;
        add(sonicText);
        
        hasText = new FlxSprite(0, oval.y);
        hasText.loadGraphic(Util.getImage("ui/level_complete/hasText"));
        hasText.scale.set(3.5, 3.5);
        hasText.screenCenter(X);
        hasText.y += 5;
        hasText.x += 9999;
        add(hasText);
        
        passedText = new FlxSprite(0, oval.y + 20);
        passedText.loadGraphic(Util.getImage("ui/level_complete/passedText"));
        passedText.scale.set(3.5, 3.5);
        passedText.screenCenter(X);
        passedText.y += 100;
        passedText.x -= 9999;
        add(passedText);
        
        actText = new FlxSprite(0, oval.y + 40);
        actText.loadGraphic(Util.getImage("ui/level_complete/ActText"));
        actText.frames = Util.getSparrow("ui/level_complete/ActText");
        actText.animation.addByPrefix("act1", "Act10000", 24, false);
        actText.animation.addByPrefix("act2", "Act20000", 24, false);
        actText.animation.addByPrefix("act3", "Act30000", 24, false);
        switch (level)
        {
            case 1:
                actText.animation.play("act1");
            case 2:
                actText.animation.play("act2");
            case 3:
                actText.animation.play("act3");
            default:
                actText.animation.play("act1");
        }
        actText.scale.set(3.5, 3.5);
        actText.screenCenter(X);
        actText.x -= 50;
        actText.x += 9999;
        add(actText);
        
        var baseY = oval.y + 120;
        
        scoreText = new FlxText(0, baseY, 0, "SCORE", 48);
        scoreText.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.YELLOW);
        scoreText.x = FlxG.width / 2 - 200;
        scoreText.alpha = 0;
        add(scoreText);
        
        timeBonusText = new FlxText(0, baseY + 40, 0, "TIME BONUS", 48);
        timeBonusText.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.YELLOW);
        timeBonusText.x = FlxG.width / 2 - 200;
        timeBonusText.alpha = 0;
        add(timeBonusText);
        
        ringBonusText = new FlxText(0, baseY + 80, 0, "RING BONUS", 48);
        ringBonusText.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.YELLOW);
        ringBonusText.x = FlxG.width / 2 - 200;
        ringBonusText.alpha = 0;
        add(ringBonusText);
        
        calculateBonuses();
        
        scoreValue = new FlxText(0, baseY, 0, Std.string(Globals.score), 48);
        scoreValue.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        scoreValue.x = FlxG.width / 2 + 100;
        scoreValue.alpha = 0;
        add(scoreValue);
        
        timeBonusValue = new FlxText(0, baseY + 40, 0, Std.string(timeBonus), 48);
        timeBonusValue.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        timeBonusValue.x = FlxG.width / 2 + 100;
        timeBonusValue.alpha = 0;
        add(timeBonusValue);
        
        ringBonusValue = new FlxText(0, baseY + 80, 0, Std.string(ringBonus), 48);
        ringBonusValue.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        ringBonusValue.x = FlxG.width / 2 + 100;
        ringBonusValue.alpha = 0;
        add(ringBonusValue);
        
        forEach(function(sprite) {
            sprite.scrollFactor.set(0, 0);
        });
    }
    
    private function calculateBonuses():Void
    {
        var minutes = Math.floor(Globals.time / 60);
        var seconds = Globals.time % 60;
        
        if (minutes < 2) {
            timeBonus = 5000;
        } else if (minutes < 3) {
            timeBonus = 3000;
        } else if (minutes < 4) {
            timeBonus = 1000;
        } else {
            timeBonus = 0;
        }
        
        ringBonus = Globals.rings * 100;
    }

    override public function update(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.NINE)
        {
            trace("hasText X: " + hasText.x);
        }
    }
    
    public function show():Void
    {
        FlxTween.tween(oval, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
        
        var sonicFinalX = 491;
        var hasFinalX = 812.5;
        var passedFinalX = 580.5;
        var actTextFinalX = 813.5;
        
        sonicText.y = 200;
        hasText.y = 200;
        passedText.y = 281;
        actText.y = 290;
        
        FlxTween.tween(sonicText, {x: sonicFinalX}, 0.5, {ease: FlxEase.backOut, startDelay: 0.2});
        FlxTween.tween(hasText, {x: hasFinalX}, 0.5, {ease: FlxEase.backOut, startDelay: 0.4});
        FlxTween.tween(passedText, {x: passedFinalX}, 0.5, {ease: FlxEase.backOut, startDelay: 0.6});
        FlxTween.tween(actText, {x: actTextFinalX}, 0.5, {ease: FlxEase.backOut, startDelay: 0.8});
        
        FlxTween.tween(scoreText, {alpha: 1}, 0.5, {startDelay: 1.2});
        FlxTween.tween(scoreValue, {alpha: 1}, 0.5, {startDelay: 1.2});
        
        FlxTween.tween(timeBonusText, {alpha: 1}, 0.5, {startDelay: 1.5});
        FlxTween.tween(timeBonusValue, {alpha: 1}, 0.5, {startDelay: 1.5, onComplete: function(_) {
            startScoreCounting();
        }});
        
        FlxTween.tween(ringBonusText, {alpha: 1}, 0.5, {startDelay: 1.8});
        FlxTween.tween(ringBonusValue, {alpha: 1}, 0.5, {startDelay: 1.8});
    }
    
    private function startScoreCounting():Void {
        var duration:Float = 2.0;
        var startScore = Globals.score;
        var finalScore = startScore + timeBonus + ringBonus;
        
        FlxTween.num(startScore, finalScore, duration, {startDelay: 2.0}, function(num:Float) {
            var currentScore = Math.floor(num);
            Globals.score = currentScore;
            scoreValue.text = Std.string(currentScore);
            
            var remainingTotal = finalScore - currentScore;
            var remainingTimeBonus = Math.floor(timeBonus * (remainingTotal / (timeBonus + ringBonus)));
            var remainingRingBonus = Math.floor(ringBonus * (remainingTotal / (timeBonus + ringBonus)));
            
            timeBonusValue.text = Std.string(remainingTimeBonus);
            ringBonusValue.text = Std.string(remainingRingBonus);
            
            if (hud != null) {
                hud.tweenScore(startScore, finalScore, duration);
            }
        });
    }
} 